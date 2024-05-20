class Review {
  String userIdToken;
  String text;
  int stars;

  Review(this.userIdToken, this.text, this.stars);

  // Metodo factory per creare un'istanza di Review da una mappa
  factory Review.fromMap(Map<dynamic, dynamic> map) {
    return Review(
      map['userIdToken'],
      map['text'],
      map['stars'],
    );
  }

  // Metodo per convertire la Review in una mappa
  Map<dynamic, dynamic> toMap() {
    return {
      'userIdToken': userIdToken,
      'text': text,
      'stars': stars,
    };
  }

  // Getter per l'ID dell'utente
  String getUserIdToken() {
    return userIdToken;
  }

  // Setter per l'ID dell'utente
  void setUserIdToken(String idToken) {
    userIdToken = idToken;
  }

  // Getter per il testo della recensione
  String getText() {
    return text;
  }

  // Setter per il testo della recensione
  void setText(String reviewText) {
    text = reviewText;
  }

  // Getter per il numero di stelle
  int getStars() {
    return stars;
  }

  // Setter per il numero di stelle
  void setStars(int starRating) {
    stars = starRating;
  }
}
