import 'package:eco_swap/view/welcome/ForgotPasswordPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../util/ServiceLocator.dart';
import '../main_pages/NavigationPage.dart';
import 'RegistrationPage.dart';
import 'RegistryPage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  const LoginPage({Key? key,}) : super(key: key);
}
class _LoginPageState extends State<LoginPage>{
  bool obscurePassword = true;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/image/img.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Login:',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  key: const Key('emailField'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  key: const Key('passwordField'),
                  controller: _passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  key: Key('passwordField'),
                  onPressed: () {
                    userViewModel.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ).then((message) {
                      if (message!.contains('Success')) {
                        userViewModel.getUser().then((user) => adViewModel.loadFromFirebaseToLocal(user!.idToken));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NavigationPage(logoutCallback: () {
                            userViewModel.deleteCredential();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                          }),
                        ));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message),),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.background,
                  ),
                  child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    userViewModel.signInWithGoogle().then((value) {
                      if (value!.contains('Nuovo')) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegistryPage()));
                      }
                      if(value!.contains('Accesso')){
                        userViewModel.getUser().then((user) => adViewModel.loadFromFirebaseToLocal(user!.idToken));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => NavigationPage(logoutCallback: () {
                            userViewModel.deleteCredential();
                            userViewModel.signOutFromGoogle();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                          }),
                        ));
                      }
                    });

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.background,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/google_logo.webp', height: 20.0),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Accedi con Google',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Non hai un account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const RegistrationPage()));
                    },
                    child: const Text(
                      'Registrati',
                      style: TextStyle(
                        color: Colors.blue
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}