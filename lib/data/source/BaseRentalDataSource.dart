import '../../model/Rental.dart';

abstract class BaseRentalDataSource{
  late final Function (Rental rental) onLoadFinished;
  late final Function (List<Rental> rental) loadAllRental;


  void setCallback(Function (Rental rental) onLoadFinished, Function (List<Rental> rental) loadAllRental){
    this.loadAllRental=loadAllRental;
    this.onLoadFinished=onLoadFinished;
  }
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImage(String imagePath);
  Future<void> loadFromFirebaseToLocal(String userId);
  Future<Rental?> getRental(String idToken);
  Future<List<Rental>> getAllRentals();
  Future<List<Rental>> getAllUserRentals(String userId);
}