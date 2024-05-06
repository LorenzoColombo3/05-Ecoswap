

import 'AdModel.dart';

class Rental extends AdModel {
  String _dailyCost;
  String _maxDaysRent;


  Rental(
      String imagePath,
      String userId,
      String title,
      String description,
      double lat,
      double long,
      this._dailyCost, this._maxDaysRent,
      String idToken,
      String imageUrl,
      String position,
      String dateLoad,
      ) : super(imagePath, userId, title, description, lat, long, idToken, imageUrl, position, dateLoad);



  String get dailyCost => _dailyCost;
  set dailyCost(String value) => _dailyCost = value;

  String get maxDaysRent => _maxDaysRent;
  set maxDaysRent(String value) => _maxDaysRent = value;

  @override
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'userId': userId,
      'title': title,
      'description': description,
      'lat': latitude,
      'long': longitude,
      'dailyCost': _dailyCost,
      'maxDaysRent': _maxDaysRent,
      'idToken': idToken,
      'imageUrl' : imageUrl,
      'position' : position,
      'dateLoad' : dateLoad,
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
        map['imagePath'],
        map['userId'],
        map['title'],
        map['description'],
        map['lat'],
        map['long'],
        map['dailyCost'],
        map['maxDaysRent'],
        map['idToken'],
        map['imageUrl'],
        map['position'],
        map['dateLoad'],
    );
  }
}
