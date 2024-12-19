import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lyudashollywooda/view/subscription_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../chat_bot_bloc/chat_bot_bloc.dart';
import 'donate_page.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key, required this.userInfo, required this.userId, required this.jumpToTab, required this.productList});

  final Map<String, dynamic> userInfo;
  final String userId;
  final void Function(int) jumpToTab;
  final List<Package> productList;

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController messageTextFieldController = TextEditingController();

  late FocusNode messageFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBotBloc>(
      create: (context) => ChatBotBloc()..add(ChatBotChatsLoaded(userId: widget.userId)),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChatBotBloc, ChatBotState>(
            listenWhen: (previous, current) => previous.imageSource != current.imageSource && current.imageSource != null,
            listener: (context, state) async {
              final XFile? pickedFile = await ImagePicker().pickImage(
                source: state.imageSource!,
              );
              if (pickedFile != null && context.mounted) {
                context.read<ChatBotBloc>().add(ChatBotImageChanged(imagePath: pickedFile.path));
              }
            },
          ),
          BlocListener<ChatBotBloc, ChatBotState>(
            listenWhen: (previous, current) => previous.imagePath != current.imagePath && current.imagePath.isNotEmpty,
            listener: (context, state) {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  content: Column(
                    spacing: 10,
                    children: [
                      Container(
                        width: double.infinity,
                        // height: MediaQuery.of(context).size.height * 0.25,
                        clipBehavior: Clip.antiAlias,
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Image.file(
                          File(state.imagePath),
                          fit: BoxFit.cover,
                          // fit: BoxFit.fill,
                        ),
                      ),
                      TextField(
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                        focusNode: messageFocusNode,
                        maxLines: null,
                        expands: true,
                        controller: messageTextFieldController,
                        onChanged: (value) {
                          context.read<ChatBotBloc>().add(ChatBotQueryChanged(query: value));
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05,
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          hintText: "Повідомлення",
                          hintStyle: TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xFF7B7B7B),
                            fontSize: 14,
                            // fontSize: MediaQuery.textScalerOf(context).scale(14),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Скасувати",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black,
                          // fontSize: MediaQuery.textScalerOf(context).scale(12)
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (state.query != "" && RegExp(r'.*\S.*').hasMatch(state.query)) ? () {
                        HapticFeedback.lightImpact();
                        messageFocusNode.unfocus();
                        context.read<ChatBotBloc>().add(ChatBotRequestSent(userId: widget.userId));
                        messageTextFieldController.clear();
                        Navigator.pop(dialogContext);
                        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                      } : null,
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Надіслати",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          // fontSize: MediaQuery.textScalerOf(context).scale(12)
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ChatBotBloc, ChatBotState>(
          builder: (context, state) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Text(
                  "ЛюдаAI",
                  textScaler: TextScaler.linear(1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    // fontSize: MediaQuery.textScalerOf(context).scale(16),
                  ),
                ),
                leading: Container(
                  width: MediaQuery.of(context).size.height * 0.0591,
                  height: MediaQuery.of(context).size.height * 0.0591,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF0F0F0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _scaffoldKey.currentState!.openDrawer();
                      // Navigator.pop(context);
                    },
                  ),
                ),
                actions: widget.userInfo["role"] == "user" ? [
                  Container(
                    width: MediaQuery.of(context).size.height * 0.0591,
                    height: MediaQuery.of(context).size.height * 0.0591,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.009852,
                      right: 10,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF0F0F0),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/Star Circle.svg"),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: SubscriptionPage(userInfo: widget.userInfo, userId: widget.userId, productList: widget.productList,),
                          withNavBar: true,
                        );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const SubscriptionPage(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.height * 0.0591,
                    height: MediaQuery.of(context).size.height * 0.0591,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.009852,
                      right: 10,
                      // right: 10
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF0F0F0),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset("assets/icons/Hand Money.svg"),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: DonatePage(userInfo: widget.userInfo, userId: widget.userId, productList: widget.productList,),
                          withNavBar: true,
                        );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => DonatePage(userInfo: userInfo, userId: userId),
                        //   ),
                        // );
                      },
                    ),
                  ),
                ] : null,
              ),
              drawer: Drawer(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                    right: 5,
                    left: 15,
                  ),
                  child: Column(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: CircleBorder(),
                          side: BorderSide(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<ChatBotBloc>().add(ChatBotNewChatCreated());
                        },
                        child: Icon(
                          size: MediaQuery.of(context).size.height * 0.08,
                          Icons.add,
                          weight: 3,
                          color: Colors.black,
                        ),
                      ),
                      /*GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<ChatBotBloc>().add(ChatBotNewChatCreated());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.height * 0.08,
                      height: MediaQuery.of(context).size.height * 0.08,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: Colors.black,
                        ),
                      ),
                      child: Icon(
                        size: MediaQuery.of(context).size.height * 0.08,
                        Icons.add,
                        weight: 3,
                        color: Colors.black,
                      ),
                    ),
                  ),*/
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Divider(),
                      ),
                      Text(
                        "Чати",
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          // fontSize: MediaQuery.textScalerOf(context).scale(16),
                        ),
                      ),
                      ChatBotsList(),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: state.chatMessages,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text(
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            'Сталася помилка'
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            textScaler: TextScaler.linear(1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            "Завантаження"
                          );
                        }
                        if (snapshot.hasData) {
                          var messages = snapshot.data!.docs.reversed.toList();
                          return ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = messages[index].data()! as Map<String, dynamic>;
                              String messageId = messages[index].id;
                              String messageDateTime = "";
                              if (data["time"] != null) {
                                messageDateTime = DateFormat('HH:mm').format(data["time"].toDate());
                              }
                              if (data["is user"]) {
                                return UserMessage(data["query"], data["images"]);
                              }
                              else {
                                return BotMessage(data["is generating message"], messageDateTime, data["answer"]);
                              }
                            },
                          );
                        }
                        return Container();
                        // return const Center(
                        //   child: Text(
                        //     textScaler: TextScaler.linear(1),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //     "Немає повідомлень",
                        //   ),
                        // );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.of(context).size.height * 0.12 : 10,
                      // bottom: MediaQuery.of(context).size.height * 0.12,
                    ),
                    child: SizedBox(
                      // height: 52,
                      height: MediaQuery.of(context).size.height * 0.06,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: Colors.green,
                      //   )
                      // ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset("assets/icons/Paperclip.svg"),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                                  ),
                                  builder: (context) => DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.3,
                                    minChildSize: 0.3,
                                    maxChildSize: 0.3,
                                    builder: (context, scrollController) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                iconSize: 50,
                                                onPressed: () {
                                                  context.read<ChatBotBloc>().add(ChatBotImageSourceChanged(imageSource: ImageSource.gallery));
                                                },
                                                icon: Icon(Icons.folder_copy),
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            width: 20,
                                            color: Colors.grey.shade400,
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: IconButton(
                                                iconSize: 50,
                                                onPressed: () {
                                                  context.read<ChatBotBloc>().add(ChatBotImageSourceChanged(imageSource: ImageSource.camera));
                                                },
                                                icon: Icon(Icons.camera_alt_rounded),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                );
                                // if (imageSource != null) {}
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: TextField(
                              onTap: () {
                                HapticFeedback.lightImpact();
                              },
                              focusNode: messageFocusNode,
                              maxLines: null,
                              expands: true,
                              controller: messageTextFieldController,
                              onChanged: (value) {
                                context.read<ChatBotBloc>().add(ChatBotQueryChanged(query: value));
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.05,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD9D9D9),
                                  ),
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD9D9D9),
                                  ),
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(30)
                                ),
                                hintText: "Повідомлення",
                                hintStyle: TextStyle(
                                  fontFamily: "Inter",
                                  color: Color(0xFF7B7B7B),
                                  fontSize: 14,
                                  // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(EdgeInsets.all(10)),
                              shape: WidgetStateProperty.all(const CircleBorder()),
                              iconColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(WidgetState.pressed)) return Colors.black;
                                return Colors.white;
                              }),
                              backgroundColor: WidgetStateProperty.all(Colors.black), // <-- Button color
                              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(WidgetState.pressed)) return Colors.white;
                                return null;
                              }),
                            ),
                            onPressed: (state.query != "" && RegExp(r'.*\S.*').hasMatch(state.query)) ? () {
                              HapticFeedback.lightImpact();
                              messageFocusNode.unfocus();
                              context.read<ChatBotBloc>().add(ChatBotRequestSent(userId: widget.userId));
                              messageTextFieldController.clear();
                              _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                            } : null,
                            child: Icon(
                              Iconsax.send_2_copy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatBotsList extends StatelessWidget {
  const ChatBotsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBotBloc, ChatBotState>(
      builder: (context, state) {
        return switch (state.chatsLoadingStatus) {
          ChatsLoadingStatus.initial => Container(),
          ChatsLoadingStatus.inProgress => CircularProgressIndicator(color: Colors.blue,),
          ChatsLoadingStatus.failure => Text(
            "Сталася помилка",
            textScaler: TextScaler.linear(1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF212121),
              fontWeight: FontWeight.w600,
              fontSize: 16,
              // fontSize: MediaQuery.textScalerOf(context).scale(16),
            ),
          ),
          ChatsLoadingStatus.success => Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: state.userChats,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      'Помилка',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        // fontSize: MediaQuery.textScalerOf(context).scale(16),
                      ),
                    )
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      String chatId = snapshot.data!.docs[index].id;
                      Map<String, dynamic> chatData = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                      return ListTile(
                        title: chatData["is generating message"] ? LoadingAnimationWidget.waveDots(
                          color: Colors.black,
                          size: 15,
                        ) : Text(
                          chatData["last message"],
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            // fontSize: MediaQuery.textScalerOf(context).scale(16),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          context.read<ChatBotBloc>().add(ChatBotChatChanged(chatId: chatId));
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        // fontSize: MediaQuery.textScalerOf(context).scale(16),
                      ),
                      "Немає даних"
                    )
                  );
                }
              },
            ),
          ),
        };
      },
    );
  }
}

