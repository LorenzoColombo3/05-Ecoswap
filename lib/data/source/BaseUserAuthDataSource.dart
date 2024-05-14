import '../../model/UserModel.dart';
import '../../util/Result.dart';

abstract class BaseUserAuthDataSource {
  Future<String?> registration(
      {required String email, required String password});
  Future<String?> signInWithGoogle();
  Future<String?> login({required String email, required String password});
  Future<Result?> saveData({required String name, required String lastName,
    required String birthDate, required String phoneNumber});
  Future<String?> readEmail();
  Future<void> saveCredential(String email, String password);
  Future<void> deleteCredential();
  Future<String?> readPassword();
  void deleteUser();
  Future<void> updatePosition(bool hasPermission);
  Future<bool> signOutFromGoogle();
  Future<void> resetPassword(String email);
  Future<UserModel?> getUser();
  Future<String> setProfileImage(String imagePath);
  Future<String?> getProfileImage();
  Future<UserModel?> getUserDataFirebase(String idToken);
  Future<void> saveActiveRentalsBuy(UserModel user);
  Future<void> saveActiveRentalsSell(UserModel user);
  Future<void> saveFinishedRentalsSell(UserModel user);
  Future<void> saveFinishedRentalsBuy(UserModel user);
  Future<void> saveExpiredExchange(UserModel user);
  Future<void> savePublishedRentals(UserModel user);
  Future<void> savePublishedExchanges(UserModel user);
  void saveFavoriteRental(List<dynamic> favoriteAds);
  void saveFavoriteExchange(List<dynamic> favoriteAds);
}