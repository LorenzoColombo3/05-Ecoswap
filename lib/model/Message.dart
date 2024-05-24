class Message {
  final String idMessage;
  final String text;
  final String senderId;
  final int timestamp;
  final bool isRead;

  Message({required this.idMessage, required this.text, required this.senderId, required this.timestamp, required this.isRead});

  factory Message.fromMap( Map<dynamic, dynamic> data) {
    return Message(
      idMessage: data['idMessage'],
      text: data['text'],
      senderId: data['senderId'],
      timestamp: data['timestamp'],
      isRead: data['isRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMessage': idMessage,
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}