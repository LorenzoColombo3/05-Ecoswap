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
  @override
  Widget build(BuildContext context) {
    Widget homePage;
    homePage = const LoginPage();
    homePage= MaterialApp(
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

    return homePage;
  }
}

