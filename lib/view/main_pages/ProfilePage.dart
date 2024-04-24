import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
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
  Color rentalButtonColor = Colors.blue.withOpacity(0.2);
  Color exchangeButtonColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    userViewModel.getUser().then((user){
      currentUser = (user as UserResponseSuccess).getData();
    });
    imagePath = "";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result?>(
      future: userViewModel.getUser(), // Ottieni l'utente
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Verifica se lo snapshot ha completato il caricamento dei dati
          currentUser = (snapshot.data as UserResponseSuccess).getData();
          return buildContent(); // Costruisci il widget principale
        } else {
          return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
        }
      },
    );
  }

  Widget buildContent() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(''),
        actions: const [
          SettingsMenu(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipOval(
              child: Image.network(
                'https://cc-prod.scene7.com/is/image/CCProdAuthor/FF-SEO-text-to-image-marquee-1x?\$pjpeg\$&jpegSize=100&wid=600',
                width: 150, // Imposta la larghezza dell'immagine
                height: 150, // Imposta l'altezza dell'immagine
                fit: BoxFit.cover, // Scala l'immagine per adattarla al widget Image
              ),
            ),
            const SizedBox(height: 20),
            Text(
              currentUser.name, // Sostituisci con il nome utente reale
              style: const TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                        rentalButtonColor = Colors.blue.withOpacity(0.2);
                        exchangeButtonColor = Colors.transparent;
                      });
                    },
                    child: Text(
                      'Rental',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => rentalButtonColor),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                        exchangeButtonColor = Colors.blue.withOpacity(0.2);
                        rentalButtonColor = Colors.transparent;
                      });
                    },
                    child: Text(
                      'Exchange',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => exchangeButtonColor),
                    ),
                  ),
                ),
              ],
            ),
            IndexedStack(
              index: _selectedIndex,
              children: <Widget> [
                LoadRentalPage(onButtonPressed: () {  },),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
