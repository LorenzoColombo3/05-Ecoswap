import 'package:eco_swap/widget/ModalBottomSheet.dart';
import 'package:flutter/material.dart';

import '../load_pages/LoadExchangePage.dart';
import '../load_pages/LoadRentalPage.dart';

class LoadAdPage extends StatefulWidget {
  const LoadAdPage({Key? key}) : super(key: key);

  @override
  State<LoadAdPage> createState() => _LoadAdPageState();
}

class _LoadAdPageState extends State<LoadAdPage> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0; // Imposta _selectedIndex a 0 quando viene premuto il pulsante Rental
                    });
                  },
                  child: const Text('Rental'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1; // Imposta _selectedIndex a 1 quando viene premuto il pulsante Exchange
                    });
                  },
                  child: const Text('Exchange'),
                ),
              ],
            ),
            SizedBox(height: 20),
            IndexedStack(
              index: _selectedIndex,
              children: [
                LoadRentalPage(),
                LoadExchangePage(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
