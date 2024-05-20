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
import '../main_pages/LeaveReviewPage.dart';
import 'BoughtRentalProfile.dart';
import 'ExchangeProfile.dart';
import 'RentalProfile.dart';
import 'ReviewsPage.dart';
import 'SoldRentalProfile.dart';

class SellerProfilePage extends StatefulWidget {
  UserModel currentUser;
  String sellerId;
  SellerProfilePage({super.key, required this.currentUser, required this.sellerId});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
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
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Text('Seller Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: userViewModel.getUserData(widget.sellerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No seller data available'));
          } else {
            final sellerUser = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.network(
                      sellerUser.imageUrl ?? '',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    sellerUser.name ?? '', // Assicurati di avere il nome dell'utente
                    style: const TextStyle(fontSize: 24),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsPage(
                            currentUser: sellerUser,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(colorScheme.background),
                    ),
                    child: Text("${sellerUser.name}'s reviews"),
                  ),
                  Text("Published exchanges"),
                  _buildDivider(),
                  SizedBox(
                    height: 152,
                    child: _buildExchangeList(context, widget.currentUser.publishedExchange),
                  ),
                  Text("Published rentals"),
                  _buildDivider(),
                  SizedBox(
                    height: 152,
                    child: _buildRentalList(context, widget.currentUser.publishedRentals, 0),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: FutureBuilder<UserModel?>(
        future: userViewModel.getUserData(widget.sellerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || !snapshot.hasData) {
            return SizedBox.shrink(); // Return an empty widget if the future is not completed
          } else {
            final sellerUser = snapshot.data!;
            return BottomAppBar(
              height: 55.0,
              color: colorScheme.background,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveReviewPage(
                        currentUser: widget.currentUser,
                        sellerUser: sellerUser,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                },
                child: RichText(
                  text: const TextSpan(
                    text: "Leave a review",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
      ),
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
                          currentUser: widget.currentUser,
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
                            currentUser: widget.currentUser,
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
                            currentUser: widget.currentUser,
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
                            currentUser: widget.currentUser,
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
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }
}
