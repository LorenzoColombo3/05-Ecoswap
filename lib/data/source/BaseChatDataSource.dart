import 'package:firebase_database/firebase_database.dart';

import '../../model/Chat.dart';
import '../../model/Message.dart';

abstract class BaseChatDataSource{
  Stream<List<DatabaseEvent>> getChatsStream(String userId);
  Stream<DatabaseEvent> getMessageStream(Chat chat);
  void markMessages(String chatId);
  void saveChat(Chat chat);
  void saveMessage(Chat chat, Message message);
  Future<Chat?> getChat(String userId, String itemId);
}