import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';

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
  Future<void> loadFromFirebaseToLocal(Exchange exchange) {
    // TODO: implement loadFromFirebaseToLocal
    throw UnimplementedError();
  }
}
