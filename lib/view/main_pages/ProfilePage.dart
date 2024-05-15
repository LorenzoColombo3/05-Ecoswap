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
import '../searchPages/ExchangePage.dart';
import '../searchPages/RentalPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel currentUser;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: userViewModel.getUser(), // Ottieni l'utente
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          currentUser = snapshot.data!;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              title: Text(''),
              actions: [
                SettingsMenu(callback: () {
                  setState(() {});
                }),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize:MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.network(
                      currentUser.imageUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentUser.name, // Sostituisci con il nome utente reale
                    style: const TextStyle(fontSize: 24),
                  ),
                  _buildDivider(),
                  _buildExchangeList(context, currentUser.publishedExchange),
                  _buildDivider(),
                  /*_buildRentalList(context, currentUser.publishedRentals),
                  _buildDivider(),
                  _buildExchangeList(context, currentUser.activeRentalsSell),
                  _buildDivider(),
                  _buildRentalList(context, currentUser.activeRentalsBuy),
                  _buildDivider(),*/
                 /* _buildList(context, currentUser.finishedRentalsSell),
                  _buildDivider(),
                  _buildList(context, currentUser.finishedRentalsBuy),
                  _buildDivider(),
                  _buildList(context, currentUser.expiredExchange),*/
                  //controllare se necessario creare liste per ordini conclusi
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

  Widget _buildExchangeList(BuildContext context, List<dynamic> listObject) {
    return FutureBuilder<List<Exchange>>(
      future: adViewModel.getExchangesByIdTokens(listObject),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore durante il recupero dei exchange: ${snapshot.error}'));
        } else {
          List<Exchange> exchanges = snapshot.data ?? [];
          return Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints( maxHeight: 150),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap:true,
                scrollDirection: Axis.horizontal,
                itemCount: exchanges.length,
                itemBuilder: (context, index) {
                  final exchange = exchanges[index];
                  //la listview funziona, il problema sta negli oggetti stampati, vuota andrebbe
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExchangePage(
                            exchange: exchange,
                            currentUser: currentUser,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/image/loading_indicator.gif'), // Immagine di placeholder
                        image: NetworkImage(exchange.imageUrl), // Immagine effettiva
                        fit: BoxFit.fill, // Modalità di adattamento dell'immagine
                      ),
                    ),
                    title: Text(exchange.title),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildRentalList(BuildContext context, List<dynamic> listObject) {
    return FutureBuilder<List<Rental>>(
      future: adViewModel.getRentalsByIdTokens(listObject),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore durante il recupero dei rentals: ${snapshot.error}'));
        } else {
          List<Rental> rentals = snapshot.data ?? [];
          return Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints( maxHeight: 150),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap:true,
                scrollDirection: Axis.horizontal,
                itemCount: rentals.length,
                itemBuilder: (context, index) {
                  final rental = rentals[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RentalPage(
                            rental: rental,
                            currentUser: currentUser,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/image/loading_indicator.gif'), // Immagine di placeholder
                        image: NetworkImage(rental.imageUrl), // Immagine effettiva
                        fit: BoxFit.fill, // Modalità di adattamento dell'immagine
                      ),
                    ),
                    title: Text(rental.title),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }


  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey,
    );
  }
}
