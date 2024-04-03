import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30.0),
              child: Image.asset(
                'assets/image/login_image.jpeg',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(
                height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Reset password:',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail),
                ),
              ),
            ),
            const SizedBox(
                height: 20.0), // Aggiunge spazio verticale di 20.0 unità
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  //logica per il reset della pw
                },
                child: const Text('Reset password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
