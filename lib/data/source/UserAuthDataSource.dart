
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

  final storage = const FlutterSecureStorage();

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
      Result? res = await getUser();
      UserModel? user = (res as UserResponseSuccess).getData();
      print(user!.position.toString());
      if (user != null) {
        user.position=_currentCity!;
        await saveUserLocal(user);
      }
      Result? res2 = await getUser();
      user = (res2 as UserResponseSuccess).getData();
      print(user!.position.toString());
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

  Future<void> _saveToken() async {
    await storage.write(key: 'accessToken', value: 'your_access_token_here');
    print('Token saved.');
  }

  Future<void> _readToken() async {
    String? accessToken = await storage.read(key: 'accessToken');
    print('Access Token: $accessToken');
  }

  static Future<Result?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userString = prefs.getString('user');
    if (userString != null) {
      final Map<String, dynamic> userMap = json.decode(userString);
      Result result = UserResponseSuccess(UserModel.fromMap(userMap));
      return result;
    } else {
      Result result = ErrorResult('local database error');
      return result;
    }
  }
}

