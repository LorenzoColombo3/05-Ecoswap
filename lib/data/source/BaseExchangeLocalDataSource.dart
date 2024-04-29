import 'package:sqflite/sqflite.dart';
import '../../model/Exchange.dart';

abstract class BaseExchangeLocalDataSource{

  Future<void> loadLocal(Exchange exchange);
  Future<void> loadAll(List<Exchange> exchanges);
  Future<List<Exchange>> getLocalExchange(String userId);
  Future<void> updateLocal(Exchange exchange);
  Future<void> deleteLocal(String idToken);
  Future<bool> isExchangeExists(Transaction txn, String userId);
}
