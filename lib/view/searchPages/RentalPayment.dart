import 'package:eco_swap/model/RentalOrder.dart';
import 'package:eco_swap/view/main_pages/NavigationPage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../payments/stripe_service.dart';
import '../../util/ServiceLocator.dart';
import '../main_pages/HomePage.dart';

class RentalPayment extends StatefulWidget {
  final Rental rental;
  final UserModel currentUser;

  const RentalPayment(
      {Key? key, required this.rental, required this.currentUser})
      : super(key: key);

  @override
  State<RentalPayment> createState() => _RentalPaymentState();
}

class _RentalPaymentState extends State<RentalPayment> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  bool isChecked = false;
  int unitNumber = 1;
  int daysRent = 1;
  late UserModel sellerUser;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    userViewModel
        .getUserData(widget.rental.userId)
        .then((value) => sellerUser = value!);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo del noleggio
            Text(
              'Renting: ${widget.rental.title}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),

            // Selettore di unità da noleggiare
            Row(
              children: [
                Text('Units: '),
                IconButton(
                  onPressed: () {
                    if (unitNumber > 0) {
                      setState(() {
                        unitNumber--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(unitNumber.toString()), // Numero di unità selezionate
                IconButton(
                  onPressed: () {
                    if (unitNumber <
                        int.parse(widget.rental.unitNumber) -
                            int.parse(widget.rental.unitRented))
                      setState(() {
                        unitNumber++;
                      });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('How many days?: '),
                IconButton(
                  onPressed: () {
                    if (daysRent > 0) {
                      setState(() {
                        daysRent--;
                      });
                    }
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(daysRent.toString()), // Numero di unità selezionate
                IconButton(
                  onPressed: () {
                    if (daysRent < int.parse(widget.rental.maxDaysRent))
                      setState(() {
                        daysRent++;
                      });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 8.0),

            // Descrizione e prezzo
            Text(
              'Description: ${widget.rental.description}\nPrice: ${(unitNumber *
                  int.parse(widget.rental.dailyCost)) * daysRent}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),

            // Accettazione dei termini
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text('I agree to the terms and conditions'),
              ],
            ),
            SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) => colorScheme.background),
                  ),
                  onPressed: () {
                    StripeService.stripePaymentCheckout(
                        widget.rental, unitNumber, daysRent, context, mounted,
                        onSuccess: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("operation successed")),
                          );
                          widget.rental.unitRented =
                              (int.parse(widget.rental.unitRented) + unitNumber)
                                  .toString();
                          adViewModel.updateRentalData(widget.rental);
                          RentalOrder order = RentalOrder(idToken: Uuid().v4(),
                              sellerId: sellerUser.idToken,
                              buyerId: widget.currentUser.idToken,
                              rentalId:widget.rental.idToken,
                              dateTime: DateTime.now().toString().substring(0,10),
                              unitRented: unitNumber,
                              price: (unitNumber * int.parse(widget.rental.dailyCost)) * daysRent,
                              days: daysRent);
                          widget.currentUser.addToActiveRentalsBuy(order);
                          sellerUser.addToActiveRentalsSell(order);
                          userViewModel
                              .saveActiveRentalsBuy(widget.currentUser)
                              .then((value) =>
                              userViewModel.saveActiveRentalsSell(sellerUser));
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NavigationPage(logoutCallback: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ));
                                    }),
                              ));
                        }, onCancel: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("operation cancelled")),
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            NavigationPage(logoutCallback: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                            }),
                      ));
                    }, onError: (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            NavigationPage(logoutCallback: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ));
                            }),
                      ));
                    }).then((value) => value.call());
                  },
                  child: Text(
                    'Pay with Stripe',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
