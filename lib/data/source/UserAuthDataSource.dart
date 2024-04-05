import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserAuthDataSource extends BaseUserAuthDataSource {
  @override
  Future<String?> registration(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> saveData({required String name,
    required String lastName,
    required String birthDate,
    required String phoneNumber,
    required String position}) async {
    try {
      final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? idToken = await currentUser!.getIdToken();
      Map<String, dynamic> userData = {
        'username': name,
        'lastname': lastName,
        'birthDate': birthDate,
        'email': currentUser!.email,
        'phoneNumber': phoneNumber,
      };
      String databasePath = 'users/' + idToken!;
      await databaseReference.child(databasePath).set(userData).then((_) =>
        UserModel(idToken: idToken,
          name: name,
          lastName: lastName,
          email: currentUser!.email,
          position: position,
          birthDate: birthDate,
          phoneNumber: phoneNumber));
          return 'Success';
      } catch (error)
      {
        return 'Error';
      }
    }
}
