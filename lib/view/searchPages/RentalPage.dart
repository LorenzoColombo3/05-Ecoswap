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

class RentalPage extends StatefulWidget {
  final Rental rental;
  final UserModel currentUser;
  const RentalPage({Key? key,  required this.rental, required this.currentUser})
      : super(key: key);

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;

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
        title: const Text('Rental Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200, // Altezza arbitraria per l'immagine
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: NetworkImage(widget.rental.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),
            const Text(
              'User Name', // Da sostituire con il vero nome utente
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blue, // Colore blu per il nome utente cliccabile
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.rental.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.rental.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Max days rent: ${widget.rental.maxDaysRent}', // Da sostituire con la vera data
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Daily cost: ${widget.rental.dailyCost}', // Da sostituire con la vera posizione
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Date: ${widget.rental.dateLoad.substring(0,10)}', // Da sostituire con la vera data
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Location: ${widget.rental.position}', // Da sostituire con la vera posizione
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Logica per avviare la chat
              },
              child: const Text('Start a Chat'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logica per avviare la chat
              },
              child: const Text('Start Rental'),
            ),
          ],
        ),
      ),
    );
  }
}
