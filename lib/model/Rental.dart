import 'package:eco_swap/model/AdInterface.dart';

class Rental implements AdInterface {
  String _imagePath;
  String _userId;
  String _title;
  String _description;
  double _lat;
  double _long;
  String _dailyCost;
  String _maxDaysRent;
  String _idToken;
  String _imageUrl;

  Rental(this._imagePath, this._userId, this._title, this._description,
      this._lat, this._long, this._dailyCost, this._maxDaysRent, this._idToken,
      this._imageUrl);

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get imagePath => _imagePath;
  set imagePath(String value) => _imagePath = value;

  String get idToken => _idToken;
  set idToken(String value) {
    _idToken = value;
  }

  String get userId => _userId;
  set userId(String value) => _userId = value;

  String get title => _title;
  set title(String value) => _title = value;

  String get description => _description;
  set description(String value) => _description = value;

  double get lat => _lat;
  set lat(double value) => _lat = value;

  double get long => _long;
  set long(double value) => _long = value;

  String get dailyCost => _dailyCost;
  set dailyCost(String value) => _dailyCost = value;

  String get maxDaysRent => _maxDaysRent;
  set maxDaysRent(String value) => _maxDaysRent = value;

  Map<String, dynamic> toMap() {
    return {
      'imagePath': _imagePath,
      'userId': _userId,
      'title': _title,
      'description': _description,
      'lat': _lat,
      'long': _long,
      'dailyCost': _dailyCost,
      'maxDaysRent': _maxDaysRent,
      'idToken': _idToken,
      'imageUrl' : _imageUrl,
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
    );
  }
}
