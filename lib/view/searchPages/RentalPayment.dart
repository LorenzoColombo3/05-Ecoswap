import 'package:flutter/material.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class RentalPayment extends StatefulWidget {
  final Rental rental;
  final UserModel currentUser;

  const RentalPayment({Key? key,  required this.rental, required this.currentUser})
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
  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    if(unitNumber>0) {
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
                    if(unitNumber < int.parse(widget.rental.unitNumber) - int.parse(widget.rental.unitRented))
                      setState(() {
                        unitNumber++;
                      });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Descrizione e prezzo
            Text(
              'Description: ${widget.rental.description}\nPrice: ${unitNumber * int.parse(widget.rental.dailyCost) }',
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
                  onPressed: () {

                  },
                  child: Text('Pay with Stripe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
