import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../model/Chat.dart';
import '../../model/Message.dart';
import '../../model/UserModel.dart';
import '../../util/Result.dart';

abstract class IUserRepository{
  Future<String?> registration({required String email, required String password});
  Future<String?> signInWithGoogle();
  Future<String?> login({required String email, required String password});
  Future<Result?> saveData({required String name, required String lastName,
    required String birthDate, required String phoneNumber});
  Future<String?> readEmail();
  Future<void> saveCredential(String email, String password);
  Future<void> deleteCredential();
  Future<String?> readPassword();
  Future<void> resetPassword(String email);
  void deleteUser();
  Future<void> updatePosition(bool hasPermission);
  Future<bool> signOutFromGoogle();
  Future<UserModel?> getUser();
  Future<String> setProfileImage(String imageUrl);
  Future<String?> getProfileImage();
  Future<UserModel?> getUserData(String idToken);
  Future<void> saveFavoriteExchange(UserModel user);
  Future<void> saveFavoriteRentals(UserModel user);
  Future<void> saveActiveRentalsBuy(UserModel user);
  Future<void> saveActiveRentalsSell(UserModel user);
  Future<void> saveFinishedRentalsSell(UserModel user);
  Future<void> saveFinishedRentalsBuy(UserModel user);
  Future<void> savePublishedRentals(UserModel user);
  Future<void> savePublishedExchanges(UserModel user);
  Future<void> saveReview(String userId, String reviewContent, int stars);
  Future<void> saveUserLocal(UserModel user);
  Stream<List<DatabaseEvent>> getChatsStream(String userId);
  Stream<DatabaseEvent> getMessageStream(Chat chat);
  Future<Chat?> getChat(String userId, String itemId);
  void markMessages(String chatId);
  void setupFirebaseListener();
  void saveChat(Chat chat);
  void saveMessage(Chat chat, Message message);
}