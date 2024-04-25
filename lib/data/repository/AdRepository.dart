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
    _exchangeDataSource.setCallback(callback());
    _rentalLocalDataSource.setCallback(callback());
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

  void callback(){
    print("a");
  }
}