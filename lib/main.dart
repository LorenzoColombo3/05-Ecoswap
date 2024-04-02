import 'package:flutter/material.dart';
import 'package:eco_swap/view/main_pages/NavigationPage.dart';
import 'package:eco_swap/view/welcome/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  
  bool isLoggedIn = true; // Variabile di stato per tracciare lo stato dell'accesso

  

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

  @override
  Widget build(BuildContext context) {
    Widget homePage;

    // Uso esplicito di if-else per decidere quale pagina mostrare
    if (isLoggedIn) {
      homePage = NavigationPage(logoutCallback: _logout); // Utente loggato
    } else {
      homePage = LoginPage(loginCallback: _login); // Utente non loggato
    }

    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.dark,
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.light,
        ),
      ),
      home: homePage, // Imposta la home page in base allo stato di login
    );
  }
}

