import 'package:eco_swap/model/AdInterface.dart';

class Rental implements AdInterface {
  String _imagePath;
  String _userId;
  String _title;
  String _description;
  String _position;
  int _dailyCost;
  int _maxDaysRent;
  String _idToken;

  Rental(
      this._imagePath,
      this._userId,
      this._title,
      this._description,
      this._position,
      this._dailyCost,
      this._maxDaysRent,
      this._idToken);

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

  String get position => _position;
  set position(String value) {
    _position = value;
  }

  int get dailyCost => _dailyCost;
  set dailyCost(int value) => _dailyCost = value;

  int get maxDaysRent => _maxDaysRent;
  set maxDaysRent(int value) => _maxDaysRent = value;

  Map<String, dynamic> toMap() {
    return {
      'imagePath': _imagePath,
      'userId': _userId,
      'title': _title,
      'description': _description,
      'position': _position,
      'dailyCost': _dailyCost,
      'maxDaysRent': _maxDaysRent,
      'idToken': _idToken,
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      map['imagePath'],
      map['userId'],
      map['title'],
      map['description'],
      map['position'],
      map['dailyCost'],
      map['maxDaysRent'],
      map['idToken'],
    );
  }
}
