import 'package:eco_swap/data/source/UserAuthDataSource.dart';
import 'package:eco_swap/util/AppTheme.dart';
import 'package:eco_swap/util/ServiceLocator.dart';
import 'package:flutter/material.dart';
import 'package:eco_swap/view/main_pages/NavigationPage.dart';
import 'package:eco_swap/view/welcome/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repository/IUserRepository.dart';
import 'data/viewmodel/UserViewModel.dart';
import 'data/viewmodel/UserViewModelFactory.dart';
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

class _MyAppState extends State<MyApp> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    checkCredentials();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    WidgetsFlutterBinding.ensureInitialized();
    userViewModel.setupFirebaseListener();
  }

  Future<bool> checkCredentials() async {
    final userViewModel = UserViewModelFactory(ServiceLocator().getUserRepository()).create();
    final password = await userViewModel.readPassword();
    final email = await userViewModel.readEmail();
    if (password != null && email != null) {
      final message = await userViewModel.login(email: email, password: password);
      if (message!.contains('Success')) {
        return true;
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: FutureBuilder(
        future: checkCredentials(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/image/logoApp.png', // Percorso dell'immagine asset
                        width: 100, // Larghezza dell'immagine
                        height: 100, // Altezza dell'immagine
                        fit: BoxFit.contain,
                      ),
                                  ),
                  ),
                ),
            );
          } else {
            if (snapshot.data == true) {
              return NavigationPage(logoutCallback: () {
                userViewModel.deleteCredential();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              });
            } else {
              return const LoginPage();
            }
          }
        },
      ),
    );
  }


}
