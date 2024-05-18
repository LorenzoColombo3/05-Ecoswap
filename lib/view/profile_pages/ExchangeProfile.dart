import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../model/Exchange.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../util/ServiceLocator.dart';
import '../../model/UserModel.dart';
import '../../widget/FullScreenImage.dart';

class ExchangeProfile extends StatefulWidget {
  final UserModel currentUser;
  final Exchange exchange;

  const ExchangeProfile(
      {super.key, required this.exchange, required this.currentUser});

  @override
  State<ExchangeProfile> createState() => _ExchangeProfileState();
}

class _ExchangeProfileState extends State<ExchangeProfile> {
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
        title: Text(widget.exchange.title),
        backgroundColor: colorScheme.background,
      ),
      body: SingleChildScrollView(
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
                          builder: (context) => FullScreenImage(
                              imageUrl: widget.exchange.imageUrl ?? ''),
                        ),
                      );
                    },
                    child: Container(
                      height: 400, // Altezza arbitraria per l'immagine
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: NetworkImage(widget.exchange.imageUrl ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                      "Published on: ${widget.exchange.dateLoad.substring(0, 10)}"),
                  Divider(
                    color: colorScheme.onPrimary,
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      widget.currentUser.removeFromActivePublishedExchanges(
                          widget.exchange.idToken);
                      adViewModel.removeExchange(widget.exchange.idToken);
                      userViewModel
                          .savePublishedExchanges(widget.currentUser)
                          .then((value) => () {
                                Navigator.of(context).pop();
                              });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => colorScheme.background),
                    ),
                    child: Text(
                      'Remove item',
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
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    widget.exchange.description,
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
                            text: "Exchange information:\n",
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight:
                                  FontWeight.bold, // Colore del testo normale
                            ),
                            children: [
                              WidgetSpan(
                                child: SizedBox(
                                    width:
                                        20), // Spazio vuoto per spostare il testo verso sinistra
                              ),
                              const TextSpan(
                                text: 'Location: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0, // Testo in grassetto
                                ),
                              ),
                              TextSpan(
                                text: "${widget.exchange.position}",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
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
            ),
          ],
        ),
      ),
    );
  }
}
