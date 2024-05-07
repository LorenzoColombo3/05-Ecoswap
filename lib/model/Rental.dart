

import 'AdModel.dart';

class Rental extends AdModel {
  String _dailyCost;
  String _maxDaysRent;
  String _unitNumber;
  String _unitRented;

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
      this._unitNumber,
      this._unitRented,
      ) : super(imagePath, userId, title, description, lat, long, idToken, imageUrl, position, dateLoad);



  String get dailyCost => _dailyCost;
  set dailyCost(String value) => _dailyCost = value;

  String get maxDaysRent => _maxDaysRent;
  set maxDaysRent(String value) => _maxDaysRent = value;

  String get unitNumber => _unitNumber;
  set unitNumber(String value) => _unitNumber = value;

  String get unitRented => _unitRented;
  set unitRented(String value) => _unitRented = value;

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
      'unitNumber' : _unitNumber,
      'unitRented' : _unitRented,
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
        map['unitNumber'],
        map['unitRented'],
    );
  }
}
