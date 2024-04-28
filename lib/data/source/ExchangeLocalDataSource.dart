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
  Future<List<Exchange>> getLocal() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query('exchanges');
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
    await _database.transaction((txn) async {
      Batch batch = txn.batch();
      for (var exchange in exchanges) {
        batch.insert('exchanges', exchange.toMap());
      }
      await batch.commit(noResult: true);
    });
  }

}