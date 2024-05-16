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

  Future<String> setProfileImage(String imagePath){
    return _userRepository.setProfileImage(imagePath);
  }

  Future<void> deleteCredential() async {
    _userRepository.deleteCredential();
  }

  Future<String?> getProfileImage(){
    return _userRepository.getProfileImage();
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

  Future<UserModel?> getUserData(String idToken){
    return _userRepository.getUserData(idToken);
  }

  Future<void> saveActiveRentalsBuy(UserModel user) async{
    _userRepository.saveActiveRentalsBuy(user);
  }

  Future<void> saveActiveRentalsSell(UserModel user) async{
    _userRepository.saveActiveRentalsSell(user);
  }

  Future<void> saveFinishedRentalsBuy(UserModel user) async{
    _userRepository.saveFinishedRentalsBuy(user);
  }

  Future<void> saveFinishedRentalsSell(UserModel user) async{
    _userRepository.saveActiveRentalsSell(user);
  }

  Future<void> savePublishedExchanges(UserModel user) async{
    _userRepository.savePublishedExchanges(user);
  }

  Future<void> savePublishedRentals(UserModel user) async{
    _userRepository.savePublishedRentals(user);
  }

  Future<void> saveFavoriteExchange(UserModel user) async{
    _userRepository.saveFavoriteExchange(user);
  }

  Future<void> saveFavoriteRentals(UserModel user) async{
    _userRepository.saveFavoriteRentals(user);
  }


  Future<void> saveReview(String userId, String reviewContent, int stars){
    return _userRepository.saveReview(userId, reviewContent, stars);
  }

}