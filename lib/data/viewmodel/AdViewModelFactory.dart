import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:eco_swap/data/viewmodel/AdViewModel.dart';

class AdViewModelFactory {
  final IAdRepository _adRepository;

  AdViewModelFactory(this._adRepository);

  AdViewModel create(){
    return new AdViewModel(_adRepository);
  }
}