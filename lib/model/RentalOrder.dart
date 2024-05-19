class RentalOrder {
  String _idToken;
  String _sellerId;
  String _buyerId;
  String _rentalId;
  String _dateTime;
  int _unitRented;
  int _price;
  int _days;

  // Costruttore
  RentalOrder({
    required String idToken,
    required String sellerId,
    required String buyerId,
    required String rentalId,
    required String dateTime,
    required int unitRented,
    required int price,
    required int days,
  })  : _idToken = idToken,
        _sellerId = sellerId,
        _buyerId = buyerId,
        _rentalId = rentalId,
        _dateTime = dateTime,
        _unitRented = unitRented,
        _price = price,
        _days = days;

  // Getter
  String get idToken => _idToken;
  String get sellerId => _sellerId;
  String get buyerId => _buyerId;
  String get rentalId => _rentalId;
  String get dateTime => _dateTime;
  int get unitRented => _unitRented;
  int get price => _price;
  int get days => _days;

  // Setter
  set idToken(String value) => _idToken = value;
  set sellerId(String value) => _sellerId = value;
  set buyerId(String value) => _buyerId = value;
  set rentalId(String value) => _rentalId = value;
  set dateTime(String value) => _dateTime = value;
  set unitRented(int value) => _unitRented = value;
  set price(int value) => _price = value;
  set days(int value) => _days = value;

  // Metodo toMap
  Map<String, dynamic> toMap() {
    return {
      'idToken': _idToken,
      'sellerId': _sellerId,
      'buyerId': _buyerId,
      'rentalId': _rentalId,
      'dateTime': _dateTime,
      'unitRented': _unitRented,
      'price': _price,
      'days': _days,
    };
  }

  // Metodo fromMap
  factory RentalOrder.fromMap(Map<dynamic, dynamic> map) {
    return RentalOrder(
      idToken: map['idToken'],
      sellerId: map['sellerId'],
      buyerId: map['buyerId'],
      rentalId: map['rentalId'],
      dateTime: map['dateTime'],
      unitRented: map['unitRented'],
      price: map['price'],
      days: map['days'],
    );
  }
}
