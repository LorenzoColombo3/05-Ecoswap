import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../../model/Rental.dart';
import 'BaseRentalDataSource.dart';

class RentalDataSource extends BaseRentalDataSource {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();
  int _lastPositionSeach = 0;

  @override
  Future<String?> loadRental(Rental rental) async {
    try {
      final String databasePath = 'rentals';
      String imageUrl = await uploadImage(rental.imagePath);
      rental.imageUrl = imageUrl;
      rental.position =
          (await _getAddressFromLatLng(rental.latitude, rental.longitude))!;
      await _databaseReference
          .child(databasePath)
          .child(rental.idToken)
          .set(rental.toMap());
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
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> loadFromFirebaseToLocal(String userId) async {
    getAllUserRentals(userId)
        .then((firebaseList) => loadAllRental(firebaseList));
  }

  @override
  Future<List<Rental>> getAllRentals() async {
    //TODO non mostrare i rental stessi dello user
    try {
      DataSnapshot snapshot = await _databaseReference
          .child('rentals')
          .get();
      Map<Object?, Object?>? data = snapshot.value as Map<Object?, Object?>?;
      List<Rental> rentals = [];
      if (data != null) {
        data.forEach((key, data) {
          Map<String, dynamic> data2 =
              Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
          if (data['unitNumber'] != data['unitRented']) {
            Rental rental = Rental.fromMap(data2);
            rentals.add(rental);
          }
        });
        return rentals;
      } else {
        return [];
      }
    } catch (error) {
      print(
          'Errore durante il recupero di tutti i rentals da Firebase: $error');
      return [];
    }
  }

  @override
  Future<List<Rental>> getAllUserRentals(String userId) async {
    try {
      DataSnapshot snapshot = await _databaseReference
          .child('rentals')
          .orderByChild('userId')
          .equalTo(userId)
          .get();

      List<Rental> rentals = [];
      Map<Object?, Object?>? values = snapshot.value as Map<Object?, Object?>?;
      if (values != null) {
        values.forEach((key, data) {
          Map<String, dynamic> data2 =
              Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
          Rental rental = Rental.fromMap(data2);
          rentals.add(rental);
        });
      }

      return rentals;
    } catch (error) {
      print(
          'Errore durante il recupero di tutti i rental per userId da Firebase: $error');
      return [];
    }
  }

  @override
  Future<Rental?> getRental(String idToken) async {
    Rental rental;
    try {
      final snapshot = await _databaseReference.child(idToken).get();
      if (snapshot.exists) {
        Map<String, dynamic>? exchangeData =
            snapshot.value as Map<String, dynamic>?;
        String imagePath = exchangeData?['imagePath'];
        String userId = exchangeData?['userId'];
        String title = exchangeData?['title'];
        String description = exchangeData?['description'];
        String dailyCost = exchangeData?['dailyCost'];
        String maxDaysRent = exchangeData?['maxDaysRent'];
        double lat = exchangeData?['lat'];
        double long = exchangeData?['long'];
        String idToken = exchangeData?['idToken'];
        String imageUrl = exchangeData?['imageUrl'];
        String position = exchangeData?['position'];
        String dateLoad = exchangeData?['dateLoad'];
        String unitNumber = exchangeData?['unitNumber'];
        String unitRented = exchangeData?['unitRented'];
        rental = Rental(
            imagePath,
            userId,
            title,
            description,
            lat,
            long,
            dailyCost,
            maxDaysRent,
            idToken,
            imageUrl,
            position,
            dateLoad,
            unitNumber,
            unitRented);
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

  double _calculateDistance(
      double latUser, double longUser, double latRent, double longRent) {
    const int earthRadiusKm = 6371; // Raggio medio della Terra in chilometri
    double lat1Rad = radians(latUser);
    double lat2Rad = radians(latRent);
    double lon1Rad = radians(longUser);
    double lon2Rad = radians(longRent);
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
  Future<List<Rental>> getRentalsInRadius(
      double latUser, double longUser, double radiusKm, int startIndex) async {
    List<Rental> rentalsInRadius = [];
    List<Rental> allRentals = await getAllRentals();
    Rental rental;
    allRentals.sort((a, b) {
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
    for (int i = startIndex;
        i <= startIndex + 8 && i < allRentals.length;
        i++) {
      rental = allRentals[i];
      double distance = _calculateDistance(
          latUser, longUser, rental.latitude, rental.longitude);
      if (distance <= radiusKm) {
        rentalsInRadius.add(rental);
      }
    }
    return rentalsInRadius;
  }

  @override
  Future<List<Rental>> searchItems(
      double latUser, double longUser, String query) async {
    List<Rental> rentals = [];
    List<Rental> rentalsApp = await _searchOnKeyword(query);
    for (int i = _lastPositionSeach;
        i <= _lastPositionSeach + 5 && i < rentalsApp.length;
        i++) {
      rentals.add(rentalsApp[i]);
    }
    _lastPositionSeach = _lastPositionSeach + rentals.length;
    return rentals;
  }

  Future<List<Rental>> _searchOnKeyword(String query) async {
    List<Rental> rentals = [];
    DataSnapshot snapshot = await _databaseReference
        .child('rentals')
        .get();
    Map<Object?, Object?>? data = snapshot.value as Map<Object?, Object?>?;
    if (data != null) {
      data.forEach((key, data) {
        Map<String, dynamic> dataMap =
            Map<String, dynamic>.from(data as Map<dynamic, dynamic>);
        if (dataMap['title'].toString().contains(query) ||
            dataMap['description'].toString().contains(query)) {
          if (data['unitNumber'] != data['unitRented']) {
            Rental rental = Rental.fromMap(dataMap);
            rentals.add(rental);
          }
        }
      });
    }
    return rentals;
  }

  Future<String?> _getAddressFromLatLng(
      double latitude, double longitude) async {
    String? _currentCity;
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      _currentCity = place.locality;
      return _currentCity;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  void updateRentalData(Rental rental){
    try {
      Map<String, dynamic> updateData = {
        'unitNumber': rental.unitNumber,
        'unitRented': rental.unitRented,
      };
      _databaseReference.child('rentals').child(rental.idToken).update(
          updateData);
      //TODO testare il funzionamento dell'update locale quando fatta una prenotazione da un altro dispositivo
      onUpdateFinished(rental);
    }catch(e){
      print("errore durante l'update  $e");
    }
  }
}
