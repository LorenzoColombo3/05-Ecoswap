import 'package:eco_swap/view/profile_pages/FinishedRentals.dart';
import 'package:eco_swap/view/profile_pages/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/repository/IUserRepository.dart';
import '../data/viewmodel/UserViewModel.dart';
import '../data/viewmodel/UserViewModelFactory.dart';
import '../model/UserModel.dart';
import '../util/ServiceLocator.dart';
import '../view/welcome/LoginPage.dart';

class SettingsMenu extends StatefulWidget {
  final VoidCallback callback;
  final UserModel currentUser;

  const SettingsMenu(
      {super.key, required this.callback, required this.currentUser});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'logout') {
          userViewModel.deleteCredential();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
        }
        if (value == 'settings') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage(
                        currentUser: widget.currentUser,
                      ))).then((value) => widget.callback);
        }
        if (value == 'finished') {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FinishedRentals(currentUser: widget.currentUser)))
              .then((value) => widget.callback);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Text('Settings', style: TextStyle(color: Colors.black)),
        ),
        const PopupMenuItem(
          value: 'finished',
          child: Text('Past orders', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
