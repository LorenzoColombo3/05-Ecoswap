import 'dart:ffi';

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

  List<Widget> _buildStarRating(int numberOfStars) {
    List<Widget> starWidgets = [];
    for (int i = 1; i <= 5; i++) {
      IconData iconData = numberOfStars >= i ? Icons.star : Icons.star_border;
      Color starColor = numberOfStars >= i ? Colors.yellow : Colors.grey;
      starWidgets.add(
        Icon(
          iconData,
          color: starColor,
        ),
      );
    }
    return starWidgets;
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
          return FutureBuilder <UserModel?>(
            future: userViewModel.getUserData(review.userIdToken),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListTile(
                  onTap: () {
                    //logica per andare alla pagina dello stronzo che ha lasciato una brutta review
                  },
                  title: Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/image/loading_indicator.gif'),
                            image: NetworkImage(snapshot.data!.imageUrl),
                            fit: BoxFit.cover,
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Spazio tra l'immagine del profilo e il testo

                      Column(
                        children: [
                          Text(
                            snapshot.data!.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: _buildStarRating(review.getStars()),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5), // Spazio tra le stelle e il testo della recensione
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          review.getText(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          );
        },
      ),
    );
  }

}
