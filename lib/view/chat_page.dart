import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:video_player/video_player.dart';
import '../chat_bloc/chat_bloc.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chatId, required this.userInfo, required this.userId, required this.jumpToTab});

  final Map<String, dynamic> userInfo;
  final String userId;
  final String chatId;
  final void Function(int) jumpToTab;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController messageTextFieldController = TextEditingController();

  late FocusNode messageFocusNode;

  late CameraController cameraController;

  @override
  void initState() {
    super.initState();
    messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    messageFocusNode.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      await initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    // final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    cameraController = CameraController(front, ResolutionPreset.max);
    await cameraController.initialize();
    // await cameraController.pausePreview();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (_) => ChatBloc()..add(ChatRoomFullInfoFetched(chatRoomId: widget.chatId, userId: widget.userId)),
      child: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (previous, current) => previous.selectedImage != current.selectedImage && current.selectedImage.isNotEmpty,
        listener: (context, state) {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(10),
              content: Container(
                width: double.infinity,
                // height: MediaQuery.of(context).size.height * 0.25,
                clipBehavior: Clip.antiAlias,
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Image.file(
                  File(state.selectedImage),
                  fit: BoxFit.cover,
                  // fit: BoxFit.fill,
                ),
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
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.read<ChatBloc>().add(ChatImageSent(senderId: widget.userId));
                    Navigator.pop(dialogContext);
                  },
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
        builder: (context, state) {
          return Scaffold(
            // extendBody: false,
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.white,
              title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: state.chatCompanionInfo,
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        'Сталася помилка'
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        'Завантаження...'
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    final companionData = snapshot.data!.data()!;
                    String seen = companionData["last online"] == null ? "Онлайн" : DateFormat('dd.MM.yyyy HH:mm').format(companionData["last online"].toDate());
                    return Column(
                      children: [
                        Text(
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          companionData["name"],
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            // fontSize: MediaQuery.textScalerOf(context).scale(16),
                          ),
                        ),
                        Text(
                          textScaler: TextScaler.linear(1),
                          seen,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Inter",
                            color: Color(0xFF7B7B7B),
                          ),
                        )
                      ],
                    );
                  }
                  return const Center(
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Завантаження...",
                    ),
                  );
                },
              ),
              centerTitle: true,
              actions: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: state.chatCompanionInfo,
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          'Сталася помилка'
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text(
                          textScaler: TextScaler.linear(1),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          'Завантаження...'
                        )
                      );
                    }
                    if (snapshot.hasData) {
                      final companionData = snapshot.data!.data()!;
                        return Container(
                          width: MediaQuery.of(context).size.height * 0.0591,
                          height: MediaQuery.of(context).size.height * 0.0591,
                          margin: const EdgeInsets.only(
                            right: 15,
                            // right: 10
                          ),
                          // decoration: const BoxDecoration(
                          //   shape: BoxShape.circle,
                          // ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  companionData["avatar"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Visibility(
                                  visible: companionData["isOnline"],
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF20E070),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      // return CircleAvatar(
                      //   radius: MediaQuery.of(context).size.height * 0.0591,
                      //   backgroundColor: Colors.transparent,
                      //   child: Stack(
                      //     fit: StackFit.expand,
                      //     children: [
                      //       ClipRRect(
                      //         borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.0591),
                      //         child: Image.network(
                      //           companionData["avatar"],
                      //           width: MediaQuery.of(context).size.height * 0.0591,
                      //           height: MediaQuery.of(context).size.height * 0.0591,
                      //           fit: BoxFit.fill,
                      //         ),
                      //       ),
                      //       Align(
                      //         alignment: Alignment.topRight,
                      //         child: companionData["isOnline"] ? Container(
                      //           height: 25.0,
                      //           width: 25.0,
                      //           decoration: BoxDecoration(
                      //             color: Colors.green,
                      //             borderRadius: BorderRadius.circular(20.0),
                      //             border: Border.all(
                      //               width: 3.0,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ) : Container(),
                      //       )
                      //     ],
                      //   ),
                      // );
                      // if (companionData["isOnline"]) {
                      //   return Stack(
                      //     children: [
                      //       CircleAvatar(
                      //         radius: 25,
                      //         // radius: MediaQuery.of(context).size.height * 0.0591,
                      //         backgroundImage: NetworkImage(
                      //             companionData["avatar"]
                      //         ),
                      //       ),
                      //       Align(
                      //         alignment: Alignment.topRight,
                      //         child: Container(
                      //           height: 20.0,
                      //           width: 20.0,
                      //           decoration: BoxDecoration(
                      //             color: Color(0xFF20E070),
                      //             borderRadius: BorderRadius.circular(20.0),
                      //             border: Border.all(
                      //               width: 3.0,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   );
                      // }
                      // else {
                      //   return CircleAvatar(
                      //     radius: MediaQuery.of(context).size.height * 0.0591,
                      //     backgroundImage: NetworkImage(
                      //         companionData["avatar"]
                      //     ),
                      //   );
                      // }
                    }
                    return const Center(
                      child: Text(
                        textScaler: TextScaler.linear(1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "Завантаження...",
                      ),
                    );
                  },
                )
              ],
              leading: Container(
                width: MediaQuery.of(context).size.height * 0.0591,
                height: MediaQuery.of(context).size.height * 0.0591,
                margin: const EdgeInsets.only(
                  left: 10,
                  // right: 10
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF0F0F0),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (widget.userInfo["role"] == "user") {
                      widget.jumpToTab(0);
                    }
                    else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: state.messages,
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
                                if (data["sendBy"] == widget.userId) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            data["type"] == "text" ? Container(
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
                                                  data["message"],
                                                  style: TextStyle(
                                                    fontFamily: "Inter",
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    // fontSize: MediaQuery.textScalerOf(context).scale(15)
                                                  ),
                                                ),
                                              ),
                                            ) : data["type"] == "image" ? Container(
                                              width: MediaQuery.of(context).size.width,
                                              // height: MediaQuery.of(context).size.height * 0.4,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: Image.network(
                                                data["url"],
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ) : ChatVideoNote(id: messageId, url: data["url"]),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 15,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    // Icons.done_all,
                                                    data["isWatched"] ? Icons.done_all : Icons.done,
                                                    color: Color(0xFF212121),
                                                    size: 10,
                                                  ),
                                                  Text(
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
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        // const SizedBox(
                                        //   width: 10,
                                        // ),
                                      ]
                                    ),
                                  );
                                }
                                else {
                                  return VisibilityDetector(
                                    key: Key(messageId),
                                    onVisibilityChanged: (visibilityInfo) {
                                      var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                      if (visiblePercentage == 90) {
                                        context.read<ChatBloc>().add(ChatMessageViewedChanged(chatId: widget.chatId, messageId: messageId));
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  data["type"] == "text" ? Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(color: Color(0xFFD9D9D9)),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(11.0),
                                                      child: Text(
                                                        textScaler: TextScaler.linear(1),
                                                        data["message"],
                                                        style: TextStyle(
                                                          fontFamily: "Inter",
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          // fontSize: MediaQuery.textScalerOf(context).scale(15)
                                                        ),
                                                      ),
                                                    ),
                                                  ) : data["type"] == "image" ? Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    // height: MediaQuery.of(context).size.height * 0.4,
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: Image.network(
                                                      data["url"],
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ) : ChatVideoNote(id: messageId, url: data["url"]),
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
                                              // const SizedBox(
                                              //   width: 10,
                                              // ),
                                            ]
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     const Icon(
                                        //       Icons.done_all,
                                        //       color: Color(0xFF212121),
                                        //     ),
                                        //     Text(
                                        //       textScaler: TextScaler.linear(1),
                                        //       maxLines: 1,
                                        //       overflow: TextOverflow.ellipsis,
                                        //       messageDateTime,
                                        //       style: TextStyle(
                                        //         fontFamily: "Inter",
                                        //         color: Color(0xFF7B7B7B),
                                        //         fontSize: 10,
                                        //         // fontSize: MediaQuery.textScalerOf(context).scale(10),
                                        //         fontWeight: FontWeight.w400,
                                        //       ),
                                        //     )
                                        //   ],
                                        // )
                                      ],
                                    ),
                                  );
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
                      if (state.isRecordVideoNoteMode) ...[
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                          child: Opacity(
                            opacity: 0.7,
                            child: ModalBarrier(dismissible: false, color: Colors.grey.shade300),
                          ),
                        ),
                        ModalProgressHUD(
                          inAsyncCall: state.videoNoteCreationStatus == VideoNoteCreationStatus.inProgress,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: ClipOval(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CameraPreview(cameraController),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ]
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
                        Visibility(
                          visible: !state.isRecordVideoNoteMode,
                          // visible: !state.isRecordVideoNoteMode,
                          child: Container(
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
                                final XFile? pickedFile = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null && context.mounted) {
                                  context.read<ChatBloc>().add(ChatImageChanged(selectedImage: pickedFile.path));
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: widget.userInfo["role"] == "admin" && !state.isRecordVideoNoteMode,
                          // visible: !state.isRecordVideoNoteMode,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt_rounded),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                // await cameraController.resumePreview();
                                await initCamera();
                                if (context.mounted) context.read<ChatBloc>().add(ChatRecordVideoNoteModeChanged(isRecordVideoNote: true));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: state.isRecording,
                          child: state.isPaused ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                await cameraController.resumeVideoRecording();
                                if (context.mounted) context.read<ChatBloc>().add(ChatPausedChanged(isPaused: false));
                              },
                            ),
                          ) : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.pause),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                await cameraController.pauseVideoRecording();
                                if (context.mounted) context.read<ChatBloc>().add(ChatPausedChanged(isPaused: true));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: state.isRecordVideoNoteMode,
                          child: state.isRecording ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.square_rounded),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                final videoNote = await cameraController.stopVideoRecording();
                                final videoNoteFile = videoNote.path;
                                if (context.mounted) {
                                  context.read<ChatBloc>().add(ChatRecordingChanged(isRecording: false));
                                  context.read<ChatBloc>().add(ChatVideoNoteChanged(videoNotePath: videoNoteFile));
                                }
                              },
                            ),
                          ) : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.circle, color: Colors.red,),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                await cameraController.prepareForVideoRecording();
                                await cameraController.startVideoRecording();
                                if (context.mounted) context.read<ChatBloc>().add(ChatRecordingChanged(isRecording: true));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Visibility(
                          visible: state.isRecordVideoNoteMode,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFD9D9D9),
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.close_sharp),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                if (cameraController.value.isRecordingVideo) {
                                  await cameraController.stopVideoRecording();
                                }
                              // await cameraController.pausePreview();
                                if (context.mounted) {
                                  context.read<ChatBloc>().add(ChatRecordingChanged(isRecording: false));
                                  context.read<ChatBloc>().add(ChatRecordVideoNoteModeChanged(isRecordVideoNote: false));
                                }
                                cameraController.dispose();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: TextField(
                            enabled: !state.isRecordVideoNoteMode,
                            onTap: () {
                              HapticFeedback.lightImpact();
                            },
                            focusNode: messageFocusNode,
                            maxLines: null,
                            expands: true,
                            controller: messageTextFieldController,
                            onChanged: (value) {
                              context.read<ChatBloc>().add(ChatMessageChanged(message: value));
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
                        state.isRecordVideoNoteMode ? ElevatedButton(
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
                          onPressed: (state.isRecording || state.videoNotePath != "") ? () async {
                            HapticFeedback.lightImpact();
                            if (cameraController.value.isRecordingVideo) {
                              final videoNote = await cameraController.stopVideoRecording();
                              final videoNoteFile = videoNote.path;
                              if (context.mounted) {
                                context.read<ChatBloc>().add(ChatRecordingChanged(isRecording: false));
                                context.read<ChatBloc>().add(ChatVideoNoteChanged(videoNotePath: videoNoteFile));
                              }
                            }
                            if (context.mounted) context.read<ChatBloc>().add(ChatVideoNoteSent(senderId: widget.userId,));
                            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                          } : null,
                          child: Icon(
                            Iconsax.send_2_copy,
                          ),
                        ) : ElevatedButton(
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
                          onPressed: (state.message != "" && RegExp(r'.*\S.*').hasMatch(state.message)) ? () {
                            HapticFeedback.lightImpact();
                            messageFocusNode.unfocus();
                            context.read<ChatBloc>().add(ChatMessageSent(senderId: widget.userId));
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
    );
  }
}

class ChatVideoNote extends StatefulWidget {
  const ChatVideoNote({super.key, required this.id, required this.url});

  final String id;
  final String url;

  @override
  State<ChatVideoNote> createState() => _VideoNoteState();
}

class _VideoNoteState extends State<ChatVideoNote> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )
      ..initialize().then((_) {
        controller.setVolume(0.0);
        controller.play();
        controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listenWhen: (previous, current) => previous.selectedVideoNote != current.selectedVideoNote,
      listener: (context, state) async {
        if (state.selectedVideoNote == widget.id) {
          // Duration currentPosition = controller.value.position;
          // Duration targetPosition = currentPosition - currentPosition;
          controller.seekTo(Duration());
          final volume = await FlutterVolumeController.getVolume();
          controller.setVolume(volume ?? 0.5);
        } else {
          controller.setVolume(0.0);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<ChatBloc>().add(ChatVideoNotePressed(videoNoteId: widget.id));
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFFD9D9D9),
              ),
            ),
            child: ClipOval(child: VideoPlayer(controller)),
          ),
        );
      },
    );
  }
}
