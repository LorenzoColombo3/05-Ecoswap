import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../../model/Rental.dart';
import 'BaseRentalDataSource.dart';

class RentalDataSource extends BaseRentalDataSource {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();


  @override
  Future<String?> loadRental(Rental rental) async {
    try {
      final String databasePath = 'rentals';
      String imageUrl = await uploadImage(rental.imagePath);
      rental.imageUrl = imageUrl;
      await _databaseReference.child(databasePath).child(rental.idToken).set(rental.toMap());
      await loadLocal(rental);
      return 'Success';
    } catch (error) {
      print('Errore durante il caricamento del rental: $error');
      return 'Errore durante il caricamento del rental: $error';
    }
  }

  Future<String> uploadImage(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      String fileName = basename(imagePath);
      String filePath = 'rental/$fileName';
      await FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);
      String downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      return '';
    }
  }

  @override
  Future<void> loadFromFirebaseToLocal(Rental rental) {
    // TODO: implement loadFromFirebaseToLocal
    throw UnimplementedError();
  }

// Rimuovi altri metodi per brevità
}
