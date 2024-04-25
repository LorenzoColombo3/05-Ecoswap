
import 'package:eco_swap/data/database/DatabaseManager.dart';
import 'package:eco_swap/model/Rental.dart';
import 'package:sqflite/sqflite.dart';

import 'BaseRentalLocalDataSource.dart';

class RentalLocalDataSource extends BaseRentalLocalDataSource{
  late Database _database;

  RentalLocalDataSource(){
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    this._database= await DatabaseManager.instance.database;
  }

  @override
  Future<void> deleteLocal(String idToken) async{
    try {
      await _database.delete(
        'rentals',
        where: 'idToken = ?',
        whereArgs: [idToken],
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Rental>> getLocal() async{
    try {
      final List<Map<String, dynamic>> maps = await _database.query('rentals');
      return List.generate(maps.length, (i) {
        return Rental.fromMap(maps[i]);
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loadLocal(Rental rental) async{
    try {
      await _database.insert('rentals', rental.toMap());
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateLocal(Rental rental) async{
    try {
      await _database.update(
        'rentals',
        rental.toMap(),
        where: 'idToken = ?',
        whereArgs: [rental.idToken],
      );
    } catch (error) {
      rethrow;
    }
  }


}