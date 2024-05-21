import 'dart:convert';

import 'package:eco_swap/data/source/BaseUserAuthDataSource.dart';
import 'package:eco_swap/model/RentalOrder.dart';
import 'package:eco_swap/model/ReviewModel.dart';
import 'package:eco_swap/model/UserModel.dart';
import 'package:eco_swap/util/Result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UserAuthDataSource extends BaseUserAuthDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool isFirstLoad = true;

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
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

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
          UserModel? user = await getUserDataFirebase(idToken);
          saveUserLocal(user!);
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
  Future<String> setProfileImage(String imagePath) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      File imageFile = File(imagePath);
      String fileName = currentUser!.uid;
      String filePath = 'userImage/$fileName';
      await FirebaseStorage.instance.ref().child(filePath).putFile(imageFile);
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      final String idToken = currentUser.uid;
      databaseReference
          .child('users')
          .child(idToken)
          .child('imageUrl')
          .set(downloadURL);
      return downloadURL;
    } catch (e) {
      print('Errore durante il caricamento dell\'immagine: $e');
      return '';
    }
  }

  Future<String?> getProfileImage() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String idToken = currentUser!.uid;
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    try {
      DataSnapshot snapshot = await databaseReference
          .child('users')
          .child(idToken)
          .child('imageUrl')
          .get();
      if (snapshot.value != null) {
        String imageUrl = snapshot.value.toString();
        return imageUrl;
      } else {
        print('L\'URL dell\'immagine non è presente nel database.');
        return null;
      }
    } catch (error) {
      print('Si è verificato un errore durante il recupero dei dati: $error');
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
      UserModel? user = await getUserDataFirebase(idToken);
      saveUserLocal(user!);
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
      List<String> listaVuota = [];
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
        'imageUrl':
            "https://firebasestorage.googleapis.com/v0/b/ecoswap-64d07.appspot.com/o/userImage%2Fprofile.jpg?alt=media&token=494b1220-95a0-429a-8dd4-a5bd7ae7a61a",
        'reviews': listaVuota,
        'activeRentalsSell': listaVuota,
        'activeRentalsBuy': listaVuota,
        'finishedRentalsSell': listaVuota,
        'finishedRentalsBuy': listaVuota,
        'favoriteRentals': listaVuota,
        'favoriteExchanges': listaVuota,
      };
      final String databasePath = 'users';
      await databaseReference
          .child(databasePath)
          .child(idToken)
          .set(userData)
          .then((_) => newUser = UserModel(
                idToken: idToken,
                name: name,
                lastName: lastName,
                email: currentUser.email,
                latitude: 0,
                longitude: 0,
                birthDate: birthDate,
                phoneNumber: phoneNumber,
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/ecoswap-64d07.appspot.com/o/userImage%2Fprofile.jpg?alt=media&token=494b1220-95a0-429a-8dd4-a5bd7ae7a61a",
                reviews: listaVuota,
                publishedRentals: listaVuota,
                publishedExchange: listaVuota,
                activeRentalsBuy: listaVuota,
                finishedRentalBuy: listaVuota,
                activeRentalsSell: listaVuota,
                finishedRentalsSell: listaVuota,
                favoriteRentals: listaVuota,
                favoriteExchanges: listaVuota,
              ));
      Result result = UserResponseSuccess(newUser!);
      saveUserLocal(newUser!);

      return result;
    } catch (error) {
      Result result = ErrorResult("errore save user $error.toString()");
      return result;
    }
  }

  @override
  void deleteUser() {
    FirebaseAuth.instance.currentUser?.delete();
  }

  @override
  Future<void> updatePosition(bool hasPermission) async {
    Position? _currentPosition;
    String databasePath;
    if (!hasPermission) return;
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String idToken = currentUser!.uid;
      databasePath = 'users/$idToken/lat';
      await databaseReference
          .child(databasePath)
          .set(_currentPosition.latitude);
      databasePath = 'users/$idToken/long';
      await databaseReference
          .child(databasePath)
          .set(_currentPosition.longitude);
      UserModel? user = await getUser();
      if (user != null) {
        user.latitude = _currentPosition.latitude;
        user.longitude = _currentPosition.longitude;
        await saveUserLocal(user);
      }
    } catch (e) {
      debugPrint(e.toString());
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

  @override
  Future<void> saveUserLocal(UserModel user) async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> userMap = user.toMap();
    await prefs.setString('user', json.encode(userMap));
  }

  @override
  Future<void> saveCredential(String email, String password) async {
    await _storage.write(key: 'password', value: password);
    await _storage.write(key: 'email', value: email);
  }

  @override
  Future<void> deleteCredential() async {
    await _storage.delete(key: 'password');
    await _storage.delete(key: 'email');
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

  @override
  Future<UserModel?> getUserDataFirebase(String idToken) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('users/$idToken').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic>? userData =
            snapshot.value as Map<dynamic, dynamic>?;
        String name = userData?['username'];
        String email = userData?['email'];
        String lastName = userData?['lastname'];
        String birthDate = userData?['birthDate'];
        double lat = userData?['lat'];
        double long = userData?['long'];
        String imageUrl = userData?['imageUrl'];
        String phoneNumber = userData?['phoneNumber'];
        Map<dynamic, dynamic>? reviews = userData?['reviews'];
        List<dynamic>? publishedExchanges = userData?['publishedExchanges'];
        List<dynamic>? publishedRentals = userData?['publishedRentals'];
        List<RentalOrder>? activeRentalsBuy =
            _convertToRentalOrderList(userData?['activeRentalsBuy']);
        List<RentalOrder>? activeRentalsSell =
            _convertToRentalOrderList(userData?['activeRentalsSell']);
        List<RentalOrder>? finishedRentalsSell =
            _convertToRentalOrderList(userData?['finishedRentalsSell']);
        List<RentalOrder>? finishedRentalsBuy =
            _convertToRentalOrderList(userData?['finishedRentalsBuy']);

        List<dynamic>? favoriteRentals = userData?['favoriteRentals'];
        List<dynamic>? favoriteExchanges = userData?['favoriteExchanges'];
        return UserModel(
            idToken: idToken,
            name: name,
            lastName: lastName,
            email: email,
            latitude: lat,
            longitude: long,
            birthDate: birthDate,
            phoneNumber: phoneNumber,
            imageUrl: imageUrl,
            reviews: reviews,
            publishedExchange: publishedExchanges,
            publishedRentals: publishedRentals,
            activeRentalsBuy: activeRentalsBuy,
            finishedRentalBuy: finishedRentalsBuy,
            activeRentalsSell: activeRentalsSell,
            finishedRentalsSell: finishedRentalsSell,
            favoriteRentals: favoriteRentals,
            favoriteExchanges: favoriteExchanges);
      } else {
        return null;
      }
    } catch (error) {
      print(
          "Errore durante il recupero dei dati dell'utente con idToken: $idToken, Errore: $error");
      return null;
    }
  }

  List<RentalOrder>? _convertToRentalOrderList(List<dynamic>? list) {
    if (list == null) return null;
    try {
      return list.map((item) {
        if (item is Map<String, dynamic>) {
          return RentalOrder.fromMap(item);
        } else if (item is Map) {
          return RentalOrder.fromMap(Map<String, dynamic>.from(item));
        } else {
          throw Exception(
              'Elemento della lista non convertibile in Map<String, dynamic>: $item');
        }
      }).toList();
    } catch (e) {
      print('Errore durante la conversione della lista: $e');
      return null;
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

  @override
  Future<void> saveActiveRentalsBuy(UserModel user) async {
    try {
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/activeRentalsBuy';
      List<Map<String, dynamic>> rentalsSellMapList = user.activeRentalsBuy
          .map((rentalOrder) => rentalOrder.toMap())
          .toList();
      await _databaseReference.child(databasePath).set(rentalsSellMapList);
    } catch (error) {
      print('Errore durante il caricamento del rental attivo comprato: $error');
    }
  }

  @override
  Future<void> saveActiveRentalsSell(UserModel user) async {
    try {
      final DatabaseReference _databaseReference =
            FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/activeRentalsSell';
      List<Map<String, dynamic>> rentalsSellMapList = user.activeRentalsSell
          .map((rentalOrder) => rentalOrder.toMap())
          .toList();
      await _databaseReference.child(databasePath).set(rentalsSellMapList);
    } catch (error) {
      print('Errore durante il caricamento del rental attivo vendita: $error');
    }
  }

  @override
  Future<void> saveFinishedRentalsSell(UserModel user) async {
    try {
      print("finished rental sell " +user.finishedRentalsSell.length.toString());
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/finishedRentalsSell';
      List<Map<String, dynamic>> rentalsSellMapList = user.finishedRentalsSell
          .map((rentalOrder) => rentalOrder.toMap())
          .toList();
      await _databaseReference.child(databasePath).set(rentalsSellMapList);
    } catch (error) {
      print('Errore durante il caricamento del rental finito vendita: $error');
    }
  }

  @override
  Future<void> saveFinishedRentalsBuy(UserModel user) async {
    try {
      print("finished rental buy " +user.finishedRentalsBuy.length.toString());
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/finishedRentalsBuy';
      List<Map<String, dynamic>> rentalsSellMapList = user.finishedRentalsBuy
          .map((rentalOrder) => rentalOrder.toMap())
          .toList();
      await _databaseReference
          .child(databasePath)
          .set(rentalsSellMapList);
    } catch (error) {
      print('Errore durante il caricamento del rental finito comprato: $error');
    }
  }

  @override
  Future<void> savePublishedRentals(UserModel user) async {
    try {
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/publishedRentals';
      saveUserLocal(user);
      await _databaseReference.child(databasePath).set(user.publishedRentals);
    } catch (error) {
      print('Errore durante il caricamento del rental finito vendita: $error');
    }
  }

  @override
  Future<void> savePublishedExchanges(UserModel user) async {
    try {
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/publishedExchanges';
      saveUserLocal(user);
      await _databaseReference.child(databasePath).set(user.publishedExchange);
    } catch (error) {
      print('Errore durante il caricamento del exchange finito: $error');
    }
  }

  @override
  Future<void> saveFavoriteRentals(UserModel user) async {
    try {
      saveUserLocal(user);
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/favoriteRentals';
      await _databaseReference.child(databasePath).set(user.favoriteRentals);
    } catch (error) {
      print('Errore durante il salvataggio del rental preferito: $error');
    }
  }

  @override
  Future<void> saveFavoriteExchange(UserModel user) async {
    try {
      saveUserLocal(user);
      final DatabaseReference _databaseReference =
          FirebaseDatabase.instance.reference();
      final String databasePath = 'users/${user.idToken}/favoriteExchanges';
      await _databaseReference.child(databasePath).set(user.favoriteExchange);
    } catch (error) {
      print('Errore durante il salvataggio del exchange preferito: $error');
    }
  }

  @override
  Future<void> saveReview(String userId /*id user che riceve la recensione*/,
      String reviewContent, int stars) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    String idToken = currentUser!.uid;
    final DatabaseReference _databaseReference =
        FirebaseDatabase.instance.reference();
    final String databasePath = 'users/$userId/reviews';
    try {
      await _databaseReference.child(databasePath).push().set({
        'userIdToken': idToken, //id user che ha fatto la recensione
        'text': reviewContent,
        'stars': stars,
      });
      print('Recensione salvata con successo.');
    } catch (error) {
      print('Errore durante il salvataggio della recensione: $error');
    }
  }

  @override
  void setupFirebaseListener() async {
    UserModel? currentUser = await getUser();
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle your logic for local notification on iOS
      },
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Richiedi permessi solo una volta
    await _requestPermissionsOnce(_flutterLocalNotificationsPlugin);

    var userRef = FirebaseDatabase.instance.ref().child('users').child(currentUser!.idToken).child("activeRentalsSell");
    userRef.onChildAdded.listen((event) async {
      bool controllo=false;
        final RentalOrder order = RentalOrder.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
        currentUser.activeRentalsSell.forEach((element) {
          if(element.idToken==order.idToken){
            controllo=true;
          }
        });
        if(!controllo){
            //contains non funzionante
            currentUser.addToActiveRentalsSell(order);
             saveUserLocal(currentUser);
            _showNotification(order, _flutterLocalNotificationsPlugin);
          }
    });
  }

  Future<void> _requestPermissionsOnce(FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin) async {
    final prefs = await SharedPreferences.getInstance();
    bool? isPermissionRequested = prefs.getBool('isPermissionRequested');

    if (isPermissionRequested == null || !isPermissionRequested) {
      // Richiedi permessi su iOS
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Richiedi permessi su Android (necessario solo se usi Android 13 o superiore)
      if (Platform.isAndroid) {
        await _requestAndroidPermissions();
      }

      // Imposta il flag per indicare che i permessi sono stati richiesti
      await prefs.setBool('isPermissionRequested', true);
    }
  }

  Future<void> _requestAndroidPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _showNotification(RentalOrder order, FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'new_order_channel', 'New Order Notifications',
        importance: Importance.max, priority: Priority.high, showWhen: false, );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
     _flutterLocalNotificationsPlugin.show(
      0,
      'New Order from: ${order.nameBuyer}',
      'You have a new order: ${order.nameRental}',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
