
import 'package:flutter/material.dart';

import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class LeaveReviewPage extends StatefulWidget {
  UserModel currentUser,sellerUser;
  LeaveReviewPage({super.key,required this.currentUser, required this.sellerUser});

  @override
  State<LeaveReviewPage> createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  TextEditingController _reviewController = TextEditingController();
  int _rating = 0;

late IUserRepository userRepository;
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text("Leave a Review"),
        backgroundColor: colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Leave a review for ${widget.sellerUser.name}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(widget.sellerUser.imageUrl),
              radius: 50.0,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 40.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                userViewModel.saveReview(widget.sellerUser.idToken, _reviewController.text, _rating);
                Navigator.pop(context);
              },
              child: Text("Submit Review"),
            ),
          ],
        ),
      ),
    );
  }
}
