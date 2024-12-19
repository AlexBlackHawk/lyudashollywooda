import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../chat_bloc/chat_bloc.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key, required this.userInfo, required this.userId, required this.jumpToTab});

  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  Future<Map<String, dynamic>> getUserInfo(String userID) async {
    DocumentReference tourDocument = FirebaseFirestore.instance.collection("Users").doc(userID);
    DocumentSnapshot snapshot = await tourDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc()..add(const ChatAllChatsFetched()),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0.0,
              title: Text(
                textScaler: TextScaler.linear(1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                "Чати",
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  // fontSize: MediaQuery.textScalerOf(context).scale(16),
                ),
              ),
              centerTitle: true,
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF0F0F0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showSearch(
                        context: context,
                        delegate: ChatSearchDelegate(
                          chatBloc: BlocProvider.of<ChatBloc>(context),
                          userId: widget.userId,
                          userInfo: widget.userInfo,
                          jumpToTab: widget.jumpToTab,
                        ),
                      );
                    }
                  ),
                ),
              ],
              leading: Container(
                width: MediaQuery.of(context).size.height * 0.0591,
                height: MediaQuery.of(context).size.height * 0.0591,
                margin: const EdgeInsets.only(left: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F0F0),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    widget.jumpToTab(0);
                    // Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: state.chats,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      'Помилка'
                    )
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                      final fetchedUser = getUserInfo(data["users"][0] == widget.userId ? data["users"][1] : data["users"][0]);
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ChatPage(
                                  userInfo: widget.userInfo,
                                  userId: widget.userId,
                                  chatId: snapshot.data!.docs[index].id,
                                  jumpToTab: widget.jumpToTab,
                                ),
                                withNavBar: true,
                              );
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => ChatPage(
                              //       userInfo: userInfo,
                              //       userId: userId,
                              //       chatId: snapshot.data!.docs[index].id,
                              //     ),
                              //   ),
                              // );
                            },
                            title: FutureBuilder<Map<String, dynamic>>(
                              future: fetchedUser,
                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                                if (userSnapshot.hasError) {
                                  return const Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "Error"
                                  );
                                }
                                if (userSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    "Завантаження"
                                  );
                                }

                                if (userSnapshot.hasData) {
                                  final userData = userSnapshot.data!;
                                  final userName = userData["name"] ?? "Unknown";
                                  return Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    userName,
                                    style: TextStyle(
                                      fontFamily: "Inter",
                                      color: Color(0xFF212121),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      // fontSize: MediaQuery.textScalerOf(context).scale(16),
                                    ),
                                  );
                                }

                                return const Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "No Data"
                                );
                              },
                            ),
                            subtitle: Text(
                              textScaler: TextScaler.linear(1),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              data["last message"] ?? "No message",
                              style: TextStyle(
                                fontFamily: "Inter",
                                color: Color(0xFF7B7B7B),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                // fontSize: MediaQuery.textScalerOf(context).scale(14),
                              ),
                            ),
                            leading: FutureBuilder<Map<String, dynamic>>(
                              future: fetchedUser,
                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                                if (userSnapshot.hasError) {
                                  return const CircleAvatar(
                                    radius: 30,
                                    child: Icon(Icons.error),
                                  );
                                }
                                if (userSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircleAvatar(
                                    radius: 30,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (userSnapshot.hasData) {
                                  final userData = userSnapshot.data!;
                                  final userAvatar = userData["avatar"] ?? "";
                                  return CircleAvatar(
                                    radius: 30,
                                    backgroundImage: userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
                                    child: userAvatar.isEmpty ? const Icon(Icons.person) : null,
                                  );
                                }
                                return const CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.person),
                                );
                              },
                            ),
                          ),
                          Visibility(
                            visible: index == (snapshot.data!.docs.length - 1),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: Color(0xFFD9D9D9),
                    ),
                    itemCount: snapshot.data!.docs.length,
                  );
                } else {
                  return const Center(
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Немає даних"
                    )
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}


class ChatSearchDelegate extends SearchDelegate {
  ChatSearchDelegate({
    required this.chatBloc,
    required this.userId,
    required this.userInfo,
    required this.jumpToTab,
  }) : super(
    searchFieldLabel: "Пошук",
      searchFieldStyle: TextStyle(
        color: Color(0xFF7B7B7B),
        fontSize: 15,
        fontWeight: FontWeight.w500,
        fontFamily: "Inter",
      ),
  );

  final Bloc<ChatEvent, ChatState> chatBloc;
  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;

  Future<Map<String, dynamic>> getUserInfo(String userID) async {
    DocumentReference tourDocument = FirebaseFirestore.instance.collection("Users").doc(userID);
    DocumentSnapshot snapshot = await tourDocument.get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Document does not exist');
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        HapticFeedback.lightImpact();
        query.isEmpty ? close(context, null) : query = '';
      },
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      HapticFeedback.lightImpact();
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) {
    chatBloc.add(ChatChatsFound(query: query));
    return BlocBuilder(
      bloc: chatBloc,
      builder: (BuildContext context, ChatState state) {
        return Container(
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: state.searchedChats,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    'Помилка'
                  )
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                    final fetchedUser = getUserInfo(data["users"][0] == userId ? data["users"][1] : data["users"][0]);
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            close(context, null);
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: ChatPage(
                                userInfo: userInfo,
                                userId: userId,
                                chatId: snapshot.data!.docs[index].id,
                                jumpToTab: jumpToTab,
                              ),
                              withNavBar: true,
                            );
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => ChatPage(
                            //       userInfo: userInfo,
                            //       userId: userId,
                            //       chatId: snapshot.data!.docs[index].id,
                            //     ),
                            //   ),
                            // );
                          },
                          title: FutureBuilder<Map<String, dynamic>>(
                            future: fetchedUser,
                            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                              if (userSnapshot.hasError) {
                                return const Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Error"
                                );
                              }
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return const Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Завантаження"
                                );
                              }
                              if (userSnapshot.hasData) {
                                final userData = userSnapshot.data!;
                                final userName = userData["name"] ?? "Unknown";
                                return Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  userName,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(16),
                                  ),
                                );
                              }
                              return const Text(
                                textScaler: TextScaler.linear(1),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                "No Data"
                              );
                            },
                          ),
                          subtitle: Text(
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            data["last message"] ?? "No message",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Color(0xFF7B7B7B),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              // fontSize: MediaQuery.textScalerOf(context).scale(14),
                            ),
                          ),
                          leading: FutureBuilder<Map<String, dynamic>>(
                            future: fetchedUser,
                            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> userSnapshot) {
                              if (userSnapshot.hasError) {
                                return const CircleAvatar(
                                  radius: 30,
                                  child: Icon(Icons.error),
                                );
                              }
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircleAvatar(
                                  radius: 30,
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (userSnapshot.hasData) {
                                final userData = userSnapshot.data!;
                                final userAvatar = userData["avatar"] ?? "";
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundImage: userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
                                  child: userAvatar.isEmpty ? const Icon(Icons.person) : null,
                                );
                              }
                              return const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: index == (snapshot.data!.docs.length - 1),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFD9D9D9),
                  ),
                  itemCount: snapshot.data!.docs.length,
                );
              } else {
                return const Center(
                  child: Text(
                    textScaler: TextScaler.linear(1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "No Data"
                  )
                );
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container(
    color: Colors.white,
  );
}
