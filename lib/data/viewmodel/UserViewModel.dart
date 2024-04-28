import 'package:eco_swap/data/repository/IUserRepository.dart';

import '../../model/UserModel.dart';
import '../../util/Result.dart';

class UserViewModel{
  final IUserRepository _userRepository;

  UserViewModel(IUserRepository userRepository)
    : _userRepository = userRepository;

  Future<String?> registration({required String email, required String password}) {
    return _userRepository.registration(email: email, password: password);
  }

  Future<String?> signInWithGoogle(){
    return _userRepository.signInWithGoogle();
  }

  Future<String?> login({required String email, required String password}) {
    return _userRepository.login(email: email, password: password);
  }

  Future<Result?> saveData({required String name, required String lastName,
                            required String birthDate, required String phoneNumber}){
    return _userRepository.saveData(name: name, lastName: lastName, birthDate: birthDate, phoneNumber: phoneNumber);
  }

  void deleteUser(){_userRepository.deleteUser();}

  Future<void> updatePosition(bool hasPermission)async { _userRepository.updatePosition(hasPermission);}

  Future<bool> signOutFromGoogle() async {
    return _userRepository.signOutFromGoogle();
  }

  Future<void> deleteCredential() async {
    _userRepository.deleteCredential();
  }

  Future<void> saveCredential(String email, String password) async {
    _userRepository.saveCredential(email, password);
  }

  Future<String?> readEmail() async {
    return _userRepository.readEmail();
  }

  Future<String?> readPassword() async {
    return _userRepository.readPassword();
  }

  Future<void> resetPassword(String email) async{
    return _userRepository.resetPassword(email);
  }

  Future<UserModel?> getUser() async{
    return _userRepository.getUser();
  }
}