abstract class IUserRepository{
  Future<String?> registration({required String email, required String password});
  Future<String?> login({required String email, required String password});
  Future<String?> saveData({required String name, required String lastName,
    required String birthDate, required String phoneNumber, required String position});
  void deleteUser() {}
  void updatePosition(){}
}