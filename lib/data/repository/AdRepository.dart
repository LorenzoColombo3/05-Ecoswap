import 'dart:math';

import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/data/source/BaseRentalDataSource.dart';
import 'package:eco_swap/model/Exchange.dart';
import 'package:eco_swap/model/Rental.dart';
import '../../model/AdModel.dart';
import '../source/BaseExchangeLocalDataSource.dart';
import '../source/BaseRentalLocalDataSource.dart';

class AdRepository implements IAdRepository{
  final BaseExchangeDataSource _exchangeDataSource;
  final BaseRentalDataSource _rentalDataSource;
  final BaseExchangeLocalDataSource _exchangeLocalDataSource;
  final BaseRentalLocalDataSource _rentalLocalDataSource;

  AdRepository(this._exchangeDataSource, this._rentalDataSource, this._exchangeLocalDataSource, this._rentalLocalDataSource){
    _exchangeDataSource.setCallback(loadLocalExchange, _loadAllExchanges);
    _rentalDataSource.setCallback(loadLocalRental, _loadAllRentals, updateLocalRental);
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

  void updateLocalRental(Rental rental){
    _rentalLocalDataSource.updateLocal(rental);
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
  Future<List<AdModel>> searchItems(double latUser, double longUser, String query) async{
   List<Rental> rentals = await _rentalDataSource.searchItems(latUser, longUser, query);
   List<Exchange> exchanges = await _exchangeDataSource.searchItems(latUser, longUser, query);
   List<AdModel> ad=[];
   ad.addAll(rentals);
   ad.addAll(exchanges);
   ad.sort((a, b) {
     double distanceA = _calculateDistance(
       latUser,
       longUser,
       a.latitude,
       a.longitude,
     );
     double distanceB = _calculateDistance(
       latUser,
       longUser,
       b.latitude,
       b.longitude,
     );
     return distanceA.compareTo(distanceB);
   });
   return ad;
  }

  double _calculateDistance(double latUser, double longUser, double latRent, double longRent) {
    const int earthRadiusKm = 6371; // Raggio medio della Terra in chilometri
    double lat1Rad = radians(latUser);
    double lat2Rad = radians(latRent);
    double lon1Rad = radians(longUser);
    double lon2Rad = radians(longRent);
    double deltaLat = lat2Rad - lat1Rad;
    double deltaLon = lon2Rad - lon1Rad;

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double radians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  void updateRentalData(Rental rental) {
    _rentalDataSource.updateRentalData(rental);
  }
  @override
  Future<List<Rental>> getRentalsByIdTokens(List<dynamic> idTokens){
    return _rentalDataSource.getRentalsByIdTokens(idTokens);
  }
  @override
  Future<List<Exchange>> getExchangesByIdTokens(List<dynamic> idTokens){
    return _exchangeDataSource.getExchangesByIdTokens(idTokens);
  }
}