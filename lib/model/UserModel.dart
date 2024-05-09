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
  List<String>? _activeRentalsBuy;
  List<String>? _finishedRentalsBuy;
  List<String>? _activeRentalsSell;
  List<String>? _finishedRentalsSell;
  List<String>? _expiredExchange;

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
    activeRentalsBuy,
    finishedRentalBuy,
    activeRentalsSell,
    finishedRentalsSell,
    expiredExchange,
  })  : _idToken = idToken,
        _name = name,
        _lastName = lastName,
        _email = email!,
        _latitude = latitude,
        _longitude = longitude,
        _dateField = birthDate,
        _phoneNumber = phoneNumber,
        _imageUrl = imageUrl,
        _imagePath = imagePath,
        _activeRentalsBuy = activeRentalsBuy,
        _finishedRentalsBuy = finishedRentalBuy,
        _activeRentalsSell = activeRentalsSell,
        _finishedRentalsSell = finishedRentalsSell,
        _expiredExchange = expiredExchange;

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
  // Getter per _activeRentalsBuy
  List<String> get activeRentalsBuy => _activeRentalsBuy!;

  // Setter per _activeRentalsBuy
  set activeRentalsBuy(List<String> value) {
    _activeRentalsBuy = value;
  }

  // Getter per _finishedRentalsBuy
  List<String> get finishedRentalsBuy => _finishedRentalsBuy!;

  // Setter per _finishedRentalsBuy
  set finishedRentalsBuy(List<String> value) {
    _finishedRentalsBuy = value;
  }

  // Getter per _activeRentalsSell
  List<String> get activeRentalsSell => _activeRentalsSell!;

  // Setter per _activeRentalsSell
  set activeRentalsSell(List<String> value) {
    _activeRentalsSell = value;
  }

  // Getter per _finishedRentalsSell
  List<String> get finishedRentalsSell => _finishedRentalsSell!;

  // Setter per _finishedRentalsSell
  set finishedRentalsSell(List<String> value) {
    _finishedRentalsSell = value;
  }

  // Getter per _expiredExchange
  List<String> get expiredExchange => _expiredExchange!;

  // Setter per _expiredExchange
  set expiredExchange(List<String> value) {
    _expiredExchange = value;
  }

  // Metodo per aggiungere un elemento a _activeRentalsBuy
  void addToActiveRentalsBuy(String item) {
    _activeRentalsBuy?.add(item);
  }

  // Metodo per rimuovere un elemento da _activeRentalsBuy
  void removeFromActiveRentalsBuy(String item) {
    _activeRentalsBuy?.remove(item);
  }

  // Metodo per aggiungere un elemento a _finishedRentalsBuy
  void addToFinishedRentalsBuy(String item) {
    _finishedRentalsBuy?.add(item);
  }

  // Metodo per rimuovere un elemento da _finishedRentalsBuy
  void removeFromFinishedRentalsBuy(String item) {
    _finishedRentalsBuy?.remove(item);
  }

  // Metodo per aggiungere un elemento a _activeRentalsSell
  void addToActiveRentalsSell(String item) {
    _activeRentalsSell?.add(item);
  }

  // Metodo per rimuovere un elemento da _activeRentalsSell
  void removeFromActiveRentalsSell(String item) {
    _activeRentalsSell?.remove(item);
  }

  // Metodo per aggiungere un elemento a _finishedRentalsSell
  void addToFinishedRentalsSell(String item) {
    _finishedRentalsSell?.add(item);
  }

  // Metodo per rimuovere un elemento da _finishedRentalsSell
  void removeFromFinishedRentalsSell(String item) {
    _finishedRentalsSell?.remove(item);
  }

  // Metodo per aggiungere un elemento a _expiredExchange
  void addToExpiredExchange(String item) {
    _expiredExchange?.add(item);
  }

  // Metodo per rimuovere un elemento da _expiredExchange
  void removeFromExpiredExchange(String item) {
    _expiredExchange?.remove(item);
  }


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
      'activeRentalsSell' : _activeRentalsSell,
      'activeRentalsBuy' : _activeRentalsBuy,
      'finishedRentalsSell' : _finishedRentalsBuy,
      'finishedRentalsBuy' : _finishedRentalsBuy,
      'expiredExchange' : _expiredExchange,

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
      activeRentalsSell: map['activeRentalsSell'],
      activeRentalsBuy: map['activeRentalsBuy'],
      finishedRentalsSell: map['finishedRentalsSell'],
      finishedRentalBuy: map['finishedRentalsBuy'],
      expiredExchange: map['expiredExchange'],
    );
  }
}
