import 'package:flutter/material.dart';

import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../util/ServiceLocator.dart';
import '../main_pages/NavigationPage.dart';
import 'RegistrationPage.dart';
import 'RegistryPage.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;
  @override
  _LoginPageState createState() => _LoginPageState();
  const LoginPage({Key? key, required this.loginCallback}) : super(key: key);
}
class _LoginPageState extends State<LoginPage>{
  bool obscurePassword = true;
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/image/login_image.jpeg',
                  width: 200,
                  height: 200,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Login:',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
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
                  onPressed: () {
                    userViewModel.login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ).then((message) {
                      if (message!.contains('Success')) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => NavigationPage(logoutCallback: () {},)));
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message),),
                      );
                    });
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Logica per la password dimenticata
                },
                child: const Text('Forgot password?'),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlinedButton(
                  onPressed: () {
                    userViewModel.signInWithGoogle().then((value) {
                      if (value!.contains('Nuovo')) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegistryPage()));
                      }
                      if(value!.contains('Accesso')){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                NavigationPage(logoutCallback: () {},)));
                      }
                    });

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/google_logo.webp', height: 20.0),
                      const SizedBox(width: 10.0),
                      const Text('Accedi con Google'),
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
                    child: const Text('Registrati'),
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