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
                  Text("Published exchanges"),
                  _buildDivider(),
                  SizedBox(
                    height: 152,
                    child: _buildExchangeList(context, currentUser.publishedExchange),
                  ),
                  Text("Published rentals"),
                  _buildDivider(),
                  SizedBox(
                    height: 152,
                    child:  _buildRentalList(context, currentUser.publishedRentals),
                  ),
                  Text("Items Sold (To Be Returned)"),
                  _buildDivider(),
                  SizedBox(
                    height: 152,
                    child: _buildRentalList(context, currentUser.activeRentalsSell),
                  ),
                  Text("Items Purchased (To Return)"),
                  _buildDivider(),
                  SizedBox(
                    height: 152,
                    child:  _buildRentalList(context, currentUser.activeRentalsBuy),
                  ),
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

  Widget _buildHorizontalListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120, // Larghezza dell'immagine
                    height: 120, // Altezza dell'immagine
                    color: Colors.grey[300], // Colore di sfondo temporaneo
                    child: Icon(Icons.image), // Immagine temporanea
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Item $index',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
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
          return
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: exchanges.length,
              itemBuilder: (context, index) {
                final exchange = exchanges[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 120, // Larghezza dell'immagine
                      height: 120, // Altezza dell'immagine
                      color: Colors.grey[300], // Colore di sfondo temporaneo
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage(
                          placeholder: AssetImage('assets/image/loading_indicator.gif'),
                          // Immagine di placeholder (un'animazione di caricamento circolare, ad esempio)
                          height: 200,
                          image: NetworkImage(exchange.imageUrl),
                          // URL dell'immagine principale
                          fit: BoxFit.cover, // Adatta l'immagine all'interno del container

                        ),
                      ),// Immagine temporanea
                    ),
                    SizedBox(height: 8),
                    Text(
                     exchange.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
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
          return Center(child: Text('Errore durante il recupero dei exchange: ${snapshot.error}'));
        } else {
          List<Rental> rentals = snapshot.data ?? [];
          return
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120, // Larghezza dell'immagine
                        height: 120, // Altezza dell'immagine
                        color: Colors.grey[300], // Colore di sfondo temporaneo
                        child:ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/image/loading_indicator.gif'),
                            // Immagine di placeholder (un'animazione di caricamento circolare, ad esempio)
                            height: 200,
                            image: NetworkImage(rental.imageUrl),
                            // URL dell'immagine principale
                            fit: BoxFit.cover, // Adatta l'immagine all'interno del container

                          ),
                        ),// Immagine temporanea
                      ),
                      SizedBox(height: 8),
                      Text(
                        rental.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            );
        }
      },
    );
  }


  Widget _buildDivider() {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }
}
