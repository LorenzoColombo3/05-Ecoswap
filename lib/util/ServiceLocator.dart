import 'package:eco_swap/data/repository/UserRepository.dart';
import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
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

}
