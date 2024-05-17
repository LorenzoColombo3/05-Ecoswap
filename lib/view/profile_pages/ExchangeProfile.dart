import 'package:flutter/widgets.dart';
import '../../model/Exchange.dart';
import '../../model/UserModel.dart';

class ExchangeProfile extends StatefulWidget {
 final UserModel currentUser;
 final Exchange exchange;
  const ExchangeProfile({super.key, required this.exchange, required this.currentUser});

  @override
  State<ExchangeProfile> createState() => _ExchangeProfileState();
}

class _ExchangeProfileState extends State<ExchangeProfile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
