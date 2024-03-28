import 'package:eco_swap/view/main_pages/HomePage.dart';
import 'package:eco_swap/view/main_pages/LoginPage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoggedIn = false; // Variabile di stato per tracciare lo stato dell'accesso

  @override
  Widget build(BuildContext context) {
    Widget selectedPage; // Widget selezionato da visualizzare

    if (isLoggedIn) {
      // Se l'utente è loggato, visualizza HomePage
      selectedPage = HomePage(logoutCallback: _logout);
    } else {
      // Se l'utente non è loggato, visualizza LoginPage
      selectedPage = LoginPage(loginCallback: _login);
    }

    return selectedPage; // Restituisce il widget selezionato in base allo stato dell'accesso
  }

  void _login() {
    setState(() {
      isLoggedIn = true; // Imposta isLoggedIn su true quando l'utente effettua l'accesso
    });
  }

  void _logout() {
    setState(() {
      isLoggedIn = false; // Imposta isLoggedIn su false quando l'utente esegue il logout
    });
  }
}
