import 'dart:io';

import 'package:eco_swap/model/AdModel.dart';
import 'package:eco_swap/view/profile_pages/BoughtRentalProfile.dart';
import 'package:eco_swap/view/profile_pages/ReviewsPage.dart';
import 'package:eco_swap/view/profile_pages/SoldRentalProfile.dart';
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
import '../../model/RentalOrder.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';
import '../../widget/SettingsMenu.dart';
import '../profile_pages/ExchangeProfile.dart';
import '../profile_pages/RentalProfile.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
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
                }, currentUser: currentUser,),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize:MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Center(
                      child: ClipOval(
                        child: Image.network(
                          currentUser.imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    currentUser.name, // Sostituisci con il nome utente reale
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewsPage(
                              currentUser: currentUser,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(colorScheme.background),
                      ),
                      child: const Text(
                          "My reviews",
                          style: TextStyle(
                            color: Colors.black,
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisSize:MainAxisSize.min,
                    children: [
                      Text(
                        "Published exchanges",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      _buildDivider(),
                      SizedBox(
                        height: 152,
                        child: _buildExchangeList(context, currentUser.publishedExchange),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Published rentals",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      _buildDivider(),
                      SizedBox(
                        height: 152,
                        child:  _buildRentalList(context, currentUser.publishedRentals, 0),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Items Sold (To Be Returned)",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      _buildDivider(),
                      SizedBox(
                        height: 152,
                        child: _buildRentalList(context, currentUser.activeRentalsSell, 1),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Items Purchased (To Return)",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      _buildDivider(),
                      SizedBox(
                        height: 152,
                        child:  _buildRentalList(context, currentUser.activeRentalsBuy, 2),
                      ),
                    ],
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
              return InkWell(
                onTap: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangeProfile(
                      exchange: exchange,
                      currentUser: currentUser,
                    ),
                  ),
                ).then((value) => setState(() {}));
                  },
                child: Container(
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
                ),
              );
            },
          );
        }
      },
    );
  }


  Widget _buildRentalList(BuildContext context, List<dynamic> listObject, int type) {
    List<String>? listApp = [];
    if (listObject is List<RentalOrder>) {

      for (RentalOrder order in listObject) {
        listApp.add(order.rentalId);
      }
    }else{
      listApp = listObject.cast<String>();
    }
    return FutureBuilder<List<Rental>>(
      future: adViewModel.getRentalsByIdTokens(listApp),
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
                return InkWell(
                  onTap: (){
                      if(type == 0){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentalProfile(
                              rental: rental,
                              currentUser: currentUser,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                      }
                      if(type ==1){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SoldRentalProfile(
                              order:  listObject[index],
                              currentUser: currentUser,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                      }
                      if(type ==2){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoughtRentalProfile(
                              order: listObject[index],
                              currentUser: currentUser,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                      }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[300],
                          child:ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage(
                              placeholder: AssetImage('assets/image/loading_indicator.gif'),
                              height: 200,
                              image: NetworkImage(rental.imageUrl),
                              fit: BoxFit.cover,
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
