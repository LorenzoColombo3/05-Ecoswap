abstract class AdModel{
  String _imagePath;
  String _userId;
  String _title;
  String _description;
  double _latitude;
  double _longitude;
  String _idToken;
  String _imageUrl;

  AdModel(
      this._imagePath,
      this._userId,
      this._title,
      this._description,
      this._latitude,
      this._longitude,
      this._idToken,
      this._imageUrl,
      );

  String get imagePath => _imagePath;
  set imagePath(String value) => _imagePath = value;

  String get userId => _userId;
  set userId(String value) => _userId = value;

  String get title => _title;
  set title(String value) => _title = value;

  String get description => _description;
  set description(String value) => _description = value;

  double get latitude => _latitude;
  set latitude(double value) => _latitude = value;

  double get longitude => _longitude;
  set longitude(double value) => _longitude = value;

  String get idToken => _idToken;
  set idToken(String value) => _idToken = value;

  String get imageUrl => _imageUrl;
  set imageUrl(String value) => _imageUrl = value;

  Map<String, dynamic> toMap();

}