import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';

class ExchangeDataSource extends BaseExchangeDataSource {
  late Database _database;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  bool _isDatabaseInitialized = false;

  @override
  Future<String?> loadExchange(Exchange exchange) async {
    try {
      final String databasePath = 'exchanges';
      String imageUrl = await uploadImage(exchange.imagePath);
      exchange.imageUrl = imageUrl;
      await _databaseReference.child(databasePath).child(exchange.idToken).set(exchange.toMap());
      return 'Success';
    } catch (error) {
      print('Errore durante il caricamento dell\'exchange: $error');
      return 'Errore durante il caricamento dell\'exchange: $error';
    }
  }

  @override
  Future<void> loadLocal(Exchange exchange) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      await _database.insert('exchanges', exchange.toMap());
    } catch (error) {
      print('Errore durante il caricamento locale dell\'exchange: $error');
    }
  }

  @override
  Future<List<Exchange>> getLocalExchanges() async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      final List<Map<String, dynamic>> maps = await _database.query('exchanges');
      return List.generate(maps.length, (i) {
        return Exchange.fromMap(maps[i]);
      });
    } catch (error) {
      print('Errore durante il recupero degli exchange locali: $error');
      return [];
    }
  }

  @override
  Future<void> updateLocalExchange(Exchange exchange) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      await _database.update(
        'exchanges',
        exchange.toMap(),
        where: 'idToken = ?',
        whereArgs: [exchange.idToken],
      );
    } catch (error) {
      print('Errore durante l\'aggiornamento dell\'exchange locale: $error');
    }
  }

  @override
  Future<void> deleteLocalExchange(String idToken) async {
    try {
      if (!_isDatabaseInitialized) {
        await _initializeDatabase();
      }

      await _database.delete(
        'exchanges',
        where: 'idToken = ?',
        whereArgs: [idToken],
      );
    } catch (error) {
      print('Errore durante l\'eliminazione dell\'exchange locale: $error');
    }
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'exchanges_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE exchanges('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'imagePath TEXT, '
              'userId TEXT, '
              'title TEXT, '
              'description TEXT, '
              'latitude REAL, '
              'longitude REAL, '
              'idToken TEXT, '
              'imageUrl TEXT)',
        );
      },
      version: 1,
    );
    _isDatabaseInitialized = true;
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
}
