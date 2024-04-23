import 'dart:io';

import 'package:eco_swap/data/source/BaseRentalDataSource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../model/Rental.dart';

class RentalDataSource implements BaseRentalDataSource {
  final storageRef = FirebaseStorage.instance.ref(); // Rimuovi questa riga
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  @override
  Future<String?> loadRental(Rental rental) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return 'A';
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path;
      String filePath = 'rental/$fileName';
      await storageRef.child(filePath).putFile(imageFile);
      String downloadURL = await storageRef.child(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      return '';
    }
  }
}
