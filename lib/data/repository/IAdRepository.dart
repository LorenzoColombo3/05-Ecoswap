import '../../model/Exchange.dart';
import '../../model/Rental.dart';

abstract class IAdRepository{
  Future<String?> loadRental(Rental rental);
  Future<String> uploadImageRental(String imagePath);
  Future<String?> loadExchange(Exchange exchange);
  Future<String> uploadImageExchange(String imagePath);
  Future<void> loadFromFirebaseToLocal(String idToken);
}