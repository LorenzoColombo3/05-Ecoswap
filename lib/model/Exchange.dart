

import 'AdModel.dart';

class Exchange extends AdModel{

  Exchange(
      String imagePath,
      String userId,
      String title,
      String description,
      double latitude,
      double longitude,
      String idToken,
      String imageUrl,
      ) : super(imagePath, userId, title, description, latitude, longitude, idToken, imageUrl);



  @override
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'userId': userId,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'idToken': idToken,
      'imageUrl': imageUrl,
    };
  }

  factory Exchange.fromMap(Map<String, dynamic> map) {
    return Exchange(
      map['imagePath'],
      map['userId'],
      map['title'],
      map['description'],
      map['latitude'],
      map['longitude'],
      map['idToken'],
      map['imageUrl'],
    );
  }
}
