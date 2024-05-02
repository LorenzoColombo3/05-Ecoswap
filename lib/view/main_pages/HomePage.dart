import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
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
  late Future<UserModel?> currentUser;
  int _selectedIndex = 0;
  Color rentalButtonColor = Colors.blue.withOpacity(0.2);
  Color exchangeButtonColor = Colors.transparent;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    currentUser = userViewModel.getUser();
    _handleLocationPermission().then((bool hasPermission) {
      userViewModel.updatePosition(hasPermission);
    });
    _selectedIndex = 0;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50.0), // Padding dall'alto dello schermo
          Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '    Search...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Action to perform when search icon is pressed
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
          ),
          // Spazio tra la barra di ricerca e i pulsanti
          Expanded(
            child: FutureBuilder<UserModel?>(
              future: currentUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text('Error loading user data'),
                  );
                }
                UserModel user = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                  children: [
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
                              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => rentalButtonColor),
                              side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.black, width: 1.0)),
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
                              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => exchangeButtonColor),
                              side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.black, width: 1.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0), // Spazio tra i pulsanti e l'IndexedStack
                    IndexedStack(
                      index: _selectedIndex,
                      children: <Widget>[
                        RentalHomePage(currentUser: user),
                        ExchangeHomePage(currentUser: user),
                      ],
                    ),
                  ],
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
