import 'package:eco_swap/widget/ListViewProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Exchange.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;

  late List<Exchange> prova;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    initializeViewModels();
    initializeData();
  }

  void initializeViewModels() {
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
  }

  Future<void> initializeData() async {
    bool hasPermission = await _handleLocationPermission();
    userViewModel.updatePosition(hasPermission);
    prova = await adViewModel.getLocalExchange('vft6w5NMVVft0ivqB9z4s3t0hPT2');
    setState(() {});
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
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
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: prova.length,
      itemBuilder: (context, index) {
        final itemData = prova[index];
        return ListViewProfilePage(
          title: itemData.title,
          description: itemData.description,
        );
      },
    );
  }
}