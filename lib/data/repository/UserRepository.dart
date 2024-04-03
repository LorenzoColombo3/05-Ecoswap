import 'package:eco_swap/data/repository/IUserRepository.dart';
import '../source/BaseUserAuthDataSource.dart';

class UserRepository implements IUserRepository{

 final BaseUserAuthDataSource _userAuthDataSource;

  UserRepository(BaseUserAuthDataSource userAuthDataSource)
     : _userAuthDataSource=userAuthDataSource;


  @override
  Future<String?> registration({required String email, required String password}) {
    return _userAuthDataSource.registration(email: email, password: password);
  }
  
}