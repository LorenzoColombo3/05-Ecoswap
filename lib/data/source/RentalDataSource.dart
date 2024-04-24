import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../../model/Rental.dart';
import 'BaseRentalDataSource.dart';

class RentalDataSource extends BaseRentalDataSource {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  static late Database _database;
  static bool _isDatabaseInitialized = false;

  @override
  Future<String?> loadRental(Rental rental) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }
      final String databasePath = 'rentals';
      String imageUrl = await uploadImage(rental.imagePath);
      rental.imageUrl = imageUrl;
      await _databaseReference.child(databasePath).child(rental.idToken).set(rental.toMap());
      return 'Success';
    } catch (error) {
      print('Errore durante il caricamento del rental: $error');
      return 'Errore durante il caricamento del rental: $error';
    }
  }

  @override
  Future<void> loadLocal(Rental rental) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }
      await _database.insert('rentals', rental.toMap());
    } catch (error) {
      print('Errore durante il caricamento locale del rental: $error');
    }
  }

  @override
  Future<List<Rental>> getLocalRentals() async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      final List<Map<String, dynamic>> maps = await _database.query('rentals');
      return List.generate(maps.length, (i) {
        return Rental.fromMap(maps[i]);
      });
    } catch (error) {
      print('Errore durante il recupero dei rental locali: $error');
      return [];
    }
  }

  @override
  Future<void> updateLocalRental(Rental rental) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      await _database.update(
        'rentals',
        rental.toMap(),
        where: 'idToken = ?',
        whereArgs: [rental.idToken],
      );
    } catch (error) {
      print('Errore durante l\'aggiornamento del rental locale: $error');
    }
  }

  @override
  Future<void> deleteLocalRental(String idToken) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      await _database.delete(
        'rentals',
        where: 'idToken = ?',
        whereArgs: [idToken],
      );
    } catch (error) {
      print('Errore durante l\'eliminazione del rental locale: $error');
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

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'rentals_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE rentals('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'imagePath TEXT, '
              'userId TEXT, '
              'title TEXT, '
              'description TEXT, '
              'latitude REAL, '
              'longitude REAL, '
              'dailyCost TEXT, '
              'maxDaysRent TEXT, '
              'idToken TEXT, '
              'imageUrl TEXT)',
        );
      },
      version: 1,
    );
    _isDatabaseInitialized = true;
  }

// Rimuovi altri metodi per brevità
}
