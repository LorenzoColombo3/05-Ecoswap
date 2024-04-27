import 'package:flutter/cupertino.dart';

import '../../model/Exchange.dart';

abstract class BaseExchangeDataSource{
  late final Function (Exchange exchange) onLoadFinished;
  Future<String?> loadExchange(Exchange exchange);
  Future<String> uploadImage(String imagePath);
  Future<void> loadFromFirebaseToLocal(Exchange exchange);


  void setCallback(Function (Exchange exchange) onLoadFinished){
    this.onLoadFinished=onLoadFinished;
  }
}
