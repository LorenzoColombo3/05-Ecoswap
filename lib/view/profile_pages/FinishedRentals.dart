import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class FinishedRentals extends StatefulWidget {
  final UserModel currentUser;

  const FinishedRentals({super.key, required this.currentUser});

  @override
  State<FinishedRentals> createState() => _FinishedRentalsState();
}

class _FinishedRentalsState extends State<FinishedRentals> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  int _selectedIndex = 1;
  Color rentalButtonColor = Color(0xFF7BFF81);
  Color exchangeButtonColor = Colors.transparent;
  List<RentalOrder> _rentalsSoldId = [];
  List<RentalOrder> _rentalsBoughtId = [];

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    _rentalsSoldId = widget.currentUser.finishedRentalsSell;
    _rentalsBoughtId = widget.currentUser.finishedRentalsBuy;
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Orders'),
        backgroundColor: colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5.0),
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
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (states) => rentalButtonColor,
                        ),
                      ),
                      child: Text(
                        'Items sold',
                        style: TextStyle(color: _selectedIndex == 0 ? Colors.black : colorScheme.onPrimary,),
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
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (states) => exchangeButtonColor,
                        ),
                      ),
                      child: Text(
                        'Items bought',
                        style: TextStyle(color: _selectedIndex == 1 ? Colors.black : colorScheme.onPrimary,),
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
                  _buildRentalsList(_rentalsSoldId),
                  _buildRentalsList(_rentalsBoughtId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder _buildRentalsList(List<RentalOrder> itemsList) {
    List<String> listApp = [];
    for (RentalOrder order in itemsList) {
      listApp.add(order.rentalId);
    }
    return FutureBuilder<List<Rental>>(
        future: adViewModel.getRentalsByIdTokens(listApp),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore durante il recupero dei rental: ${snapshot.error}'));
          } else {
            List<Rental> rentals = snapshot.data ?? [];
            return ListView.builder(
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                final order = itemsList[index];
                return ListTile(
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
                  subtitle: Text("€" + order.price.toString() + "\n"
                                 "Date:" +order.dateTime),
                );
              },
            );
          }
        },
      );
  }


}
