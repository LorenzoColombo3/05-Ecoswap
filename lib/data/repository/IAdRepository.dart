import '../../model/Rental.dart';

abstract class IAdRepository{
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImage(String imagePath);

}