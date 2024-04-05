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

 @override
 Future<String?> login({required String email, required String password}) {
  return _userAuthDataSource.login(email: email, password: password);
 }

 Future<String?> saveData({required String name, required String lastName,
  required String birthDate, required String phoneNumber, required String position}){
  return _userAuthDataSource.saveData(name: name, lastName: lastName, birthDate: birthDate, phoneNumber: phoneNumber, position: position);
 }
  
}