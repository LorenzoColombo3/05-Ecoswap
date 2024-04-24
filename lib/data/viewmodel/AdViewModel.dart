import 'package:eco_swap/data/repository/IAdRepository.dart';

import '../../model/Rental.dart';

class AdViewModel{
  final IAdRepository _adRepository;

  AdViewModel(this._adRepository);

  Future<String?> loadRental(Rental rental) {
    return _adRepository.loadRental(rental);
  }

  Future<String> uploadImage(String imagePath) {
    return _adRepository.uploadImage(imagePath);
  }
}