
import 'package:sqflite/sqflite.dart';

import '../../model/Rental.dart';

abstract class BaseRentalLocalDataSource{
  Future<void> loadLocal(Rental rental);
  Future<void> loadAll(List<Rental> rentals);
  Future<List<Rental>> getLocalRental(String userId);
  Future<void> updateLocal(Rental rental);
  Future<void> deleteLocal(String idToken);
  Future<bool> isRentalExists(Transaction txn, String idToken);
}