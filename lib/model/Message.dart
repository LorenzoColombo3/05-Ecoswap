class Message {
  final String text;
  final String senderId;
  final int timestamp;
  final bool isRead;

  Message({required this.text, required this.senderId, required this.timestamp, required this.isRead});

  factory Message.fromMap(Map<dynamic, dynamic> data) {
    return Message(
      text: data['text'],
      senderId: data['senderId'],
      timestamp: data['timestamp'],
      isRead: data['isRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}