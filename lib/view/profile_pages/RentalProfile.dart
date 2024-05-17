import 'package:flutter/widgets.dart';
import '../../model/Rental.dart';
import '../../model/UserModel.dart';

class RentalProfile extends StatefulWidget {
  final UserModel currentUser;
  final Rental rental;
  const RentalProfile({super.key, required this.currentUser, required this.rental});

  @override
  State<RentalProfile> createState() => _RentalProfileState();
}

class _RentalProfileState extends State<RentalProfile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
