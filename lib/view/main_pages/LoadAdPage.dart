import 'package:flutter/material.dart';

import '../load_pages/LoadExchangePage.dart';
import '../load_pages/LoadRentalPage.dart';
import 'NavigationPage.dart';
import 'ProfilePage.dart';

class LoadAdPage extends StatefulWidget {
  const LoadAdPage({Key? key}) : super(key: key);

  @override
  State<LoadAdPage> createState() => _LoadAdPageState();
}

class _LoadAdPageState extends State<LoadAdPage> {
  late int _selectedIndex;
  Color rentalButtonColor = Colors.blue.withOpacity(0.2);
  Color exchangeButtonColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                        rentalButtonColor = Colors.blue.withOpacity(0.2);
                        exchangeButtonColor = Colors.transparent;
                      });
                    },
                    child: Text(
                      'Rental',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => rentalButtonColor),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1;
                        exchangeButtonColor = Colors.blue.withOpacity(0.2);
                        rentalButtonColor = Colors.transparent;
                      });
                    },
                    child: Text(
                      'Exchange',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => exchangeButtonColor),
                    ),
                  ),
                ),
              ],
            ),
            IndexedStack(
              index: _selectedIndex,
              children: <Widget> [
                LoadRentalPage(
                  onButtonPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => NavigationPage(logoutCallback: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ));
                      }),
                    ));
                  },
                ),
                LoadExchangePage(
                  onButtonPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => NavigationPage(logoutCallback: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ));
                      }),
                    ));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
