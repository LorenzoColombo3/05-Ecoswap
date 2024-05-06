import 'package:flutter/material.dart';
import '../../model/Exchange.dart';
import '../../model/UserModel.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../util/ServiceLocator.dart';


class ExchangePage extends StatefulWidget {
  final Exchange exchange;
  final UserModel currentUser;

  const ExchangePage({Key? key, required this.exchange, required this.currentUser})
      : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange Details'),
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
                  image: NetworkImage(widget.exchange.imageUrl),
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
              widget.exchange.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.exchange.description,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
             Text(
              'Date: ${widget.exchange.dateLoad.substring(0,10)}', // Da sostituire con la vera data
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
             Text(
              'Location: ${widget.exchange.position}', // Da sostituire con la vera posizione
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
          ],
        ),
      ),
    );
  }
}
