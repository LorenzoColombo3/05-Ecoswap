import 'package:eco_swap/widget/ChatBubble.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../data/repository/IAdRepository.dart';
import '../../data/repository/IUserRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../data/viewmodel/UserViewModel.dart';
import '../../data/viewmodel/UserViewModelFactory.dart';
import '../../model/Chat.dart';
import '../../model/Message.dart';
import 'package:uuid/uuid.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class UserChatPage extends StatefulWidget {
  final Chat chat;
  final UserModel? user;
  final bool firstLoad;

  const UserChatPage(
      {super.key,
      required this.chat,
      required this.user,
      required this.firstLoad});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  final TextEditingController _controller = TextEditingController();
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late bool saveChat;

  @override
  void initState() {
    super.initState();
    saveChat = widget.firstLoad;
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    if (!widget.firstLoad) {
      if (widget.chat.lastMessage.senderId != widget.user!.idToken) {
        userViewModel.markMessages(widget.chat.chatId);
      }
    }
  }

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      Message message = Message(
        idMessage: Uuid().v4(),
        text: text,
        senderId: widget.user!.idToken,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        isRead: false,
      );
      widget.chat.addMessage(message);
      widget.chat.lastMessage = message;
      if(saveChat) {
        userViewModel.saveChat(widget.chat);
        userViewModel.saveMessage(widget.chat, message);
        saveChat = false;
      }else{
        userViewModel.saveMessage(widget.chat, message);
      }
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.chat.adModel),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: userViewModel.getMessageStream(widget.chat),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No messages available'));
                }
                List<dynamic> messagesData =
                    snapshot.data!.snapshot.value as List<dynamic>;
                List<Message> messagesList = messagesData.map((messageData) {
                  return Message.fromMap( messageData as Map<dynamic, dynamic>);
                }).toList();
                messagesList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                return ListView.builder(
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    Message message = messagesList[index];
                    var alignment = (message.senderId == widget.user!.idToken)
                        ? Alignment.centerRight
                        : Alignment.centerLeft;
                    return Container(
                      alignment: alignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              (message.senderId == widget.user!.idToken)
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          mainAxisAlignment:
                              (message.senderId == widget.user!.idToken)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            ChatBubble(message: message.text),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Column(
            children: [
              Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Enter message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, size: 30),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
