
import '../../model/Rental.dart';

abstract class BaseRentalLocalDataSource{
  Future<void> loadLocal(Rental rental);
  Future<void> loadAll(List<Rental> rentals);
  Future<List<Rental>> getLocal();
  Future<void> updateLocal(Rental rental);
  Future<void> deleteLocal(String idToken);
}