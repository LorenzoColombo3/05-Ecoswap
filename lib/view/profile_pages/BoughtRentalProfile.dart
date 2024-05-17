import 'package:flutter/widgets.dart';
import '../../model/RentalOrder.dart';
import '../../model/UserModel.dart';

class BoughtRentalProfile extends StatefulWidget {
  final UserModel currentUser;
  final RentalOrder order;
  const BoughtRentalProfile({super.key, required this.currentUser, required this.order});

  @override
  State<BoughtRentalProfile> createState() => _BoughtRentalProfileState();
}

class _BoughtRentalProfileState extends State<BoughtRentalProfile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
