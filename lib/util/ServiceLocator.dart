import 'package:eco_swap/data/repository/UserRepository.dart';
import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/data/source/UserAuthDataSource.dart';

class ServiceLocator {
  static ServiceLocator? _instance;

  // Costruttore privato
  ServiceLocator._();

  // Metodo per ottenere l'istanza singleton
  static ServiceLocator getInstance() {
    if (_instance == null) {
      synchronized(ServiceLocator) {
        if (_instance == null) {
          _instance = ServiceLocator._();
        }
      }
    }
    return _instance!;
  }

   IUserRepository getUserRepository(){
    BaseUserAuthDataSource userAuthDataSource = new UserAuthDataSource();
    return new UserRepository(userAuthDataSource);
  }

}
