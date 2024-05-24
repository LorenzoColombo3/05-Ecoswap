import 'package:eco_swap/data/source/BaseChatDataSource.dart';
import 'package:eco_swap/model/Message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import '../../model/Chat.dart';

class ChatDataSource extends BaseChatDataSource{
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  Stream<List<DatabaseEvent>> getChatsStream(String userId) {
    Stream<DatabaseEvent> mainUserChats = _database
        .child('chats')
        .orderByChild('mainUser')
        .equalTo(userId)
        .onValue;

    Stream<DatabaseEvent> notMainUserChats = _database
        .child('chats')
        .orderByChild('notMainUser')
        .equalTo(userId)
        .onValue;

    // Combine the streams and return a single stream
    return Rx.combineLatest2(
      mainUserChats,
      notMainUserChats,
          (DatabaseEvent mainUserChatsEvent, DatabaseEvent notMainUserChatsEvent) {
        return [mainUserChatsEvent, notMainUserChatsEvent];
      },
    );
  }

  @override
  void markMessages(String chatId) {
    _database.child('chats').child(chatId).child('lastMessage').update({'isRead': true});
  }

  @override
  void saveChat(Chat chat) {
    _database.child('chats').child(chat.chatId).set(chat.toMap());
  }

  

  @override
  Stream<DatabaseEvent> getMessageStream(Chat chat) {
    return _database.child('chats')
        .child(chat.chatId)
        .child('messages')
        .onValue;
  }

  @override
  Future<Chat?> getChat(String userId, String itemId) async {
    try {
      DataSnapshot snapshot = await _database.child('chats').child('$userId-$itemId').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic>? chatData = snapshot.value as Map<dynamic, dynamic>?;
        return Chat.fromMap(snapshot.key!, chatData!);
      } else {
        print("Chat non ancora esistente");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void saveMessage(Chat chat, Message message) {
    try {
      print("aa");
      _database.child('chats').child(chat.chatId).child("messages").child(
          message.idMessage).set(message.toMap());
      _database.child('chats').child(chat.chatId).child("lastMessage").set(
          message.toMap());
    }catch(e){
      print(e.toString());
    }
  }




}