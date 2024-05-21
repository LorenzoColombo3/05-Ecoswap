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
  Color rentalButtonColor = Color(0xFF7BFF81);
  Color exchangeButtonColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme= Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text(''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
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
                        rentalButtonColor = Theme.of(context).colorScheme.background;
                        exchangeButtonColor = Colors.transparent;
                      });
                    },
                    child: Text(
                      'Rental',
                      style: TextStyle(color: _selectedIndex == 0 ? Colors.black : colorScheme.onPrimary),
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
                        exchangeButtonColor = Theme.of(context).colorScheme.background;
                        rentalButtonColor = Colors.transparent;
                      });
                    },
                    child: Text(
                      'Exchange',
                      style: TextStyle(color: _selectedIndex == 1 ? Colors.black : colorScheme.onPrimary),
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
