import 'package:eco_swap/data/source/BaseExchangeLocalDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';
import 'package:sqflite/sqflite.dart';

import '../database/DatabaseManager.dart';

class ExchangeLocalDataSource extends BaseExchangeLocalDataSource {
  late Database _database;

  ExchangeLocalDataSource(){
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    this._database= await DatabaseManager.instance.database;
  }

  @override
  Future<void> deleteLocal(String idToken) async{
    try {
      await _database.delete(
        'exchanges',
        where: 'idToken = ?',
        whereArgs: [idToken],
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Exchange>> getLocalExchange(String userId) async {
    try {
      List<Map<String, dynamic>> maps = await _database.query(
        'exchanges',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      return List.generate(maps.length, (i) {
        return Exchange.fromMap(maps[i]);
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loadLocal(Exchange exchange) async{
    try {
      await _database.insert('exchanges', exchange.toMap());
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateLocal(Exchange exchange) async{
    try {
      await _database.update(
        'exchanges',
        exchange.toMap(),
        where: 'idToken = ?',
        whereArgs: [exchange.idToken],
      );
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> loadAll(List<Exchange> exchanges)async {
    try {
      bool exists = false;
      await _database.transaction((txn) async {
        Batch batch = txn.batch();
        for (var exchange in exchanges) {
          exists = await isExchangeExists(txn, exchange.idToken);
          if(!exists) {
            batch.insert('exchanges', exchange.toMap());
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
  Future<bool> isExchangeExists(Transaction txn, String idToken) async {
    try {
      List<Map<String, dynamic>> result = await txn.query(
        'exchanges',
        where: 'idToken = ?',
        whereArgs: [idToken],
      );
      return result.isNotEmpty;
    } catch (error) {
      print('Errore durante il controllo della presenza del exchange nel database locale: $error');
      return false;
    }
  }


}