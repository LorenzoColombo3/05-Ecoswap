
import 'dart:convert';

import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/model/UserModel.dart';
import 'package:eco_swap/util/Result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthDataSource extends BaseUserAuthDataSource {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
  Future<String?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
        await firebaseAuth.signInWithCredential(credential);

        if (authResult.additionalUserInfo!.isNewUser) {
          return "Nuovo utente creato con successo.";
        } else {
          final User? currentUser = FirebaseAuth.instance.currentUser;
          String idToken = currentUser!.uid;
          Result? result= await getUserDataFirebase(idToken);
          saveUserLocal((result as UserResponseSuccess).getData());
          return "Accesso con Google effettuato con successo.";
        }
      } else {
        print('Accesso con Google annullato.');
        return null;
      }
    } catch (e) {
      print('Errore durante il login con Google: $e');
      return null;
    }
  }


  @override
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    saveCredential(email, password);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? currentUser = FirebaseAuth.instance.currentUser;
      String idToken = currentUser!.uid;
      Result? result= await getUserDataFirebase(idToken);
      saveUserLocal((result as UserResponseSuccess).getData());
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
  Future<Result?> saveData({
    required String name,
    required String lastName,
    required String birthDate,
    required String phoneNumber,
  }) async {
    try {
      final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
      final User? currentUser = FirebaseAuth.instance.currentUser;
      UserModel? newUser;
      final String idToken = currentUser!.uid;
      final Map<String, dynamic> userData = {
        'username': name,
        'lastname': lastName,
        'birthDate': birthDate,
        'email': currentUser.email,
        'phoneNumber': phoneNumber,
      };
      final String databasePath = 'users';
      await databaseReference
          .child(databasePath)
          .child(idToken)
          .set(userData)
          .then((_) =>
          newUser = UserModel(
            idToken: idToken,
            name: name,
            lastName: lastName,
            email: currentUser.email,
            birthDate: birthDate,
            phoneNumber: phoneNumber,
            position: "",
          ));
      Result result = UserResponseSuccess(newUser!);
      saveUserLocal(newUser!);
      return result;
    } catch (error) {
      Result result = ErrorResult(error.toString());
      return result;
    }
  }


  @override
  void deleteUser(){
    FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  Future<void> updatePosition(bool hasPermission) async {
    String? _currentCity;
    Position? _currentPosition;
    if (!hasPermission) return;
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentCity = await _getAddressFromLatLng(_currentPosition!);
      final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String idToken = currentUser!.uid;
      final String databasePath = 'users/$idToken/position';
      await databaseReference.child(databasePath).set(_currentCity);
      UserModel? user = await getUser();
      if (user != null) {
        user.position=_currentCity!;
        await saveUserLocal(user);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<String?> _getAddressFromLatLng(Position position) async {
    String? _currentCity;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      _currentCity = place.locality;
      return _currentCity;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }


  @override
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<void> saveUserLocal(UserModel user) async{
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> userMap = user.toMap();
    await prefs.setString('user', json.encode(userMap));
  }

  @override
  Future<void> saveCredential(String email, String password) async {
    await _storage.write(key: 'password', value: password);
    await _storage.write(key: 'email', value: email);
    print('credential saved!');
  }

  @override
  Future<void> deleteCredential() async {
    await _storage.delete(key: 'password');
    await _storage.delete(key: 'email');
    print('credential deleted!');
  }

  @override
  Future<String?> readEmail() async {
    String? email = await _storage.read(key: 'email');
    return email;
  }

  @override
  Future<String?> readPassword() async {
    String? password = await _storage.read(key: 'password');
    return password;
  }

  @override
   Future<UserModel?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString('user');
    if (userString != null) {
      final Map<String, dynamic> userMap = json.decode(userString);
      return UserModel.fromMap(userMap);
    } else {
      return null;
    }
  }

  Future<Result?> getUserDataFirebase(String idToken) async {
    Result result;
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$idToken').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic>? userData = snapshot.value as Map<dynamic, dynamic>?;
        String name = userData?['username'];
        String email = userData?['email'];
        String lastName = userData?['lastname'];
        String birthDate = userData?['birthDate'];
        String position = userData?['position'];
        String phoneNumber = userData?['phoneNumber'];
        result = UserResponseSuccess(UserModel(idToken: idToken, name: name, lastName: lastName, email: email, birthDate: birthDate, phoneNumber: phoneNumber, position: position));
        return result;
      }else{
        result = ErrorResult("user data not found");
        return result;
      }
    } catch (error) {
      print("Errore durante il recupero dei dati dell'utente con idToken: $idToken, Errore: $error");
      result = ErrorResult(error.toString());
      return result;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }



}

