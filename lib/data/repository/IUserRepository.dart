abstract class IUserRepository{
  Future<String?> registration({required String email, required String password});
}