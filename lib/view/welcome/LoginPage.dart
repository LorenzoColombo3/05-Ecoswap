import 'package:flutter/material.dart';

import 'RegistrationPage.dart';


class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;
  @override
  _LoginPageState createState() => _LoginPageState();
  const LoginPage({Key? key, required this.loginCallback}) : super(key: key);
}
class _LoginPageState extends State<LoginPage>{
  bool obscurePassword = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/image/login_image.jpeg',
                  width: 200,
                  height: 200,
                ),
              ),
              Padding(
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
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
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
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Logica per il login
                  },
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Logica per la password dimenticata
                },
                child: Text('Password dimenticata?'),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlinedButton(
                  onPressed: () {
                    // Logica per l'accesso con Google
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/image/google_logo.webp', height: 20.0),
                      SizedBox(width: 10.0),
                      Text('Accedi con Google'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Non hai un account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()));
                    },
                    child: Text('Registrati'),
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