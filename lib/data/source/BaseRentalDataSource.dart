import '../../model/Rental.dart';

abstract class BaseRentalDataSource{
  late final Function (Rental rental) onLoadFinished;
  late final Function (List<Rental> rental) loadAllRental;
  late final Function (Rental rental) onUpdateFinished;


  void setCallback(Function (Rental rental) onLoadFinished, Function (List<Rental> rental) loadAllRental, Function(Rental rental) onUpdateFinished){
    this.loadAllRental=loadAllRental;
    this.onLoadFinished=onLoadFinished;
    this.onUpdateFinished=onUpdateFinished;
  }
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImage(String imagePath);
  Future<void> loadFromFirebaseToLocal(String userId);
  Future<Rental?> getRental(String idToken);
  Future<List<Rental>> getAllRentals();
  Future<List<Rental>> getAllUserRentals(String userId);
  Future<List<Rental>> getRentalsInRadius(double latUser, double longUser, double radiusKm, int startIndex);
  Future<List<Rental>> searchItems(double latUser, double longUser, String query);
  void updateRentalData(Rental rental);
  Future<List<Rental>> getRentalsByIdTokens(List idTokens);
  Future<void> removeRental(String idToken);

}