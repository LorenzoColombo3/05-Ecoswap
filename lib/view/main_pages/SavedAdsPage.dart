import 'package:flutter/material.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class SavedAdsPage extends StatefulWidget {
  @override
  _SavedAdsPageState createState() => _SavedAdsPageState();
}

class _SavedAdsPageState extends State<SavedAdsPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late UserModel currentUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    userViewModel.getUser().then((value) {
      currentUser = value!;
    });
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

}