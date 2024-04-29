
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
    _database= await DatabaseManager.instance.database;
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
  Future<List<Rental>> getLocalRental(String userId) async{
    try {
      List<Map<String, dynamic>> maps = await _database.query(
        'rentals',
        where: 'userId = ?',
        whereArgs: [userId],
      );
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

  @override
  Future<void> loadAll(List<Rental> rentals)async {
    try {
      bool exists = false;
      await _database.transaction((txn) async {
        Batch batch = txn.batch();
        for (var rental in rentals) {
          exists = await isRentalExists(txn, rental.idToken);
          if(!exists) {
            batch.insert('rentals', rental.toMap());
          }
        }
        await batch.commit(noResult: true);
      });
    }catch(error){
      print(error.toString());
      rethrow;
    }
  }

  @override
  Future<bool> isRentalExists(Transaction txn, String idToken) async {
    try {
      List<Map<String, dynamic>> result = await txn.query(
        'rentals',
        where: 'idToken = ?',
        whereArgs: [idToken],
      );
      return result.isNotEmpty;
    } catch (error) {
      print('Errore durante il controllo della presenza del rental nel database locale: $error');
      return false;
    }
  }



}