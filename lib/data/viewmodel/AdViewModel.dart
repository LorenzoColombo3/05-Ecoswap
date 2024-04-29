import 'package:eco_swap/data/repository/IAdRepository.dart';

import '../../model/Exchange.dart';
import '../../model/Rental.dart';

class AdViewModel{
  final IAdRepository _adRepository;

  AdViewModel(this._adRepository);

  Future<String?> loadRental(Rental rental) {
    return _adRepository.loadRental(rental);
  }

  Future<String> uploadImageRental(String imagePath) {
    return _adRepository.uploadImageRental(imagePath);
  }

  Future<String?> loadExchange(Exchange exchange) {
    return _adRepository.loadExchange(exchange);
  }

  Future<String> uploadImageExchange(String imagePath) {
    return _adRepository.uploadImageExchange(imagePath);
  }

  Future<void> loadFromFirebaseToLocal(String userId)async {
    _adRepository.loadFromFirebaseToLocal(userId);
  }

  @override
  Future<List<Exchange>> getLocalExchange(String userId) {
    return _adRepository.getLocalExchange(userId);
  }

  @override
  Future<List<Rental>> getLocalRental(String userId) {
    return _adRepository.getLocalRental(userId);
  }
}