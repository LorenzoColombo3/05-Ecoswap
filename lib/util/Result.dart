import '../model/UserModel.dart';

abstract class Result {
  const Result();

  bool isSuccess();
}
class UserResponseSuccess extends Result {
  final UserModel user;

  UserResponseSuccess(this.user);

  UserModel getData() {
    return user;
  }

  @override
  bool isSuccess() => true;
}

class ErrorResult extends Result {
  final String message;

  ErrorResult(this.message);

  String getMessage() {
    return message;
  }

  @override
  bool isSuccess() => false;
}