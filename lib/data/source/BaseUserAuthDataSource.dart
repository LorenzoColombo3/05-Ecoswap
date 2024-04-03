abstract class BaseUserAuthDataSource{
  Future<String?> registration({required String email, required String password});
}