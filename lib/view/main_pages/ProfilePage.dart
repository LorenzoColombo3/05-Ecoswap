import 'dart:io';

import 'package:eco_swap/model/AdModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Exchange.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../util/Result.dart';
import '../../util/ServiceLocator.dart';
import '../../widget/SettingsMenu.dart';
import '../load_pages/LoadExchangePage.dart';
import '../load_pages/LoadRentalPage.dart';
import '../profile_pages/SettingsPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel currentUser;
  late String imagePath;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  int _selectedIndex = 0;
  Color rentalButtonColor = Color(0xFF7BFF81);
  Color exchangeButtonColor = Colors.transparent;
  late Future<String?> imageUrl;
  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();

    userViewModel.getUser().then((user) {
      currentUser = user!;
    });
    imagePath = "";
    imageUrl = userViewModel.getProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: userViewModel.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          currentUser = snapshot.data!;
          return buildContent();
        } else {
          return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
        }
      },
    );
  }

  Widget buildContent() {
    return FutureBuilder<UserModel?>(
      future: userViewModel.getUser(), // Ottieni l'utente
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Verifica se lo snapshot ha completato il caricamento dei dati
          currentUser = snapshot.data!;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              title: Text(''),
              actions:  [
                SettingsMenu(callback: (){setState(() {

                });}),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FutureBuilder<String?>(
                    future: imageUrl,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
                      } else if (snapshot.hasData && snapshot.data != "") {
                        return ClipOval(
                          child: Image.network(
                            snapshot.data!,
                            width: 150, // Imposta la larghezza dell'immagine
                            height: 150, // Imposta l'altezza dell'immagine
                            fit: BoxFit
                                .cover, // Scala l'immagine per adattarla al widget Image
                          ),
                        );
                      } else {
                        return ClipOval(
                          child: Image.asset(
                            'assets/image/profile.jpg',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ); // Gestisci il caso in cui non ci sia alcun URL immagine
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentUser.name, // Sostituisci con il nome utente reale
                    style: const TextStyle(fontSize: 24),
                  ),
                  _buildDivider(),
                  _buildList(context, currentUser.publishedExchange),
                  _buildDivider(),
                  /*_buildList(context, currentUser.publishedRentals),
                  _buildDivider(),
                  _buildList(context, currentUser.activeRentalsSell),
                  _buildDivider(),
                  _buildList(context, currentUser.activeRentalsBuy),
                  _buildDivider(),
                  _buildList(context, currentUser.finishedRentalsSell),
                  _buildDivider(),
                  _buildList(context, currentUser.finishedRentalsBuy),
                  _buildDivider(),
                  _buildList(context, currentUser.expiredExchange),*/
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> listObject) {
    return ListView.builder(

        scrollDirection: Axis.horizontal,
        itemCount: listObject.length,
        itemBuilder: (context, index) {
          print('Item at index $index: ${listObject[index]}');
          return  Placeholder();
        },

    );
  }


  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey,
    );
  }
}

