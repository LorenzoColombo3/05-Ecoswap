import '../../model/Exchange.dart';

abstract class BaseExchangeDataSource{

  Future<String?> loadExchange(Exchange exchange);
  Future<String> uploadImage(String imagePath);
  Future<void> loadFromFirebaseToLocal(Exchange exchange);
}
