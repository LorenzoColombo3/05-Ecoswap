import 'package:firebase_database/firebase_database.dart';

import '../../model/Chat.dart';

abstract class BaseChatDataSource{
  Stream<List<DatabaseEvent>> getChatsStream(String userId);
  Stream<DatabaseEvent> getMessageStream(Chat chat);
  void markMessages(String chatId);
  void saveChat(Chat chat);
  Future<Chat?> getChat(String userId, String itemId);
}