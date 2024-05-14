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
  String _imageUrl;
  List<dynamic>? _publishedRentals;
  List<dynamic>? _publishedExchange;
  List<dynamic>? _activeRentalsBuy;
  List<dynamic>? _finishedRentalsBuy;
  List<dynamic>? _activeRentalsSell;
  List<dynamic>? _finishedRentalsSell;
  List<dynamic>? _expiredExchange;
  List<dynamic>? _favoriteRentals;
  List<dynamic>? _favoriteExchanges;


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
    required imageUrl,
    imagePath,
    publishedRentals,
    publishedExchange,
    activeRentalsBuy,
    finishedRentalBuy,
    activeRentalsSell,
    finishedRentalsSell,
    expiredExchange,
    favoriteRentals,
    favoriteExchanges,
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
        _publishedRentals = publishedRentals,
        _publishedExchange = publishedExchange,
        _activeRentalsBuy = activeRentalsBuy,
        _finishedRentalsBuy = finishedRentalBuy,
        _activeRentalsSell = activeRentalsSell,
        _finishedRentalsSell = finishedRentalsSell,
        _expiredExchange = expiredExchange,
        _favoriteRentals = favoriteRentals,
        _favoriteExchanges = favoriteExchanges;

  // Getter per idToken
  String get idToken => _idToken;

  // Setter per imagePath
  set imagePath(String? value) {
    _imagePath = value;
  }

  // Setter per imageUrl
  set imageUrl(String value) {
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

  String get imageUrl => _imageUrl;

  String? get imagePath => _imagePath;
  // Getter per _activeRentalsBuy
  List<dynamic> get activeRentalsBuy{
    if(_activeRentalsBuy==null) {
      _activeRentalsBuy = [" "];
      return _activeRentalsBuy!;
    }else{
      return _activeRentalsBuy!;
    }
  }

  // Setter per _activeRentalsBuy
  set activeRentalsBuy(List<dynamic> value) {
    _activeRentalsBuy = value;
  }

  // Getter per _finishedRentalsBuy
  List<dynamic> get finishedRentalsBuy{
    if(_finishedRentalsBuy==null) {
      _finishedRentalsBuy = [" "];
      return _finishedRentalsBuy!;
    }else{
      return _finishedRentalsBuy!;
    }
  }

  // Setter per _finishedRentalsBuy
  set finishedRentalsBuy(List<dynamic> value) {
    _finishedRentalsBuy = value;
  }

  // Getter per _activeRentalsSell
  List<dynamic> get activeRentalsSell {
    if(_activeRentalsSell==null) {
      _activeRentalsSell = [" "];
      return _activeRentalsSell!;
    }else{
      return _activeRentalsSell!;
    }
  }

  // Setter per _activeRentalsSell
  set activeRentalsSell(List<dynamic> value) {
    _activeRentalsSell = value;
  }

  // Getter per _finishedRentalsSell
  List<dynamic> get finishedRentalsSell{
    if(_finishedRentalsSell==null) {
      _finishedRentalsSell = [" "];
      return _finishedRentalsSell!;
    }else{
      return _finishedRentalsSell!;
    }
  }
  // Setter per _finishedRentalsSell
  set finishedRentalsSell(List<dynamic> value) {
    _finishedRentalsSell = value;
  }

  List<dynamic> get publishedRentals {
    if(_publishedRentals==null) {
      _publishedRentals = [" "];
      return _publishedRentals!;
    }else{
      return _publishedRentals!;
    }
  }

  // Setter per _activeRentalsSell
  set publishedRentals(List<dynamic> value) {
    _publishedRentals = value;
  }

  List<dynamic> get publishedExchange {
    if(_publishedExchange==null) {
      _publishedExchange = [" "];
      return _publishedExchange!;
    }else{
      return _publishedExchange!;
    }
  }
  // Setter per _activeRentalsSell
  set publishedExchange(List<dynamic> value) {
    _publishedExchange = value;
  }

  // Getter per _expiredExchange
  List<dynamic> get expiredExchange {
    if(_expiredExchange==null) {
      _expiredExchange = [" "];
      return _expiredExchange!;
    }else{
      return _expiredExchange!;
    }
  }

  List<dynamic> get favoriteExchange{
    if(_favoriteExchanges==null) {
      _favoriteExchanges = [" "];
      return _favoriteExchanges!;
    }else{
      return _favoriteExchanges!;
    }
  }

  List<dynamic> get favoriteRentals{
    if(_favoriteRentals==null) {
      _favoriteRentals = [" "];
      return _favoriteRentals!;
    }else{
      return _favoriteRentals!;
    }
  }

  // Setter per _expiredExchange
  set expiredExchange(List<dynamic> value) {
    _expiredExchange = value;
  }

  // Metodo per aggiungere un elemento a _activeRentalsBuy
  void addToActiveRentalsBuy(String item) {
    if(_activeRentalsBuy != null)
       _activeRentalsBuy?.add(item);
    else
      _activeRentalsBuy= [item];
  }

  // Metodo per rimuovere un elemento da _activeRentalsBuy
  void removeFromActiveRentalsBuy(String item) {
    _activeRentalsBuy?.remove(item);
  }

  // Metodo per aggiungere un elemento a _finishedRentalsBuy
  void addToFinishedRentalsBuy(String item) {
    if(_finishedRentalsBuy != null)
      _finishedRentalsBuy?.add(item);
    else
      _finishedRentalsBuy= [item];

  }

  // Metodo per rimuovere un elemento da _finishedRentalsBuy
  void removeFromFinishedRentalsBuy(String item) {
    _finishedRentalsBuy?.remove(item);
  }

  // Metodo per aggiungere un elemento a _activeRentalsSell
  void addToActiveRentalsSell(String item) {
    if(_activeRentalsSell != null)
      _activeRentalsSell?.add(item);
    else
      _activeRentalsSell= [item];
  }

  // Metodo per rimuovere un elemento da _activeRentalsSell
  void removeFromActiveRentalsSell(String item) {
    _activeRentalsSell?.remove(item);
  }

  // Metodo per aggiungere un elemento a _finishedRentalsSell
  void addToFinishedRentalsSell(String item) {
    if(_finishedRentalsSell != null)
      _finishedRentalsSell?.add(item);
    else
      _finishedRentalsSell= [item];
  }

  // Metodo per rimuovere un elemento da _finishedRentalsSell
  void removeFromFinishedRentalsSell(String item) {
    _finishedRentalsSell?.remove(item);
  }

  // Metodo per aggiungere un elemento a _expiredExchange
  void addToExpiredExchange(String item) {
    if(_expiredExchange != null)
      _expiredExchange?.add(item);
    else
      _expiredExchange= [item];
  }

  // Metodo per rimuovere un elemento da _expiredExchange
  void removeFromExpiredExchange(String item) {
    _expiredExchange?.remove(item);
  }

  void addToFavoriteRentals(String item) {
    if(_favoriteRentals != null)
      _favoriteRentals?.add(item);
    else
      _favoriteRentals= [item];
  }

  void removeFromFavoriteRentals(String item) {
    _favoriteRentals?.remove(item);
  }

  void addToFavoriteExchange(String item) {
    if(_favoriteExchanges != null)
      _favoriteExchanges?.add(item);
    else
      _favoriteExchanges= [item];
  }

  void removeFromFavoriteExchange(String item) {
    _favoriteExchanges?.remove(item);
  }

  void addToActivePublishedRentals(String item) {
    if(_publishedRentals != null)
      _publishedRentals?.add(item);
    else
      _publishedRentals= [item];
  }

  // Metodo per rimuovere un elemento da _activeRentalsBuy
  void removeFromActivePublishedRentals(String item) {
    _publishedRentals?.remove(item);
  }

  void addToActivePublishedExchanges(String item) {
    if(_publishedExchange != null)
      _publishedExchange?.add(item);
    else
      _publishedExchange= [item];
  }

  // Metodo per rimuovere un elemento da _activeRentalsBuy
  void removeFromActivePublishedExchanges(String item) {
    _publishedExchange?.remove(item);
  }

  // Metodo per convertire l'oggetto UserModel in una mappa
  Map<String, dynamic> toMap() {
    return {
      'idToken' : idToken,
      'username': _name,
      'lastName': _lastName,
      'email': _email,
      'lat': _latitude,
      'long': _longitude,
      'birthdate': _dateField,
      'phoneNumber': _phoneNumber,
      'imageUrl': _imageUrl,
      'publishedRentals' : _publishedRentals,
      'publishedExchanges' : _publishedExchange,
      'activeRentalsSell' : _activeRentalsSell,
      'activeRentalsBuy' : _activeRentalsBuy,
      'finishedRentalsSell' : _finishedRentalsBuy,
      'finishedRentalsBuy' : _finishedRentalsBuy,
      'expiredExchange' : _expiredExchange,
      'favoriteRentals' : _favoriteRentals,
      'favoriteExchanges' : _favoriteExchanges,
    };
  }

  // Metodo factory per creare un oggetto UserModel da una mappa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idToken: map['idToken'],
      name: map['username'],
      lastName: map['lastName'],
      email: map['email'],
      latitude: map['lat'],
      longitude: map['long'],
      birthDate: map['birthdate'],
      phoneNumber: map['phoneNumber'],
      imageUrl: map['imageUrl'],
      publishedRentals: map['publishedRentals'],
      publishedExchange: map['publishedExchanges'],
      activeRentalsSell: map['activeRentalsSell'],
      activeRentalsBuy: map['activeRentalsBuy'],
      finishedRentalsSell: map['finishedRentalsSell'],
      finishedRentalBuy: map['finishedRentalsBuy'],
      expiredExchange: map['expiredExchange'],
      favoriteExchanges: map['favoriteExchanges'],
      favoriteRentals: map['favoriteRentals'],
    );
  }

}
