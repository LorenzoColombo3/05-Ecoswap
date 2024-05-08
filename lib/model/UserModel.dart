class UserModel {
  String? _imagePath;
  String _idToken;
  String _name;
  String _lastName;
  String _email;
  double _latitude;
  double _longitude;
  String _dateField;
  String _phoneNumber;
  String? _imageUrl;
  List<String> _activeRentalsBuy;
  List<String> _finishedRentalsBuy;
  List<String> _activeRentalsSell;
  List<String> _finishedRentalsSell;

  // Costruttore della classe
  UserModel({
    required String idToken,
    required String name,
    required String lastName,
    required String? email,
    required double latitude,
    required double longitude,
    required String birthDate,
    required String phoneNumber,
    imageUrl,
    imagePath,
  })  : _idToken = idToken,
        _name = name,
        _lastName = lastName,
        _email = email!,
        _latitude = latitude,
        _longitude = longitude,
        _dateField = birthDate,
        _phoneNumber = phoneNumber,
        _imageUrl = imageUrl,
        _imagePath = imagePath;

  // Getter per idToken
  String get idToken => _idToken;

  // Setter per imagePath
  set imagePath(String? value) {
    _imagePath = value;
  }

  // Setter per imageUrl
  set imageUrl(String? value) {
    _imageUrl = value;
  }

  // Getter per name
  String get name => _name;

  // Setter per name
  set name(String value) {
    _name = value;
  }

  // Getter per lastName
  String get lastName => _lastName;

  // Setter per lastName
  set lastName(String value) {
    _lastName = value;
  }

  // Getter per email
  String get email => _email;

  // Setter per email
  set email(String value) {
    _email = value;
  }

  // Getter per latitude
  double get latitude => _latitude;

  // Setter per latitude
  set latitude(double value) {
    _latitude = value;
  }

  // Getter per longitude
  double get longitude => _longitude;

  // Setter per longitude
  set longitude(double value) {
    _longitude = value;
  }

  // Getter per dateField
  String get birthdate => _dateField;

  // Setter per dateField
  set birthdate(String value) {
    birthdate = value;
  }

  // Getter per phoneNumber
  String get phoneNumber => _phoneNumber;

  // Setter per phoneNumber
  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String? get imageUrl => _imageUrl;

  String? get imagePath => _imagePath;

  // Metodo per convertire l'oggetto UserModel in una mappa
  Map<String, dynamic> toMap() {
    return {
      'idToken': _idToken,
      'name': _name,
      'lastName': _lastName,
      'email': _email,
      'latitude': _latitude,
      'longitude': _longitude,
      'birthdate': _dateField,
      'phoneNumber': _phoneNumber,
      'imageUrl': _imageUrl,
      'imagePath': _imagePath,
    };
  }

  // Metodo factory per creare un oggetto UserModel da una mappa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idToken: map['idToken'],
      name: map['name'],
      lastName: map['lastName'],
      email: map['email'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      birthDate: map['birthdate'],
      phoneNumber: map['phoneNumber'],
      imagePath: map['imagePath'],
      imageUrl: map['imageUrl'],
    );
  }
}
