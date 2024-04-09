abstract class IUserRepository{
  Future<String?> registration({required String email, required String password});
  Future<String?> signInWithGoogle();
  Future<String?> login({required String email, required String password});
  Future<String?> saveData({required String name, required String lastName,
    required String birthDate, required String phoneNumber});
  void deleteUser();
  Future<void> updatePosition(bool hasPermission);
  Future<bool> signOutFromGoogle();
}