class UserMessage extends StatelessWidget {
  const UserMessage(this.query, this.images, {super.key});

  final String query;
  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                images == null ? Container(
                  margin: EdgeInsets.only(
                    right: 15,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      query,
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: Colors.white,
                        fontSize: 15,
                        // fontSize: MediaQuery.textScalerOf(context).scale(15)
                      ),
                    ),
                  ),
                ) : Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.4,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        images![0],
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        textScaler: TextScaler.linear(1),
                        query,
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.white,
                          fontSize: 15,
                          // fontSize: MediaQuery.textScalerOf(context).scale(15)
                        ),
                      ),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () async {
                //     final controller = VideoPlayerController.networkUrl(Uri.parse(data["url"]));
                //     final old = _videoController;
                //     _videoController = controller;
                //     if (old != null) {
                //       old.pause();
                //     }
                //     await controller.initialize();
                //     old?.dispose();
                //     controller.play();
                //   },
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     width: MediaQuery.of(context).size.height * 0.2,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border: Border.all(
                //         color: Color(0xFFD9D9D9),
                //       ),
                //     ),
                //     child: ,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     right: 15,
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(
                //         // Icons.done_all,
                //         data["isWatched"] ? Icons.done_all : Icons.done,
                //         color: Color(0xFF212121),
                //         size: 10,
                //       ),
                //       Text(
                //         textScaler: TextScaler.linear(1),
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         messageDateTime,
                //         style: TextStyle(
                //           fontFamily: "Inter",
                //           color: Color(0xFF7B7B7B),
                //           fontSize: 10,
                //           // fontSize: MediaQuery.textScalerOf(context).scale(10),
                //           fontWeight: FontWeight.w400,
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
            // const SizedBox(
            //   width: 10,
            // ),
          ]
      ),
    );
  }
}

class BotMessage extends StatelessWidget {
  const BotMessage(this.isGenerating, this.messageDateTime, this.answer, {super.key});

  final bool isGenerating;
  final String? answer;
  final String messageDateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: isGenerating ? LoadingAnimationWidget.waveDots(
                color: Colors.black,
                size: 15,
              ) : Text(
                textScaler: TextScaler.linear(1),
                answer ?? "",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.black,
                  fontSize: 15,
                  // fontSize: MediaQuery.textScalerOf(context).scale(15)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text(
              textScaler: TextScaler.linear(1),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              messageDateTime,
              style: TextStyle(
                fontFamily: "Inter",
                color: Color(0xFF7B7B7B),
                fontSize: 10,
                // fontSize: MediaQuery.textScalerOf(context).scale(10),
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}

