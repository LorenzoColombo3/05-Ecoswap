import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Rental.dart';
import '../../model/RentalOrder.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';
import '../../widget/FullScreenImage.dart';
import 'SellerProfilePage.dart';

class SoldRentalProfile extends StatefulWidget {
  final UserModel currentUser;
  final RentalOrder order;

  const SoldRentalProfile(
      {super.key, required this.currentUser, required this.order});

  @override
  State<SoldRentalProfile> createState() => _SoldRentalProfileState();
}

class _SoldRentalProfileState extends State<SoldRentalProfile> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late Future<Rental?> rental;
  late UserModel? userBuyer;
  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    rental = adViewModel.getRental(widget.order.rentalId);
    userViewModel.getUserData(widget.order.buyerId).then((value) => userBuyer=value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(widget.order.nameRental),
        backgroundColor: colorScheme.background,
      ),
      body: FutureBuilder<Rental?>(
        future: rental,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No rental data available'));
          } else {
            final rental = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FullScreenImage(
                                        imageUrl: rental.imageUrl ?? ''),
                              ),
                            );
                          },
                          child: Container(
                            height: 400, // Altezza arbitraria per l'immagine
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: NetworkImage(rental.imageUrl ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Divider(
                          color: colorScheme.onPrimary,
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) =>
                            route.isFirst);
                            userBuyer!
                                .removeFromActiveRentalsBuy(widget.order);
                            userBuyer!.addToFinishedRentalsBuy(widget.order);
                            userViewModel
                                .saveActiveRentalsBuy(userBuyer!)
                                .then((value) => userViewModel
                                .saveFinishedRentalsBuy(userBuyer!));
                            widget.currentUser.removeFromActiveRentalsSell(
                                widget.order);
                            widget.currentUser.addToFinishedRentalsSell(
                                widget.order);
                            userViewModel
                                .saveActiveRentalsSell(widget.currentUser)
                                .then((value) =>
                                () {
                              userViewModel.saveFinishedRentalsSell(
                                  widget.currentUser).then((value) =>
                                  Navigator.of(context).popUntil((
                                      route) => route.isFirst));
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<
                                Color>(
                                    (states) => colorScheme.background),
                          ),
                          child: Text(
                            'Claim rental',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Divider(
                          color: colorScheme.onPrimary,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black, // Colore del testo normale
                              ),
                              children: [
                                const TextSpan(
                                  text: "Description:\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0, // Testo in grassetto
                                  ),
                                ),
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0),
                                        child: Text(
                                          rental.description,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: colorScheme.background,
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "Rental information:\n",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight
                                        .bold, // Colore del testo normale
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: SizedBox(
                                          width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Rented on ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.order.dateTime}\n",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Number of days rented ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.order.days.toString()}\n",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'To be returned on: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${addDaysToDate(
                                          widget.order.dateTime,
                                          widget.order.days)}\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                          width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Sold to: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.order.nameBuyer}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                        color: Colors
                                            .blue, // Imposta il colore del testo in blu
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SellerProfilePage(
                                                    currentUser: widget
                                                        .currentUser,
                                                    sellerId: widget.order
                                                        .buyerId, // Passa l'ID del compratore alla pagina del profilo del compratore
                                                  ),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String addDaysToDate(String date, int days) {
    print(date);
    DateTime dateTime = DateFormat('yyyy-MM-dd').parse(date);
    DateTime newDateTime = dateTime.add(Duration(days: days));
    String newDateString = DateFormat('yyyy-MM-dd').format(newDateTime);
    return newDateString;
  }
}
