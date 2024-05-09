import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
      ), // Aggiungi un'app bar se necessario
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Chiudi la schermata quando l'utente tocca l'immagine
          },
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
