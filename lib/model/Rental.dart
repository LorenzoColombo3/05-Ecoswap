import 'package:eco_swap/model/AdInterface.dart';

class Rental implements AdInterface {
  String _pathImage;
  String _userId;
  String _title;
  String _description;
  int _dailyCost;
  int _maxDaysRent;

  Rental(this._pathImage, this._userId, this._title, this._description, this._dailyCost, this._maxDaysRent);

  String get pathImage => _pathImage;
  set pathImage(String value) => _pathImage = value;

  String get userId => _userId;
  set userId(String value) => _userId = value;

  String get title => _title;
  set title(String value) => _title = value;

  String get description => _description;
  set description(String value) => _description = value;

  int get dailyCost => _dailyCost;
  set dailyCost(int value) => _dailyCost = value;

  int get maxDaysRent => _maxDaysRent;
  set maxDaysRent(int value) => _maxDaysRent = value;
}
