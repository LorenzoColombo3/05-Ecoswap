import 'package:flutter/widgets.dart';
import '../../model/RentalOrder.dart';
import '../../model/UserModel.dart';

class SoldRentalProfile extends StatefulWidget {
  final UserModel currentUser;
  final RentalOrder order;
  const SoldRentalProfile({super.key, required this.currentUser, required this.order});

  @override
  State<SoldRentalProfile> createState() => _SoldRentalProfileState();
}

class _SoldRentalProfileState extends State<SoldRentalProfile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
