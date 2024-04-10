class UserModel {
  String _idToken;
  String _name;
  String _lastName;
  String _email;
  String _position;
  String _dateField;
  String _phoneNumber;

  // Costruttore della classe
  UserModel({
    required String idToken,
    required String name,
    required String lastName,
    required String? email,
    required String birthDate,
    required String phoneNumber,
    required position,
  })  : _idToken = idToken,
        _name = name,
        _lastName = lastName,
        _email = email!,
        _position = position,
        _dateField = birthDate,
        _phoneNumber = phoneNumber;

  // Getter per idToken
  String get idToken => _idToken;

  // Setter per idToken
  set idToken(String value) {
    _idToken = value;
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

  // Getter per position
  String get position => _position;

  // Setter per position
  set position(String value) {
    _position = value;
  }

  // Getter per dateField
  String get birthdate => _dateField;

  // Setter per dateField
  set birthdate(String value) {
    birthdate = value;
  }

  //getter per il numero di telefono
  String get phoneNumber => _phoneNumber;

  // Setter per il numero di telefono
  set phoneNumber(String value) {
    _phoneNumber = value;
  }
  Map<String, dynamic> toMap() {
    return {
      'idToken': _idToken,
      'name': _name,
      'lastName': _lastName,
      'email': _email,
      'position': _position,
      'birthdate': _dateField,
      'phoneNumber': _phoneNumber,
    };
  }

  // Factory method per creare un oggetto User da una mappa
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      idToken: map['idToken'],
      name: map['name'],
      lastName: map['lastName'],
      email: map['email'],
      position: map['position'],
      birthDate: map['birthdate'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
