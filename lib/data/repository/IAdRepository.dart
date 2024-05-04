import '../../model/Exchange.dart';
import '../../model/Rental.dart';

abstract class IAdRepository{
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImageRental(String imagePath);
  Future<String?> loadExchange(Exchange exchange);
  Future<String> uploadImageExchange(String imagePath);
  Future<void> loadFromFirebaseToLocal(String idToken);
  Future<List<Rental>> getLocalRental(String userId);
  Future<List<Exchange>> getLocalExchange(String userId);
  Future<List<Rental>> getRentalsInRadius(double latUser, double longUser, double radiusKm, int startIndex);
  Future<List<Exchange>> getExchangesInRadius(double latUser, double longUser, double radiusKm, int startIndex);
  Future<List<Rental>> getAllUserRentals(String userId);
  Future<List<Exchange>> getAllUserExchanges(String userId);
  Future<List<Rental>> searchRentalItems(double latUser, double longUser, String query, int startIndex);
  Future<List<Exchange>> searchExchangeItems(double latUser, double longUser, String query, int startIndex);
}