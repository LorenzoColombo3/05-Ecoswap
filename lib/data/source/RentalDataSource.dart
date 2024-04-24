import 'dart:io';

import 'package:eco_swap/data/source/BaseRentalDataSource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/Rental.dart';

class RentalDataSource extends BaseRentalDataSource {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  Future<String?> loadRental(Rental rental) async {
    try {
      final String databasePath = 'rentals';
      String imageUrl = await uploadImage(rental.imagePath);
      rental.imageUrl = imageUrl; // Aggiungi l'URL dell'immagine all'oggetto Rental
      await _databaseReference.child(databasePath).child(rental.idToken).set(rental.toMap());
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
      String filePath = 'rental/$fileName';
      await FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);
      String downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      return '';
    }
  }
}
