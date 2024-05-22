import 'Message.dart';

class Chat {
  final String _id;
  final String _mainUser;
  final String _notMainUser;
  final String _adModel;
  List<Message>? _messages;
  Message? _lastMessage;

  Chat({required String id, required String mainUser, required String notMainUser, List<Message>? messages,  Message? lastMessage, required adModel})
      : _id = id,
        _mainUser = mainUser,
        _notMainUser = notMainUser,
        _messages = messages,
        _lastMessage = lastMessage,
        _adModel = adModel;

  factory Chat.fromMap(String id, Map<dynamic, dynamic> data) {
    return Chat(
      id: id,
      mainUser: data['mainUser'],
      notMainUser: data['notMainUser'],
      messages: data['messages'] != null
          ? List<Message>.from(data['messages'].map((messageData) => Message.fromMap(messageData)))
          : [],
      lastMessage: Message.fromMap(data['lastMessage']),
      adModel: data['adModel'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'mainUser': _mainUser,
      'notMainUser': _notMainUser,
      'messages': _messages!.map((message) => message.toMap()).toList(),
      'lastMessage': _lastMessage!.toMap(),
      'adModel' : _adModel,
    };
  }

  String get chatId => _id;

  String get chatMainUser => _mainUser;

  String get chatNotMainUser => _notMainUser;

  Message get lastMessage => _lastMessage!;

  List<Message>? get chatMessages => _messages;

  String get adModel => _adModel;
  set lastMessage(Message value) => _lastMessage = value;

  void addMessage(Message message) {
    if (_messages != null)
      _messages!.add(message);
    else
      _messages = [message];
  }

  void removeMessage(Message message) {
    _messages!.remove(message);
  }
}
