import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widget/ImagePickerButton.dart';
import '../../widget/MapWidget.dart';

class LoadRentalPage extends StatefulWidget {
  @override
  _LoadRentalState createState() => _LoadRentalState();
}

class _LoadRentalState extends State<LoadRentalPage> {
  TextEditingController _titleInputController = TextEditingController();
  TextEditingController _descriptionInputController = TextEditingController();
  TextEditingController _dailyCostInputController = TextEditingController();
  TextEditingController _maxDaysInputController = TextEditingController();
  //RentalDataSource testFirebase = RentalDataSource();
  LatLng _selectedPosition = LatLng(0, 0); // Posizione iniziale

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
                print(imageFile.path);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _titleInputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: false,
                labelText: 'Title',
                hintText: 'Title',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              minLines: 4,
              maxLines: null,
              maxLength: 5000,
              controller: _descriptionInputController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Description',
                filled: false,
                labelText: 'Description',
                fillColor: Colors.white.withOpacity(0.7),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _dailyCostInputController,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: false,
                hintText: 'DailyCost',
                labelText: 'Daily cost',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _maxDaysInputController,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: false,
                hintText: 'Max days rent',
                labelText: 'Max days rent',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 24.0),
            SizedBox(
              height: 300, // Altezza desiderata
              child: MapWidget(
                onPositionChanged: (LatLng position) {
                  setState(() {
                    _selectedPosition = position;
                  });
                },
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Azione da eseguire quando viene premuto il pulsante
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleInputController.dispose();
    _descriptionInputController.dispose();
    _dailyCostInputController.dispose();
    _maxDaysInputController.dispose();
    super.dispose();
  }
}
