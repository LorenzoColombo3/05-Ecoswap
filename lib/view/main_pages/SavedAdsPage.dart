import 'dart:async';
import 'dart:io';

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
import '../../util/ServiceLocator.dart';
import '../searchPages/ExchangePage.dart';
import '../searchPages/RentalPage.dart';

class SavedAdsPage extends StatefulWidget {
  @override
  _SavedAdsPageState createState() => _SavedAdsPageState();
}

class _SavedAdsPageState extends State<SavedAdsPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late UserModel currentUser;
  int _selectedIndex = 1;
  Color rentalButtonColor = Color(0xFF7BFF81);
  Color exchangeButtonColor = Colors.transparent;
  List<dynamic> _rentalsId = [];
  List<dynamic> _exchangesId = [];

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    userViewModel.getUser().then((value) {
      currentUser = value!;
      _exchangesId = currentUser.favoriteExchange;
      _rentalsId = currentUser.favoriteRentals;
      setState(() {
      });
    });
    _selectedIndex = 0;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return
      Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: colorScheme.primary,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                          rentalButtonColor = colorScheme.background;
                          exchangeButtonColor = Colors.transparent;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                                (states) => rentalButtonColor),
                      ),
                      child: Text(
                        'Rental',
                        style: TextStyle(color: _selectedIndex == 0 ? Colors.black : colorScheme.onPrimary),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          _selectedIndex = 1;
                          exchangeButtonColor = colorScheme.background;
                          rentalButtonColor = Colors.transparent;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                                (states) => exchangeButtonColor),
                      ),
                      child: Text(
                        'Exchange',
                        style: TextStyle(color: _selectedIndex == 1 ? Colors.black : colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  _buildRentalsList(),
                  _buildExchangesList(),
                ],
              ),
            ),
          ],
        ),
    );
  }

  FutureBuilder _buildRentalsList() {
    return
      FutureBuilder<List<Rental>>(
        future: adViewModel.getRentalsByIdTokens(_rentalsId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore durante il recupero dei rental: ${snapshot.error}'));
          } else {
            List<Rental> rentals = snapshot.data ?? [];
            return ListView.builder(
              padding: EdgeInsets.zero,
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
                  title: Text(rental.title),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/image/loading_indicator.gif'), // Immagine di placeholder
                      image: NetworkImage(rental.imageUrl), // Immagine effettiva
                      fit: BoxFit.cover, // Modalità di adattamento dell'immagine
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                  subtitle: Text("€" + rental.dailyCost),
                );
              },
            );
          }
        },
      );
  }
  FutureBuilder _buildExchangesList() {
    return FutureBuilder<List<Exchange>>(
      future: adViewModel.getExchangesByIdTokens(_exchangesId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Errore durante il recupero dei exchange: ${snapshot.error}'));
        } else {
          List<Exchange> exchanges = snapshot.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: exchanges.length,
            itemBuilder: (context, index) {
              final exchange = exchanges[index];
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
                title: Text(exchange.title),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/image/loading_indicator.gif'), // Immagine di placeholder
                    image: NetworkImage(exchange.imageUrl), // Immagine effettiva
                    fit: BoxFit.cover, // Modalità di adattamento dell'immagine
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

}
