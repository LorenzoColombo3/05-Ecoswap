import 'package:eco_swap/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';
import '../../widget/FullScreenImage.dart';
import 'RentalPayment.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(widget.rental.title),
        backgroundColor: colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<UserModel?>(
          future: userViewModel.getUserData(widget.rental.userId),
          builder: (context, snapshot) {
            bool isFavorite;
            isFavorite = widget.currentUser.favoriteRentals.contains(widget.rental.idToken);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              String? img= snapshot.data?.imageUrl;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Mostra l'immagine a schermo intero
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImage(imageUrl: widget.rental.imageUrl ?? ''),
                              ),
                            );
                          },
                          child: Container(
                            height: 400, // Altezza arbitraria per l'immagine
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              image: DecorationImage(
                                image: NetworkImage(widget.rental.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:  GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isFavorite) {
                                    widget.currentUser.removeFromFavoriteRentals(widget.rental.idToken);
                                    isFavorite=false;
                                  } else {
                                    widget.currentUser.addToFavoriteRentals(widget.rental.idToken);
                                    isFavorite=true;
                                  }
                                  if(widget.currentUser.favoriteRentals.contains(" ")) {
                                    widget.currentUser.removeFromFavoriteRentals(" ");
                                     userViewModel.saveFavoriteRentals(widget.currentUser);
                                  }else{
                                     userViewModel.saveFavoriteRentals(widget.currentUser);
                                  }
                                });
                              },
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 8.0,
                                    right: 8.0,
                                    child:
                                    Icon(
                                      Icons.favorite,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                      size: 24.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text("Published on: ${widget.rental.dateLoad.substring(0,10)}"),
                        Divider(
                          color: colorScheme.onPrimary,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.background,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                                    onTap: () {
                                      // Aggiungere qui la logica da eseguire quando viene toccato il ListTile
                                    },
                                    title: Text(snapshot.data!.name),
                                    subtitle: Text("addStarsRating"),
                                    leading:
                                    img != null
                                        ? CircleAvatar(
                                      backgroundImage: NetworkImage(img),
                                    )
                                        : CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                          ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            // Logica per avviare la chat
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<
                                Color>((states) => colorScheme.background),
                          ),
                          child: Text(
                            'Start a Chat',
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
                                          "${widget.rental.description}",
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
                                    fontWeight: FontWeight.bold,// Colore del testo normale
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: SizedBox(width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Max days of rent: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.rental.maxDaysRent}\n",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 20),// Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Daily cost: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.rental.dailyCost}\n",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Unit remained: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${widget.rental.unitRented} / ${widget.rental.unitNumber}\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 20), // Spazio vuoto per spostare il testo verso sinistra
                                    ),
                                    const TextSpan(
                                      text: 'Location: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0, // Testo in grassetto
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${widget.rental.position}",
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
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 55.0,
        color: colorScheme.background,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RentalPayment(
                  rental: widget.rental,
                  currentUser: widget.currentUser,
                ),
              ),
            );
          },
          child: RichText(
            text: const TextSpan(
              text: "Start rental",
              style: TextStyle(

                fontSize: 20.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,// Colore del testo normale
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}
