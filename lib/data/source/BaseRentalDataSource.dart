import '../../model/Rental.dart';

abstract class BaseRentalDataSource{
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImage(String imagePath);

}