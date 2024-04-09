
import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  Future<String?> saveData({
    required String name,
    required String lastName,
    required String birthDate,
    required String phoneNumber,
  }) async {
    try {
      final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String idToken = currentUser!.uid;
      final Map<String, dynamic> userData = {
        'username': name,
        'lastname': lastName,
        'birthDate': birthDate,
        'email': currentUser.email,
        'phoneNumber': phoneNumber,
      };
      final String databasePath = 'users';
      await databaseReference.child(databasePath).child(idToken!).set(userData).then((_) =>
          UserModel(idToken: idToken,
              name: name,
              lastName: lastName,
              email: currentUser.email,
              birthDate: birthDate,
              phoneNumber: phoneNumber));;

      return 'Success';
    } catch (error) {
      print(error);
      return 'Error';
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


}

