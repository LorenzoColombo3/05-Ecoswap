import 'package:eco_swap/data/repository/IUserRepository.dart';
import '../../model/UserModel.dart';
import '../../util/Result.dart';
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
  Future<String?> signInWithGoogle(){
   return _userAuthDataSource.signInWithGoogle();
  }

  @override
  Future<void> deleteCredential() async {
   _userAuthDataSource.deleteCredential();
  }

 @override
 Future<String?> login({required String email, required String password}) {
  return _userAuthDataSource.login(email: email, password: password);
 }
@override
Future<Result?> saveData({required String name, required String lastName,
  required String birthDate, required String phoneNumber}){
  return _userAuthDataSource.saveData(name: name, lastName: lastName, birthDate: birthDate, phoneNumber: phoneNumber,);
 }

 @override
 Future<String?> getProfileImage(){
   return _userAuthDataSource.getProfileImage();
 }

 @override
 Future<String> setProfileImage(String imageUrl){
   return _userAuthDataSource.setProfileImage(imageUrl);
 }

  @override
  void deleteUser() {
    _userAuthDataSource.deleteUser();
  }

  @override
  Future<void> updatePosition(bool hasPermission) async {
    _userAuthDataSource.updatePosition(hasPermission);
  }

  @override
  Future<bool> signOutFromGoogle() async {
   return _userAuthDataSource.signOutFromGoogle();
  }

  @override
  Future<void> saveCredential(String email, String password) async {
    _userAuthDataSource.saveCredential(email, password);
  }

  @override
  Future<String?> readEmail() async {
   return _userAuthDataSource.readEmail();
  }

  @override
  Future<String?> readPassword() async {
   return _userAuthDataSource.readPassword();
  }

  @override
  Future<void> resetPassword(String email) async{
    return _userAuthDataSource.resetPassword(email);
  }

  @override
  Future<UserModel?> getUser() {
    return _userAuthDataSource.getUser();
  }

  Future<UserModel?> getUserData(String idToken){
    return _userAuthDataSource.getUserDataFirebase(idToken);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    _userAuthDataSource.saveUser(user);
  }
  
}