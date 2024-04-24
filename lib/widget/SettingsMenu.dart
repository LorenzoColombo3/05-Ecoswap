import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/repository/IUserRepository.dart';
import '../data/viewmodel/UserViewModel.dart';
import '../data/viewmodel/UserViewModelFactory.dart';
import '../util/ServiceLocator.dart';
import '../view/welcome/LoginPage.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

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
        } else if (value == 'settings') {
          // Azione per andare alla pagina dei settaggi
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Text('Settings'),
        ),
      ],
    );
  }
}
