import 'package:flutter/widgets.dart';

import '../../model/UserModel.dart';

class ExchangeHomePage extends StatefulWidget {
  final UserModel currentUser;

  const ExchangeHomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ExchangeHomePage> createState() => _ExchangeHomePageState();
}

class _ExchangeHomePageState extends State<ExchangeHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
