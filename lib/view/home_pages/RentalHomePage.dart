import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class RentalHomePage extends StatefulWidget {
  final UserModel currentUser;

  const RentalHomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<RentalHomePage> createState() => _RentalHomePageState();
}

class _RentalHomePageState extends State<RentalHomePage> {
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Rental> _rentals = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    _loadMoreData(index);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadMoreData(int index) async {
    setState(() {
      _isLoading = true;
    });
    List<Rental> additionalData = await adViewModel.getRentalsInRadius(
        widget.currentUser.latitude, widget.currentUser.longitude, 30, index);
    setState(() {
      _rentals.addAll(additionalData);
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData(_rentals.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        controller: _scrollController,
        itemCount: _rentals.length + (_isLoading ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          print("");
          if (index < _rentals.length) {
            return _buildRentalItem(_rentals[index]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  /* @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }*/
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildRentalItem(Rental rental) {
    return Container(
      padding: EdgeInsets.all(16.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rental.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          // Inserire qui l'immagine
          Image.network(
            rental.imageUrl!, // URL dell'immagine
            width: 100, // Larghezza dell'immagine
            height: 100, // Altezza dell'immagine
            fit: BoxFit.cover, // Modalità di adattamento dell'immagine
          ),
          SizedBox(height: 8),
          Text(
            rental.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }
}


