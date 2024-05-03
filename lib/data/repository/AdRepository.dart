import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/data/source/BaseRentalDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';
import 'package:eco_swap/model/Rental.dart';
import '../source/BaseExchangeLocalDataSource.dart';
import '../source/BaseRentalLocalDataSource.dart';

class AdRepository implements IAdRepository{
  final BaseExchangeDataSource _exchangeDataSource;
  final BaseRentalDataSource _rentalDataSource;
  final BaseExchangeLocalDataSource _exchangeLocalDataSource;
  final BaseRentalLocalDataSource _rentalLocalDataSource;

  AdRepository(this._exchangeDataSource, this._rentalDataSource, this._exchangeLocalDataSource, this._rentalLocalDataSource){
    _exchangeDataSource.setCallback(loadLocalExchange, _loadAllExchanges);
    _rentalDataSource.setCallback(loadLocalRental, _loadAllRentals);
  }

  @override
  Future<String?> loadRental(Rental rental) {
    return _rentalDataSource.loadRental(rental);
  }

  @override
  Future<String> uploadImageRental(String imagePath) {
    return _rentalDataSource.uploadImage(imagePath);
  }

  @override
  Future<String?> loadExchange(Exchange exchange) {
    return _exchangeDataSource.loadExchange(exchange);
  }

  @override
  Future<String> uploadImageExchange(String imagePath) {
    return _exchangeDataSource.uploadImage(imagePath);
  }

  @override
  Future<void> loadFromFirebaseToLocal(String userId) async{
    _exchangeDataSource.loadFromFirebaseToLocal(userId);
    _rentalDataSource.loadFromFirebaseToLocal(userId);
  }

  void loadLocalExchange(Exchange exchange){
    _exchangeLocalDataSource.loadLocal(exchange);
  }

  void loadLocalRental(Rental rental){
    _rentalLocalDataSource.loadLocal(rental);
  }

  void _loadAllExchanges(List<Exchange> exchanges){
    _exchangeLocalDataSource.loadAll(exchanges);
  }

  void _loadAllRentals(List<Rental> rentals){
    _rentalLocalDataSource.loadAll(rentals);
  }

  @override
  Future<List<Exchange>> getLocalExchange(String userId) {
    return _exchangeLocalDataSource.getLocalExchange(userId);
  }

  @override
  Future<List<Rental>> getLocalRental(String userId) {
    return _rentalLocalDataSource.getLocalRental(userId);
  }

  @override
  Future<List<Exchange>> getExchangesInRadius(double latUser, double longUser, double radiusKm, int startIndex) {
    return _exchangeDataSource.getExchangesInRadius(latUser, longUser, radiusKm, startIndex);
  }

  @override
  Future<List<Rental>> getRentalsInRadius(double latUser, double longUser, double radiusKm, int startIndex) {
    return _rentalDataSource.getRentalsInRadius(latUser, longUser, radiusKm, startIndex);
  }
  @override
  Future<List<Rental>> getAllUserRentals(String userId) {
    return _rentalDataSource.getAllUserRentals(userId);
  }
  @override
  Future<List<Exchange>> getAllUserExchanges(String userId) {
    return _exchangeDataSource.getAllUserExchanges(userId);
  }

  @override
  Future<List<Rental>> searchRentalItems(double latUser, double longUser, String query) {
   return _rentalDataSource.searchItems(latUser, longUser, query);
  }

  @override
  Future<List<Exchange>> searchExchangeItems(double latUser, double longUser, String query) {
    return _exchangeDataSource.searchItems(latUser, longUser, query);
  }
}