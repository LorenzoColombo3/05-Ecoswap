import 'package:eco_swap/view/searchPages/Search_Page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Exchange.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';
import '../home_pages/ExchangeHomePage.dart';
import '../home_pages/RentalHomePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late UserModel currentUser;
  int _selectedIndex = 0;
  Color rentalButtonColor = Colors.blue.withOpacity(0.2);
  Color exchangeButtonColor = Colors.transparent;
  bool obscurePassword = true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Rental> _rentals = [];

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    userViewModel.getUser().then((value) {
      currentUser = value!;
      loadMoreData(currentUser);
    });
    _handleLocationPermission().then((bool hasPermission) {
      userViewModel.updatePosition(hasPermission);
    });
    _selectedIndex = 0;
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      loadMoreData(currentUser);
    } else {}
  }

  Future<void> loadMoreData(UserModel user) async {
    setState(() {
      _isLoading = true;
    });
    List<Rental> rentals = await adViewModel.getRentalsInRadius(
        user.latitude, user.longitude, 30, _rentals.length);
    _rentals.addAll(rentals);
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 50.0),
        Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onEditingComplete: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          search: _searchController.text,
                          currentUser: currentUser,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                    rentalButtonColor = Colors.blue.withOpacity(0.2);
                    exchangeButtonColor = Colors.transparent;
                  });
                },
                child: Text(
                  'Rental',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                          (states) => rentalButtonColor),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                    exchangeButtonColor = Colors.blue.withOpacity(0.2);
                    rentalButtonColor = Colors.transparent;
                  });
                },
                child: Text(
                  'Exchange',
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                          (states) => exchangeButtonColor),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Expanded( // Utilizzo di Expanded per far espandere il Container
          child: Container(
            child: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                GridView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _rentals.length + (_isLoading ? 1 : 0),
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
                ),
              ],
            ),
          ),
        ),
      ],
    );
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