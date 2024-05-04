import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class RentalHomePage extends StatefulWidget {
  final UserModel currentUser;

  const RentalHomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<RentalHomePage> createState() => RentalHomePageState();
}

class RentalHomePageState extends State<RentalHomePage> {
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  bool _isLoading = false;
  List<Rental> _rentals = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    loadMoreData(index);
  }



  Future<void> loadMoreData(int index) async {
    setState(() {
      _isLoading = true;
    });
    adViewModel
        .getRentalsInRadius(widget.currentUser.latitude,
            widget.currentUser.longitude, 30, _rentals.length)
        .then((value) => {
              setState(() {
                _rentals.addAll(value);
                _isLoading = false;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: _rentals.length + (_isLoading ? 1 : 0),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        mainAxisExtent: 300,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index < _rentals.length) {
          return _buildRentalItem(_rentals[index]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildRentalItem(Rental rental) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/image/loading_indicator.gif'),
              // Immagine di placeholder (un'animazione di caricamento circolare, ad esempio)
              height: 200,
              image: NetworkImage(rental.imageUrl),
              // URL dell'immagine principale
              fit: BoxFit.cover, // Adatta l'immagine all'interno del container
            ),
          ),
          Stack(
            children: [
              ListTile(
                title: Text(
                  rental.title,
                  overflow: TextOverflow.ellipsis, // Testo non va a capo
                ),
                subtitle: Text(
                  "€${rental.dailyCost}",
                  overflow: TextOverflow.ellipsis, // Testo non va a capo
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    // Aggiungere qui la logica per gestire il tap sull'icona del cuore
                    // Ad esempio, potresti aggiornare lo stato per indicare che questo elemento è contrassegnato come preferito
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    // Personalizza il padding dell'icona
                    child: Icon(
                      Icons.favorite, // Icona del cuore come preferito
                      color: Colors.grey,
                      // Colore rosso per indicare che è contrassegnato come preferito
                      size: 24.0, // Dimensione dell'icona personalizzata
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
