import 'dart:async';
import 'dart:io';
import 'package:eco_swap/data/repository/IAdRepository.dart';
import 'package:uuid/uuid.dart';
import 'package:eco_swap/model/Rental.dart';
import 'package:eco_swap/util/Result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';
import '../../widget/ImagePickerButton.dart';
import '../../widget/MapWidget.dart';

class LoadRentalPage extends StatefulWidget {
  @override
  _LoadRentalState createState() => _LoadRentalState();
}

class _LoadRentalState extends State<LoadRentalPage> {
  TextEditingController _titleInputController = TextEditingController();
  TextEditingController _descriptionInputController = TextEditingController();
  TextEditingController _dailyCostInputController = TextEditingController();
  TextEditingController _maxDaysInputController = TextEditingController();
  late UserModel currentUser;
  late String imagePath;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  LatLng? _selectedPosition;
  late LatLng _currentPosition = LatLng(45.4554, 8.8908); // Impostazione iniziale a una posizione predefinita

  @override
  void initState() {
    super.initState();
    _initializePosition();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    userViewModel.getUser().then((user){
      currentUser = (user as UserResponseSuccess).getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImagePickerButton(
              onImageSelected: (File imageFile) {
               imagePath = imageFile.path;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _titleInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: false,
                labelText: 'Title',
                hintText: 'Title',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              minLines: 4,
              maxLines: null,
              maxLength: 5000,
              controller: _descriptionInputController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Description',
                filled: false,
                labelText: 'Description',
                fillColor: Colors.white.withOpacity(0.7),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _dailyCostInputController,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: false,
                hintText: 'DailyCost',
                labelText: 'Daily cost',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _maxDaysInputController,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: false,
                hintText: 'Max days rent',
                labelText: 'Max days rent',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 24.0),
            SizedBox(
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FutureBuilder<LatLng>(
                    future: getPositionAsLatLng(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return MapWidget(
                          initialPosition: snapshot.data!,
                          onPositionChanged: (LatLng position) {
                            setState(() {
                              _selectedPosition = position;
                            });
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                Rental rental = Rental(imagePath, currentUser.idToken,
                    _titleInputController.value.text,
                    _descriptionInputController.value.text,
                    _selectedPosition!.latitude, _selectedPosition!.longitude,
                    _dailyCostInputController.value.text,
                    _maxDaysInputController.value.text, Uuid().v4());
                adViewModel.loadRental(rental);
              },
              child: Text('Save'),
            ),
          ],
        ),
      );
  }

  @override
  void dispose() {
    _titleInputController.dispose();
    _descriptionInputController.dispose();
    _dailyCostInputController.dispose();
    _maxDaysInputController.dispose();
    super.dispose();
  }

  Future<LatLng> getPositionAsLatLng() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      throw Exception('Failed to get current position: $e');
    }
  }

  void _initializePosition() async {
    try {
      LatLng position = await getPositionAsLatLng();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Failed to initialize position: $e');
    }
  }
}
