import 'package:eco_swap/model/UserModel.dart';
import 'package:flutter/material.dart';

import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/ReviewModel.dart';
import '../../util/ServiceLocator.dart';

class ReviewsPage extends StatefulWidget {
  UserModel currentUser ;
  ReviewsPage({super.key, required this.currentUser});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;

  List<Review> getAllReviews(Map<dynamic, dynamic> reviewsMap) {
    List<Review> reviews = [];

    reviewsMap.forEach((key, value) {
      Review review = Review.fromMap(value as Map<String, dynamic>);
      reviews.add(review);
    });

    return reviews;
  }

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = UserViewModelFactory(userRepository).create();
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    List<Review> reviews = getAllReviews(widget.currentUser.reviews);
    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: colorScheme.background,
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ListTile(
            onTap: () {
            },
            title: Text(review.userIdToken),
            subtitle: Text(review.text),
          );
        },
      ),
    );
  }

}
