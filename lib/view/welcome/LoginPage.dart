import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback loginCallback;

  const LoginPage({Key? key, required this.loginCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: loginCallback,
        child: Text('Login'),
      ),
    );
  }
}