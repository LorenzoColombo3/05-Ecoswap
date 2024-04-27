import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._internal();
  static Database? _database;

  DatabaseManager._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/ecoSwap_database.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE rentals('
          'imagePath TEXT, '
          'userId TEXT, '
          'title TEXT, '
          'description TEXT, '
          'lat REAL, '
          'long REAL, '
          'dailyCost TEXT, '
          'maxDaysRent TEXT, '
          'idToken TEXT PRIMARY KEY, '
          'imageUrl TEXT)',
    );
    await db.execute(
      'CREATE TABLE exchanges('
          'imagePath TEXT, '
          'userId TEXT, '
          'title TEXT, '
          'description TEXT, '
          'latitude REAL, '
          'longitude REAL, '
          'idToken TEXT PRIMARY KEY, '
          'imageUrl TEXT)',
    );
  }


  Future<void> deleteLocalDatabase() async {
    String databasesPath = await getDatabasesPath();
    String databasePath = join(databasesPath, 'ecoSwap_database.db');
    await deleteDatabase(databasePath);
  }
}