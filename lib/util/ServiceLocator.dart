class ServiceLocator {
  static ServiceLocator? _instance;

  // Costruttore privato
  ServiceLocator._();

  // Metodo per ottenere l'istanza singleton
  static ServiceLocator getInstance() {
    if (_instance == null) {
      synchronized(ServiceLocator) {
        if (_instance == null) {
          _instance = ServiceLocator._();
        }
      }
    }
    return _instance!;
  }


}
