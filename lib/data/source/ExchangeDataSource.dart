import 'dart:io';

import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExchangeDataSource extends BaseExchangeDataSource{
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Future<String?> loadExchange(Exchange exchange) async {
    try {
      final String databasePath = 'exchanges';
      String imageUrl = await uploadImage(exchange.imagePath);
      exchange.imageUrl = imageUrl;
      await _databaseReference.child(databasePath).child(exchange.idToken).set(exchange.toMap());
      return 'Success';
    } catch (error) {
      print('Errore durante il caricamento del rental: $error');
      return 'Errore durante il caricamento del rental: $error';
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
  Future<void> loadLocal(Exchange exchange) {
    // TODO: implement loadLocal
    throw UnimplementedError();
  }
}