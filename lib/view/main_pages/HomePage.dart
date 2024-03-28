import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback logoutCallback;

  const HomePage({Key? key, required this.logoutCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: logoutCallback,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to Home Page'),
      ),
    );
  }
}