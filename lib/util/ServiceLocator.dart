import 'package:eco_swap/data/database/DatabaseManager.dart';
import 'package:eco_swap/data/repository/AdRepository.dart';
import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:eco_swap/data/repository/UserRepository.dart';
import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/source/BaseChatDataSource.dart';
import 'package:eco_swap/data/source/BaseExchangeDataSource.dart';
import 'package:eco_swap/data/source/BaseExchangeLocalDataSource.dart';
import 'package:eco_swap/data/source/BaseRentalDataSource.dart';
import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/data/source/ChatDataSource.dart';
import 'package:eco_swap/data/source/ExchangeDataSource.dart';
import 'package:eco_swap/data/source/ExchangeLocalDataSource.dart';
import 'package:eco_swap/data/source/RentalDataSource.dart';
import 'package:eco_swap/data/source/UserAuthDataSource.dart';
import 'package:sqflite/sqflite.dart';

import '../data/source/BaseRentalLocalDataSource.dart';
import '../data/source/RentalLocalDataSource.dart';

class ServiceLocator {

  static final ServiceLocator _singleton = ServiceLocator._internal();

  factory ServiceLocator() {
    return _singleton;
  }

  ServiceLocator._internal();

   IUserRepository getUserRepository(){
    BaseUserAuthDataSource userAuthDataSource = new UserAuthDataSource();
    BaseChatDataSource chatDataSource = ChatDataSource();
    return new UserRepository(userAuthDataSource, chatDataSource);
  }

  IAdRepository getAdRepository(){
     BaseRentalDataSource rentalDataSource = RentalDataSource();
     BaseExchangeDataSource exchangeDataSource = ExchangeDataSource();
     BaseExchangeLocalDataSource localExchangeDataSource = ExchangeLocalDataSource();
     BaseRentalLocalDataSource localRentalDataSource = RentalLocalDataSource();

     return new AdRepository(exchangeDataSource, rentalDataSource, localExchangeDataSource, localRentalDataSource);
  }

}
