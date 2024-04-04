abstract class IUserRepository{
  Future<String?> registration({required String email, required String password});
  Future<String?> login({required String email, required String password});
}