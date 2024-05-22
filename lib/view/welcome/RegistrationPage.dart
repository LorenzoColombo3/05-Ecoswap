import 'package:eco_swap/data/repository/IUserRepository.dart';
import 'package:eco_swap/data/viewmodel/UserViewModel.dart';
import 'package:eco_swap/data/viewmodel/UserViewModelFactory.dart';
import 'package:eco_swap/util/ServiceLocator.dart';
import 'package:eco_swap/view/main_pages/NavigationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RegistryPage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key,});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar:AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body:   
        SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 200,
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
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Sign in:',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller:_emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon:  Icon(Icons.mail),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller:_passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
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
                      userViewModel.registration(
                        email: _emailController.text,
                        password: _passwordController.text,
                      ).then((message) {
                        if (message!.contains('Success')) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const RegistryPage()));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message),),
                          );
                        }
                      });
          
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(colorScheme.background),
                    ),
                    child: const Text(
                      'Create Account',
                      style:TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
        ),
    );
  }
}
