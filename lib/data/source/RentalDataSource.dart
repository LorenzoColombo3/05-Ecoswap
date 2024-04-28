import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
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
      onLoadFinished(rental);
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
      rethrow;
    }
  }

  @override
  Future<void> loadFromFirebaseToLocal(String userId) async {
    getAllUserRentals(userId).then((firebaseList) => loadAllRental(firebaseList));
  }

  @override
  Future<List<Rental>> getAllRentals() async{
    try {
      DataSnapshot snapshot = await _databaseReference.child('rentals').get();
      Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;
      if (data != null) {
        List<Rental> rentals = data.values.map((value) => Rental.fromMap(value)).toList();
        return rentals;
      } else {
        return [];
      }
    } catch (error) {
      print('Errore durante il recupero di tutti i rentals da Firebase: $error');
      return [];
    }
  }

  @override
  Future<List<Rental>> getAllUserRentals(String userId) async{
    try {
      DataSnapshot snapshot = await _databaseReference
          .child('rentals')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      List<Rental> rentals = [];
      Map<Object?, Object?>? values =snapshot.value as Map<Object?, Object?>?;
      if (values != null) {
        values.forEach((key, data) {
          Map<String, dynamic> data2 = Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
          Rental rental = Rental.fromMap(data2);
          rentals.add(rental);
        });
      }

      return rentals;
    } catch (error) {
      print('Errore durante il recupero di tutti i rental per userId da Firebase: $error');
      return [];
    }

  }

  @override
  Future<Rental?> getRental(String idToken) async{
    Rental rental;
    try {
      final snapshot = await _databaseReference.child(idToken).get();
      if (snapshot.exists) {
        Map<String, dynamic>? exchangeData = snapshot.value as Map<String, dynamic>?;
        String imagePath = exchangeData?['imagePath'];
        String userId = exchangeData?['userId'];
        String title = exchangeData?['title'];
        String description = exchangeData?['description'];
        String dailyCost = exchangeData?['dailyCost'];
        String maxDaysRent = exchangeData?['maxDaysRent'];
        double lat = exchangeData?['lat'];
        double long= exchangeData?['long'];
        String idToken = exchangeData?['idToken'];
        rental = Rental(imagePath, userId, title, description, lat, long, dailyCost, maxDaysRent, idToken);
        return rental;
      } else {
        print('No data available.');
        return null;
      }
    } catch (error) {
      print('Errore durante il recupero dell\'rental da Firebase: $error');
      return null;
    }
  }
}
  

