import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:eco_swap/model/AdModel.dart';

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

  Future<List<Exchange>> getLocalExchange(String userId) {
    return _adRepository.getLocalExchange(userId);
  }

  Future<List<Rental>> getLocalRental(String userId) {
    return _adRepository.getLocalRental(userId);
  }

  Future<List<Exchange>> getExchangesInRadius(double latUser, double longUser, double radiusKm, int startIndex) {
    return _adRepository.getExchangesInRadius(latUser, longUser, radiusKm,  startIndex);
  }

  Future<List<Rental>> getRentalsInRadius(double latUser, double longUser, double radiusKm, int startIndex) {
    return _adRepository.getRentalsInRadius(latUser, longUser, radiusKm,  startIndex);
  }

  Future<List<Rental>> getAllUserRentals(String userId) {
    return _adRepository.getAllUserRentals(userId);
  }

  Future<List<Exchange>> getAllUserExchanges(String userId) {
    return _adRepository.getAllUserExchanges(userId);
  }

  Future<List<AdModel>> searchItems(double latUser, double longUser, String query) {
    return  _adRepository.searchItems(latUser, longUser, query);
  }

  void updateRentalData(Rental rental){
    _adRepository.updateRentalData(rental);
  }

  Future<List<Rental>> getRentalsByIdTokens(List<dynamic> idTokens){
    return _adRepository.getRentalsByIdTokens(idTokens);
  }

  Future<List<Exchange>> getExchangesByIdTokens(List<dynamic> idTokens){
    return _adRepository.getExchangesByIdTokens(idTokens);
  }

}