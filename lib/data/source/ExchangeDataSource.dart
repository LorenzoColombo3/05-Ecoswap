import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';

class ExchangeDataSource extends BaseExchangeDataSource {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  int _lastPositionSeach = 0;

  @override
  Future<String?> loadExchange(Exchange exchange) async {
    try {
      final String databasePath = 'exchanges';
      String imageUrl = await uploadImage(exchange.imagePath);
      exchange.imageUrl = imageUrl;
      exchange.position = (await _getAddressFromLatLng(exchange.latitude, exchange.longitude))!;
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
  Future<List<Exchange>> getAllExchanges() async{
    try {
      DataSnapshot snapshot = await _databaseReference.child('exchanges').get();
      Map<Object?, Object?>? data =snapshot.value as Map<Object?, Object?>?;
      List<Exchange> exchanges = [];
      if (data != null) {
        data.forEach((key, data) {
          Map<String, dynamic> data2 = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
          Exchange exchange = Exchange.fromMap(data2);
          exchanges.add(exchange);
        });
        return exchanges;
      } else {
        return [];
      }
    } catch (error) {
      print('Errore durante il recupero di tutti i exchanges da Firebase: $error');
      return [];
    }
  }


  @override
  Future<List<Exchange>> getAllUserExchanges(String userId) async{

    try {
      DataSnapshot snapshot = await _databaseReference.child('exchanges').orderByChild('userId').equalTo(userId).get();
      List<Exchange> exchanges = [];
      var values = snapshot.value; // Rimuovi il cast esplicito per ora
      if (values is Map) { // Verifica se i valori sono una mappa
        values.forEach((key, data) {
          if (data is Map<String, dynamic>) { // Verifica se i dati sono mappa di stringhe dinamiche
            Exchange exchange = Exchange.fromMap(data);
            exchanges.add(exchange);
          }
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
        String position = exchangeData?['position'];
        String dateLoad = exchangeData?['dateLoad'];
        exchange = Exchange(imagePath, userId, title, description, latitude, longitude, idToken, imageUrl, position, dateLoad);
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
    print(allExchanges.length);
    Exchange exchange;
    allExchanges.sort((a, b) {
      double distanceA = _calculateDistance(
        latUser,
        longUser,
        a.latitude,
        a.longitude,
      );
      double distanceB = _calculateDistance(
        latUser,
        longUser,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });
    for (int i=startIndex; i<startIndex+5 && i < allExchanges.length; i++) {
      exchange = allExchanges[i];
      double distance = _calculateDistance(latUser, longUser, exchange.latitude, exchange.longitude);
      print(radiusKm);
      print(distance);
      if (distance <= radiusKm) {
        exchangesInRadius.add(exchange);
      }
    }
    return exchangesInRadius;
  }

  @override
  Future<List<Exchange>> searchItems(double latUser, double longUser, String query) async {
    List<Exchange> exchanges = [];
    List<Exchange> exchangesApp = await _searchOnKeyword(query);
    for (int i=_lastPositionSeach; i<=_lastPositionSeach+5 && i < exchangesApp.length; i++) {
      exchanges.add(exchangesApp[i]);
    }
    _lastPositionSeach=_lastPositionSeach + exchanges.length;
    return exchanges;
  }

  Future<List<Exchange>> _searchOnKeyword(String query) async {
    List<Exchange> rentals = [];
    DataSnapshot snapshot = await _databaseReference.child('exchanges').get();
    Map<Object?, Object?>? data = snapshot.value as Map<Object?, Object?>?;
    if (data != null) {
      data.forEach((key, data) {
        Map<String, dynamic> dataMap =
        Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
        if (dataMap['title'].toString().contains(query) ||
            dataMap['description'].toString().contains(query)) {
          Exchange exchange = Exchange.fromMap(dataMap);
          rentals.add(exchange);
        }
      });
    }
    return rentals;
  }

  Future<String?> _getAddressFromLatLng(double latitude, double longitude) async {
    String? _currentCity;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      _currentCity = place.locality;
      return _currentCity;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
