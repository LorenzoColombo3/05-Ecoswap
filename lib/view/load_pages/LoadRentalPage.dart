import 'dart:io';

import 'package:flutter/material.dart';

import '../../widget/ImagePickerButton.dart';

class LoadRentalPage extends StatefulWidget {
  @override
  _LoadRentalState createState() => _LoadRentalState();
}

class _LoadRentalState extends State<LoadRentalPage> {
  TextEditingController _imageInputController = TextEditingController();
  TextEditingController _textInputController1 = TextEditingController();
  TextEditingController _textInputController2 = TextEditingController();
  TextEditingController _textInputController3 = TextEditingController();
  TextEditingController _textInputController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Load new rental'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImagePickerButton(
              onImageSelected: (File imageFile) {

              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textInputController1,
              decoration: InputDecoration(
                labelText: 'Testo 1',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textInputController2,
              decoration: InputDecoration(
                labelText: 'Testo 2',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textInputController3,
              decoration: InputDecoration(
                labelText: 'Testo 3',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textInputController4,
              decoration: InputDecoration(
                labelText: 'Testo 4',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Azione da eseguire quando viene premuto il pulsante
              },
              child: Text('Invia'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageInputController.dispose();
    _textInputController1.dispose();
    _textInputController2.dispose();
    _textInputController3.dispose();
    _textInputController4.dispose();
    super.dispose();
  }
}
