import 'package:eco_swap/view/chatPages/UserChatPage.dart';
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
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late IUserRepository userRepository;
  late UserViewModel userViewModel;
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  late UserModel? currentUser;
  late UserModel? chatUser;

  @override
  void initState() {
    super.initState();
    userRepository = ServiceLocator().getUserRepository();
    userViewModel = new UserViewModelFactory(userRepository).create();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: userViewModel.getUser(), // Ottieni l'utente
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          currentUser = snapshot.data!;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: StreamBuilder<List<DatabaseEvent>>(
              stream: userViewModel.getChatsStream(currentUser!.idToken),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No chats available'));
                }

                // Combine the data from the two events
                final mainUserChatsData = (snapshot.data![0].snapshot.value as Map<dynamic, dynamic>?) ?? {};
                final notMainUserChatsData = (snapshot.data![1].snapshot.value as Map<dynamic, dynamic>?) ?? {};

                // Merge the two maps
                final combinedChatsData = {...mainUserChatsData, ...notMainUserChatsData};

                // Convert the combined data to a list of Chat objects
                var chatsList = combinedChatsData.entries.map((entry) {
                  return Chat.fromMap(entry.key, entry.value);
                }).toList();

                // Filter chats where the current user is a participant
                chatsList = chatsList
                    .where((chat) =>
                        chat.chatMainUser == currentUser!.idToken || chat.chatNotMainUser == currentUser!.idToken)
                    .toList();

                // Sort the chats list by the lastMessage timestamp
                chatsList.sort((a, b) =>
                    b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp));

                return ListView.separated(
                  itemCount: chatsList.length,
                  itemBuilder: (context, index) {
                    Chat chat = chatsList[index];
                    String otherUserId = chat.chatMainUser != currentUser!.idToken
                        ? chat.chatMainUser : chat.chatNotMainUser;
                    Message lastMessage = chat.lastMessage;
                    return FutureBuilder<UserModel?>(
                      future: userViewModel.getUserData(otherUserId), // Ottieni l'utente
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          chatUser = snapshot.data!;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(chatUser!.imageUrl),
                            ),
                            title: Text(
                              chatUser!.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Stack(
                              children: [
                                Text(
                                  lastMessage.text,
                                  style: TextStyle(
                                    fontWeight: lastMessage.isRead || lastMessage.senderId == currentUser!.idToken
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                if (!lastMessage.isRead && lastMessage.senderId != currentUser!.idToken)
                                  Positioned(
                                    right: 0,
                                    bottom: 3,
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.blueAccent,
                                      size: 10,
                                    ),
                                  ),

                              ],
                            ),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserChatPage(chat: chat, user: currentUser!, firstLoad: false),
                                ),
                              );
                            },
                          );

                        } else {
                          return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
                        }
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    );
                  },
                );
              },
            ),
          );
        } else {
          return const CircularProgressIndicator(); // Visualizza un indicatore di caricamento in attesa
        }
      },
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey,
      ),
    );
  }
}
