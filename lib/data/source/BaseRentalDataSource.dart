import '../../model/Rental.dart';

abstract class BaseRentalDataSource{
  late final Function (Rental rental) onLoadFinished;
  void setCallback(Function (Rental rental) onLoadFinished){
    this.onLoadFinished=onLoadFinished;
  }
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImage(String imagePath);
  Future<void> loadFromFirebaseToLocal(Rental rental);
}