import 'package:eco_swap/data/repository/AdRepository.dart';
import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:eco_swap/data/repository/UserRepository.dart';
import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/data/source/BaseRentalDataSource.dart';
import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/data/source/ExchangeDataSource.dart';
import 'package:eco_swap/data/source/RentalDataSource.dart';
import 'package:eco_swap/data/source/UserAuthDataSource.dart';

class ServiceLocator {

  static final ServiceLocator _singleton = ServiceLocator._internal();

  factory ServiceLocator() {
    return _singleton;
  }

  ServiceLocator._internal();

   IUserRepository getUserRepository(){
    BaseUserAuthDataSource userAuthDataSource = new UserAuthDataSource();
    return new UserRepository(userAuthDataSource);
  }

  IAdRepository getAdRepository(){
     BaseRentalDataSource rentalDataSource = RentalDataSource();
     BaseExchangeDataSource exchangeDataSource = ExchangeDataSource();
     return new AdRepository(exchangeDataSource, rentalDataSource);
  }

}
