import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';
//TODO: controllare se i getter per gli exchange da remoto funzionano, perchè dannoun rttore nel logcat
class ExchangeDataSource extends BaseExchangeDataSource {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();


  @override
  Future<String?> loadExchange(Exchange exchange) async {
    try {
      final String databasePath = 'exchanges';
      String imageUrl = await uploadImage(exchange.imagePath);
      exchange.imageUrl = imageUrl;
      await _databaseReference.child(databasePath).child(exchange.idToken).set(exchange.toMap());
      onLoadFinished(exchange);
      return 'Success';
    } catch (error) {
      print('Errore durante il caricamento dell\'exchange: $error');
      return 'Errore durante il caricamento dell\'exchange: $error';
    }
  }


  @override
  Future<String> uploadImage(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      String fileName = imageFile.path.split('/').last;
      String filePath = 'exchange/$fileName';
      await FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);
      String downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      return '';
    }
  }

  @override
  Future<void> loadFromFirebaseToLocal(String userId) async{
     getAllUserExchanges(userId).then((firebaseList) => loadAllExchange(firebaseList));
  }

  @override
  Future<List<Exchange>> getAllExchanges() async {
    try {
      DataSnapshot snapshot = await _databaseReference.child('exchanges').get();
      Map<String?, dynamic>? data = snapshot.value as Map<String?, dynamic>?;
      if (data != null) {
        List<Exchange> exchanges = data.values.map((value) => Exchange.fromMap(value)).toList();
        return exchanges;
      } else {
        return [];
      }
    } catch (error) {
      print('Errore durante il recupero di tutti gli exchange da Firebase: $error');
      return [];
    }
  }

  @override
  Future<List<Exchange>> getAllUserExchanges(String userId) async{
    try {
      DataSnapshot snapshot = await _databaseReference
          .child('exchanges')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      List<Exchange> exchanges = [];
      Map<Object?, Object>? values =snapshot.value as Map<Object?, Object>? ;
      if (values != null) {
        values.forEach((key, data) {
          Map<String, dynamic> data2 = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
          Exchange exchange = Exchange.fromMap(data2);
          exchanges.add(exchange);
        });
      }

      return exchanges;
    } catch (error) {
      print('Errore durante il recupero di tutti gli exchange per userId da Firebase: $error');
      return [];
    }

    }

  @override
  Future<Exchange?> getExchange(String idToken) async {
    Exchange exchange;
    try {
      final snapshot = await _databaseReference.child(idToken).get();
      if (snapshot.exists) {
        Map<String, dynamic>? exchangeData = snapshot.value as Map<String, dynamic>?;
        String imagePath = exchangeData?['imagePath'];
        String userId = exchangeData?['userId'];
        String title = exchangeData?['title'];
        String description = exchangeData?['description'];
        double latitude = exchangeData?['latitude'];
        double longitude = exchangeData?['longitude'];
        String idToken = exchangeData?['idToken'];
        String imageUrl = exchangeData?['imageUrl'];
        exchange = Exchange(imagePath, userId, title, description, latitude, longitude, idToken, imageUrl);
        return exchange;
      } else {
        print('No data available.');
        return null;
      }
    } catch (error) {
      print('Errore durante il recupero dell\'exchange da Firebase: $error');
      return null;
    }
  }

  double _calculateDistance(double latUser, double longUser, double latExch, double longExch) {
    const int earthRadiusKm = 6371; // Raggio medio della Terra in chilometri

    double lat1Rad = radians(latUser);
    double lat2Rad = radians(latExch);
    double lon1Rad = radians(longUser);
    double lon2Rad = radians(longExch);
    double deltaLat = lat2Rad - lat1Rad;
    double deltaLon = lon2Rad - lon1Rad;

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double radians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Future<List<Exchange>> getExchangesInRadius(double latUser, double longUser, double radiusKm, int startIndex) async {
    List<Exchange> exchangesInRadius = [];
    List<Exchange> allExchanges = await getAllExchanges();
    Exchange exchange;
    for (int i=startIndex; i<=startIndex+10; i++) {
      exchange = allExchanges[i];
      double distance = _calculateDistance(latUser, longUser, exchange.latitude, exchange.longitude);
      if (distance <= radiusKm) {
        exchangesInRadius.add(exchange);
      }
    }
    return exchangesInRadius;
  }

}
