import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lyudashollywooda/new_post_bloc/new_post_bloc.dart';
import 'package:lyudashollywooda/post_list/post_list_bloc.dart';
import 'package:lyudashollywooda/view/donate_page.dart';
import 'package:lyudashollywooda/view/post_text_info_page.dart';
import 'package:lyudashollywooda/view/post_video_info_page.dart';
import 'package:lyudashollywooda/view/subscription_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import '../configs/constants.dart';
import 'add_text_post_page.dart';
import 'add_video_post_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key, required this.userInfo, required this.userId, required this.showAds, required this.jumpToTab, required this.productList});

  final Map<String, dynamic> userInfo;
  final String userId;
  final bool showAds;
  final void Function(int) jumpToTab;
  final List<Package> productList;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with WidgetsBindingObserver {
  final bool showSheet = true;

  late CameraController cameraController;

  final Map<String, String> categories = <String, String>{
    "Сімʼя": "assets/chip_images/img.png",
    "Стиль": "assets/chip_images/img_5.png",
    "Заробіток": "assets/chip_images/img_1.png",
    "Правильне харчування": "assets/chip_images/img_3.png",
    "Розвиток дітей": "assets/chip_images/img_4.png",
    "Спорт і схуднення": "assets/chip_images/img_2.png",
  };

  @override
  void dispose() {
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
    // final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    cameraController = CameraController(front, ResolutionPreset.medium);
    await cameraController.initialize();
    // await cameraController.pausePreview();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) {
        final videoNoteCreationStatus = context.select((NewPostBloc newPostBloc) => newPostBloc.state.creationStatus);
        return ModalProgressHUD(
          inAsyncCall: state.isAdLoading || state.deletionStatus == VideoNoteDeletionStatus.inProgress || videoNoteCreationStatus == CreationStatus.inProgress,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                floatingActionButton: Visibility(
                  visible: widget.userInfo["role"] == "admin",
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.098,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: "text post",
                          shape: const CircleBorder(
                            // borderRadius: BorderRadius.zero,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: AddNewPostPage(userInfo: widget.userInfo, userId: widget.userId,),
                              withNavBar: true,
                            );
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => AddNewPostPage(userInfo: userInfo, userId: userId,),
                            //   ),
                            // );
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: const Icon(Iconsax.edit_2_copy),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FloatingActionButton(
                          heroTag: "video note",
                          shape: const CircleBorder(
                            // borderRadius: BorderRadius.zero,
                          ),
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            await initCamera();
                            if (context.mounted) context.read<PostListBloc>().add(PostListRecordVideoNoteModeChanged(recordVideoNoteMode: true));
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.camera_alt_rounded),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FloatingActionButton(
                          heroTag: "video post",
                          shape: const CircleBorder(
                            // borderRadius: BorderRadius.zero,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: AddNewVideoPostPage(userInfo: widget.userInfo, userId: widget.userId,),
                              withNavBar: true,
                            );
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          child: const Icon(Icons.video_call),
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                extendBody: false,
                resizeToAvoidBottomInset: false,
                appBar: widget.userInfo["role"] == "user" ? AppBar(
                  scrolledUnderElevation: 0.0,
                  backgroundColor: Colors.white,
                  actions: [
                    widget.userInfo["role"] == "user" ? Container(
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
                    ) : Container(),
                    Visibility(
                      visible: widget.userInfo["role"] == "user",
                      child: Container(
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
                    ),
                    Visibility(
                      visible: widget.userInfo["role"] == "user",
                      child: Container(
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
                          icon: SvgPicture.asset("assets/icons/Settings.svg"),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            widget.jumpToTab(3);
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => SettingsPage(userId: userId,),
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ),
                  ],
                  leading: Visibility(
                    visible: widget.userInfo["role"] == "user",
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.009852,
                        left: 10,
                      ),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.0591,
                        backgroundImage: NetworkImage(
                          widget.userInfo["avatar"],
                        ),
                      ),
                    ),
                  ),
                ) : null,
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02,
                            // left: 10,
                          ),
                          padding: EdgeInsets.only(
                            // bottom: MediaQuery.of(context).size.height * 0.02,
                            left: 10,
                            right: 10,
                          ),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              FilterChip(
                                selectedColor: state.filters.contains("Сімʼя") ? Colors.black.withValues(alpha: 0.4) : Colors.white,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(color: state.filters.contains("Сімʼя") ? Colors.black : const Color(0xFFD9D9D9)),
                                ),
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/chip_images/img.png"),
                                ),
                                label: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Сімʼя",
                                  style: TextStyle(
                                      color: state.filters.contains("Сімʼя") ? Colors.white : Colors.black
                                  ),
                                ),
                                selected: state.filters.contains("Сімʼя"),
                                onSelected: (newState) {
                                  HapticFeedback.lightImpact();
                                  context.read<PostListBloc>().add(PostListFiltersChanged(filter: "Сімʼя", isSelected: newState));
                                },
                              ),
                              const SizedBox(width: 5,),
                              FilterChip(
                                selectedColor: state.filters.contains("Правильне харчування") ? Colors.black.withValues(alpha: 0.4) : Colors.white,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(color: state.filters.contains("Правильне харчування") ? Colors.black : const Color(0xFFD9D9D9)),
                                ),
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/chip_images/img_3.png"),
                                ),
                                label: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Правильне харчування",
                                  style: TextStyle(
                                      color: state.filters.contains("Правильне харчування") ? Colors.white : Colors.black
                                  ),
                                ),
                                selected: state.filters.contains("Правильне харчування"),
                                onSelected: (newState) {
                                  HapticFeedback.lightImpact();
                                  context.read<PostListBloc>().add(PostListFiltersChanged(filter: "Правильне харчування", isSelected: newState));
                                },
                              ),
                              const SizedBox(width: 5,),
                              FilterChip(
                                selectedColor: state.filters.contains("Спорт і схуднення") ? Colors.black.withValues(alpha: 0.4) : Colors.white,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(color: state.filters.contains("Спорт і схуднення") ? Colors.black : const Color(0xFFD9D9D9)),
                                ),
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/chip_images/img_2.png"),
                                ),
                                label: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Спорт і схуднення",
                                  style: TextStyle(
                                    color: state.filters.contains("Спорт і схуднення") ? Colors.white : Colors.black
                                  ),
                                ),
                                selected: state.filters.contains("Спорт і схуднення"),
                                onSelected: (newState) {
                                  HapticFeedback.lightImpact();
                                  context.read<PostListBloc>().add(PostListFiltersChanged(filter: "Спорт і схуднення", isSelected: newState));
                                },
                              ),
                              const SizedBox(width: 5,),
                              FilterChip(
                                selectedColor: state.filters.contains("Заробіток") ? Colors.black.withValues(alpha: 0.4) : Colors.white,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(color: state.filters.contains("Заробіток") ? Colors.black : const Color(0xFFD9D9D9)),
                                ),
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/chip_images/img_1.png"),
                                ),
                                label: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Заробіток",
                                  style: TextStyle(
                                    color: state.filters.contains("Заробіток") ? Colors.white : Colors.black
                                  ),
                                ),
                                selected: state.filters.contains("Заробіток"),
                                onSelected: (newState) {
                                  HapticFeedback.lightImpact();
                                  context.read<PostListBloc>().add(PostListFiltersChanged(filter: "Заробіток", isSelected: newState));
                                },
                              ),
                              const SizedBox(width: 5,),
                              FilterChip(
                                selectedColor: state.filters.contains("Розвиток дітей") ? Colors.black.withValues(alpha: 0.4) : Colors.white,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(color: state.filters.contains("Розвиток дітей") ? Colors.black : const Color(0xFFD9D9D9)),
                                ),
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/chip_images/img_4.png"),
                                ),
                                label: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Розвиток дітей",
                                  style: TextStyle(
                                    color: state.filters.contains("Розвиток дітей") ? Colors.white : Colors.black
                                  ),
                                ),
                                selected: state.filters.contains("Розвиток дітей"),
                                onSelected: (newState) {
                                  HapticFeedback.lightImpact();
                                  context.read<PostListBloc>().add(PostListFiltersChanged(filter: "Розвиток дітей", isSelected: newState));
                                },
                              ),
                              const SizedBox(width: 5,),
                              FilterChip(
                                selectedColor: state.filters.contains("Стиль") ? Colors.black.withValues(alpha: 0.4) : Colors.white,
                                showCheckmark: false,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  // side: BorderSide(color: state.filters.contains("Стиль") ? Colors.black : const Color(0xFFD9D9D9)),
                                ),
                                avatar: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage("assets/chip_images/img_5.png"),
                                ),
                                label: Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Стиль",
                                  style: TextStyle(
                                    color: state.filters.contains("Стиль") ? Colors.white : Colors.black
                                  ),
                                ),
                                selected: state.filters.contains("Стиль"),
                                onSelected: (newState) {
                                  HapticFeedback.lightImpact();
                                  context.read<PostListBloc>().add(PostListFiltersChanged(filter: "Стиль", isSelected: newState));
                                },
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.02,
                        // ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: state.posts,
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    'Сталася помилка'
                                  )
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
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  // separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                                  itemBuilder: (BuildContext context, int index) {
                                    String postId = snapshot.data!.docs[index].id;
                                    Map<String, dynamic> postData = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          postData["type"] == "text" ? PostListTextItem(
                                            postData: postData,
                                            userInfo: widget.userInfo,
                                            showAds: widget.showAds,
                                            postId: postId,
                                            userId: widget.userId,
                                            productList: widget.productList,
                                          ) : postData["type"] == "video note" ? PostVideoNoteItem(
                                            url: postData["video note"],
                                            userId: widget.userId,
                                            postId: postId,
                                            likes: postData["likedBy"],
                                            isAdmin: widget.userInfo["role"] == "admin",
                                          ) : PostListVideoItem(
                                            postData: postData,
                                            userInfo: widget.userInfo,
                                            showAds: widget.showAds,
                                            postId: postId,
                                            userId: widget.userId,
                                            productList: widget.productList,
                                          ),
                                          Visibility(
                                            visible: index == (snapshot.data!.docs.length - 1),
                                            child: SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    // return const Center(
                                    //   child: Text(
                                    //       textScaler: TextScaler.linear(1),
                                    //     "Немає постів"
                                    //   ),
                                    // );
                                  },
                                );
                              }
                              return Container();
                              // return const Center(
                              //   child: Text(
                              //     textScaler: TextScaler.linear(1),
                              //     maxLines: 1,
                              //     overflow: TextOverflow.ellipsis,
                              //     "Немає постів",
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.isRecordVideoNoteMode) ...[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                  child: Opacity(
                    opacity: 0.7,
                    child: ModalBarrier(dismissible: false, color: Color(0xFF6D453D)),
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     width: 270,
                //     height: 270,
                //     decoration: BoxDecoration(
                //       color: Colors.green,
                //     ),
                //   ),
                // )
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   width: 270,
                    //   height: 270,
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //   ),
                    // )
                    Padding(
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
                    VideoNoteCategoryChips(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: OverflowBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          Visibility(
                            visible: cameraController.value.isRecordingVideo,
                            // visible: state.isRecording,
                            child: cameraController.value.isRecordingPaused ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.play_arrow, color: Colors.white,),
                                onPressed: () async {
                                  HapticFeedback.lightImpact();
                                  await cameraController.resumeVideoRecording();
                                  if (context.mounted) setState(() {});
                                  // if (context.mounted) context.read<NewPostBloc>().add(NewPostPausedChanged(isPaused: false));
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
                                icon: Icon(Icons.pause, color: Colors.white,),
                                onPressed: () async {
                                  HapticFeedback.lightImpact();
                                  await cameraController.pauseVideoRecording();
                                  if (context.mounted) setState(() {});
                                  // if (context.mounted) context.read<NewPostBloc>().add(NewPostPausedChanged(isPaused: true));
                                },
                              ),
                            ),
                          ),
                          cameraController.value.isRecordingVideo ? Container(
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
                                  // context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: false));
                                  context.read<NewPostBloc>().add(NewPostVideoNoteChanged(videoNotePath: videoNoteFile));
                                  setState(() {});
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
                                if (context.mounted) setState(() {});
                                // if (context.mounted) context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: true));
                              },
                            ),
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
                                icon: Icon(Icons.close_sharp, color: Colors.white,),
                                onPressed: () async {
                                  HapticFeedback.lightImpact();
                                  if (cameraController.value.isRecordingVideo) {
                                    await cameraController.stopVideoRecording();
                                    if (context.mounted) setState(() {});
                                  }
                                  if (context.mounted) context.read<PostListBloc>().add(PostListRecordVideoNoteModeChanged(recordVideoNoteMode: false));
                                  cameraController.dispose();
                                },
                              ),
                            ),
                          ),
                          BlocBuilder<NewPostBloc, NewPostState>(
                            builder: (context, state) {
                              return ElevatedButton(
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
                                onPressed: (state.postCategories.isNotEmpty && (cameraController.value.isRecordingVideo || state.videoNotePath != "")) ? () async {
                                  HapticFeedback.lightImpact();
                                  if (cameraController.value.isRecordingVideo) {
                                    final videoNote = await cameraController.stopVideoRecording();
                                    final videoNoteFile = videoNote.path;
                                    if (context.mounted) {
                                      // context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: false));
                                      context.read<NewPostBloc>().add(NewPostVideoNoteChanged(videoNotePath: videoNoteFile));
                                      setState(() {});
                                    }
                                  }
                                  if (context.mounted) context.read<NewPostBloc>().add(NewPostVideoNoteCreated());
                                } : null,
                                child: Icon(
                                  Iconsax.send_2_copy,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ]
              // RecordingPostVideoNoteBarrier(),
              // RecordingPostVideoNoteForm(userId: widget.userId,),
            ]
          ),
        );
      },
    );
  }
}

// class RecordingPostVideoNoteBarrier extends StatelessWidget {
//   const RecordingPostVideoNoteBarrier({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NewPostBloc, NewPostState>(
//       builder: (context, state) {
//         return Visibility(
//           visible: state.recordVideoNoteModeStatus == RecordVideoNoteModeStatus.working,
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
//             child: Opacity(
//               opacity: 0.7,
//               child: ModalBarrier(dismissible: false, color: Colors.grey.shade300),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class RecordingPostVideoNoteForm extends StatefulWidget {
//   const RecordingPostVideoNoteForm({super.key, required this.userId});
//
//   final String userId;
//
//   @override
//   State<RecordingPostVideoNoteForm> createState() => _RecordingPostVideoNoteFormState();
// }
//
// class _RecordingPostVideoNoteFormState extends State<RecordingPostVideoNoteForm> with WidgetsBindingObserver {
//   late CameraController cameraController;
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera();
//   }
//
//   @override
//   void dispose() {
//     cameraController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (!cameraController.value.isInitialized) {
//       return;
//     }
//
//     if (state == AppLifecycleState.inactive) {
//       cameraController.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       await initCamera();
//     }
//   }
//
//   Future<void> initCamera() async {
//     final cameras = await availableCameras();
//     final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//     // final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
//     cameraController = CameraController(front, ResolutionPreset.max);
//     await cameraController.initialize();
//     // await cameraController.pausePreview();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<NewPostBloc, NewPostState>(
//       listener: (context, state) async {
//         if (state.recordVideoNoteModeStatus == RecordVideoNoteModeStatus.launching) {
//           // await cameraController.initialize();
//           if (context.mounted) context.read<NewPostBloc>().add(NewPostRecordVideoNoteModeStatusChanged(recordVideoNoteModeStatus: RecordVideoNoteModeStatus.working));
//         }
//         if (state.recordVideoNoteModeStatus == RecordVideoNoteModeStatus.stopping) {
//           if (cameraController.value.isRecordingVideo) {
//             await cameraController.stopVideoRecording();
//           }
//           // await cameraController.pausePreview();
//           if (context.mounted) context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: false));
//           cameraController.dispose();
//           if (context.mounted) context.read<NewPostBloc>().add(NewPostRecordVideoNoteModeStatusChanged(recordVideoNoteModeStatus: RecordVideoNoteModeStatus.initial));
//         }
//       },
//       builder: (context, state) {
//         return Visibility(
//           visible: state.recordVideoNoteModeStatus == RecordVideoNoteModeStatus.working,
//           child: Column(
//             children: [
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                   ),
//                   child: ClipOval(
//                     child: AspectRatio(
//                       aspectRatio: 1,
//                       child: CameraPreview(cameraController),
//                     ),
//                   ),
//                 ),
//               ),
//               Wrap(
//                 spacing: 10,
//                 children: [
//                   FilterChip(
//                     selectedColor: Colors.white,
//                     showCheckmark: false,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: state.postCategories.contains("Сімʼя") ? Colors.black : const Color(0xFFD9D9D9)),
//                     ),
//                     avatar: const CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: AssetImage("assets/chip_images/img.png"),
//                     ),
//                     label: const Text(
//                       textScaler: TextScaler.linear(1),
//                       "Сімʼя",
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     selected: state.postCategories.contains("Сімʼя"),
//                     onSelected: (newState) {
//                       if (newState) {
//                         context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Сімʼя"));
//                       }
//                       else {
//                         context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Сімʼя"));
//                       }
//                     },
//                   ),
//                   FilterChip(
//                     selectedColor: Colors.white,
//                     showCheckmark: false,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: state.postCategories.contains("Стиль") ? Colors.black : const Color(0xFFD9D9D9)),
//                     ),
//                     avatar: const CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: AssetImage("assets/chip_images/img_5.png"),
//                     ),
//                     label: const Text(
//                         textScaler: TextScaler.linear(1),
//                         overflow: TextOverflow.ellipsis,
//                         "Стиль"
//                     ),
//                     selected: state.postCategories.contains("Стиль"),
//                     onSelected: (newState) {
//                       if (newState) {
//                         context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Стиль"));
//                       }
//                       else {
//                         context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Стиль"));
//                       }
//                     },
//                   ),
//                   FilterChip(
//                     selectedColor: Colors.white,
//                     showCheckmark: false,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: state.postCategories.contains("Заробіток") ? Colors.black : const Color(0xFFD9D9D9)),
//                     ),
//                     avatar: const CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: AssetImage("assets/chip_images/img_1.png"),
//                     ),
//                     label: const Text(
//                         textScaler: TextScaler.linear(1),
//                         overflow: TextOverflow.ellipsis,
//                         "Заробіток"
//                     ),
//                     selected: state.postCategories.contains("Заробіток"),
//                     onSelected: (newState) {
//                       if (newState) {
//                         context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Заробіток"));
//                       }
//                       else {
//                         context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Заробіток"));
//                       }
//                     },
//                   ),
//                   FilterChip(
//                     selectedColor: Colors.white,
//                     showCheckmark: false,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: state.postCategories.contains("Правильне харчування") ? Colors.black : const Color(0xFFD9D9D9)),
//                     ),
//                     avatar: const CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: AssetImage("assets/chip_images/img_3.png"),
//                     ),
//                     label: const Text(
//                         textScaler: TextScaler.linear(1),
//                         overflow: TextOverflow.ellipsis,
//                         "Правильне харчування"
//                     ),
//                     selected: state.postCategories.contains("Правильне харчування"),
//                     onSelected: (newState) {
//                       if (newState) {
//                         context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Правильне харчування"));
//                       }
//                       else {
//                         context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Правильне харчування"));
//                       }
//                     },
//                   ),
//                   FilterChip(
//                     selectedColor: Colors.white,
//                     showCheckmark: false,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: state.postCategories.contains("Розвиток дітей") ? Colors.black : const Color(0xFFD9D9D9)),
//                     ),
//                     avatar: const CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: AssetImage("assets/chip_images/img_4.png"),
//                     ),
//                     label: const Text(
//                         textScaler: TextScaler.linear(1),
//                         overflow: TextOverflow.ellipsis,
//                         "Розвиток дітей"
//                     ),
//                     selected: state.postCategories.contains("Розвиток дітей"),
//                     onSelected: (newState) {
//                       if (newState) {
//                         context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Розвиток дітей"));
//                       }
//                       else {
//                         context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Розвиток дітей"));
//                       }
//                     },
//                   ),
//                   FilterChip(
//                     selectedColor: Colors.white,
//                     showCheckmark: false,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       side: BorderSide(color: state.postCategories.contains("Спорт і схуднення") ? Colors.black : const Color(0xFFD9D9D9)),
//                     ),
//                     avatar: const CircleAvatar(
//                       backgroundColor: Colors.transparent,
//                       backgroundImage: AssetImage("assets/chip_images/img_2.png"),
//                     ),
//                     label: const Text(
//                         textScaler: TextScaler.linear(1),
//                         overflow: TextOverflow.ellipsis,
//                         "Спорт і схуднення"
//                     ),
//                     selected: state.postCategories.contains("Спорт і схуднення"),
//                     onSelected: (newState) {
//                       if (newState) {
//                         context.read<NewPostBloc>().add(const NewPostCategoryAdded(postCategory: "Спорт і схуднення"));
//                       }
//                       else {
//                         context.read<NewPostBloc>().add(const NewPostCategoryRemoved(postCategory: "Спорт і схуднення"));
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: OverflowBar(
//                   alignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Visibility(
//                       visible: state.isRecording,
//                       child: state.isPaused ? Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.play_arrow),
//                           onPressed: () async {
//                             HapticFeedback.lightImpact();
//                             await cameraController.resumeVideoRecording();
//                             if (context.mounted) context.read<NewPostBloc>().add(NewPostPausedChanged(isPaused: false));
//                           },
//                         ),
//                       ) : Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.pause),
//                           onPressed: () async {
//                             HapticFeedback.lightImpact();
//                             await cameraController.pauseVideoRecording();
//                             if (context.mounted) context.read<NewPostBloc>().add(NewPostPausedChanged(isPaused: true));
//                           },
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: state.recordVideoNoteModeStatus == RecordVideoNoteModeStatus.working,
//                       child: state.isRecording ? Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.square_rounded),
//                           onPressed: () async {
//                             HapticFeedback.lightImpact();
//                             final videoNote = await cameraController.stopVideoRecording();
//                             final videoNoteFile = videoNote.path;
//                             if (context.mounted) {
//                               context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: false));
//                               context.read<NewPostBloc>().add(NewPostVideoNoteChanged(videoNote: videoNoteFile));
//                             }
//                           },
//                         ),
//                       ) : Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.circle, color: Colors.red,),
//                           onPressed: () async {
//                             HapticFeedback.lightImpact();
//                             await cameraController.prepareForVideoRecording();
//                             await cameraController.startVideoRecording();
//                             if (context.mounted) context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: true));
//                           },
//                         ),
//                       ),
//                     ),
//                     Visibility(
//                       visible: state.recordVideoNoteModeStatus == RecordVideoNoteModeStatus.working,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Color(0xFFD9D9D9),
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.close_sharp),
//                           onPressed: () async {
//                             HapticFeedback.lightImpact();
//                             context.read<NewPostBloc>().add(NewPostRecordVideoNoteModeStatusChanged(recordVideoNoteModeStatus: RecordVideoNoteModeStatus.stopping));
//                           },
//                         ),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ButtonStyle(
//                         padding: WidgetStateProperty.all(EdgeInsets.all(10)),
//                         shape: WidgetStateProperty.all(const CircleBorder()),
//                         iconColor: WidgetStateProperty.resolveWith<Color?>((states) {
//                           if (states.contains(WidgetState.pressed)) return Colors.black;
//                           return Colors.white;
//                         }),
//                         backgroundColor: WidgetStateProperty.all(Colors.black), // <-- Button color
//                         overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
//                           if (states.contains(WidgetState.pressed)) return Colors.white;
//                           return null;
//                         }),
//                       ),
//                       onPressed: (state.isRecording || state.videoNote != "") ? () async {
//                         HapticFeedback.lightImpact();
//                         if (cameraController.value.isRecordingVideo) {
//                           final videoNote = await cameraController.stopVideoRecording();
//                           final videoNoteFile = videoNote.path;
//                           if (context.mounted) {
//                             context.read<NewPostBloc>().add(NewPostRecordingChanged(isRecording: false));
//                             context.read<NewPostBloc>().add(NewPostVideoNoteChanged(videoNote: videoNoteFile));
//                           }
//                         }
//                         if (context.mounted) context.read<NewPostBloc>().add(NewPostVideoNoteCreated());
//                       } : null,
//                       child: Icon(
//                         Iconsax.send_2_copy,
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class CategoryFilterChip extends StatelessWidget {
//   const CategoryFilterChip({super.key, required this.categoryName, required this.categoryPhoto});
//
//   final String categoryName;
//   final String categoryPhoto;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NewPostBloc, NewPostState>(
//       builder: (context, state) {
//         return FilterChip(
//           selectedColor: Colors.white,
//           showCheckmark: false,
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: BorderSide(color: state.postCategories.contains(categoryName) ? Colors.black : const Color(0xFFD9D9D9)),
//           ),
//           avatar: CircleAvatar(
//             backgroundColor: Colors.transparent,
//             backgroundImage: AssetImage(categoryPhoto),
//           ),
//           label: Text(
//             textScaler: TextScaler.linear(1),
//             categoryName,
//             overflow: TextOverflow.ellipsis,
//           ),
//           selected: state.postCategories.contains(categoryName),
//           onSelected: (newState) {
//             if (newState) {
//               context.read<NewPostBloc>().add(NewPostCategoryAdded(postCategory: categoryName));
//             }
//             else {
//               context.read<NewPostBloc>().add(NewPostCategoryRemoved(postCategory: categoryName));
//             }
//             print(state.postCategories);
//           },
//         );
//       },
//     );
//   }
// }

class PostListTextItem extends StatelessWidget {
  const PostListTextItem({super.key, required this.postData, required this.userInfo, required this.showAds, required this.postId, required this.userId, required this.productList});

  final Map<String, dynamic> postData;
  final Map<String, dynamic> userInfo;
  final bool showAds;
  final String postId;
  final String userId;
  final List<Package> productList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // PersistentNavBarNavigator.pushNewScreen(
            //   context,
            //   screen: PostInfoPage(userInfo: userInfo, userId: userId, postId: id, productList: productList,),
            //   withNavBar: false,
            // );
            if (showAds && userInfo["role"] == "user") {
              context.read<PostListBloc>().add(PostListAdLoadingChanged());
              InterstitialAd.load(
                adUnitId: Platform.isAndroid ? androidAdsApiKey : iosAdsApiKey,
                request: const AdRequest(),
                adLoadCallback: InterstitialAdLoadCallback(
                  onAdLoaded: (InterstitialAd ad) {
                    ad.fullScreenContentCallback = FullScreenContentCallback(
                      onAdShowedFullScreenContent: (ad) {
                        context.read<PostListBloc>().add(PostListAdLoadingChanged());
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: PostInfoPage(userInfo: userInfo, userId: userId, postId: postId, productList: productList,),
                          withNavBar: false,
                        );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => PostInfoPage(userInfo: userInfo, userId: userId, postId: id,),
                        //   ),
                        // );
                      },
                      onAdImpression: (ad) {
                        // context.read<PostsBloc>().add(GetFullPostInfo(postId: id, userId: userId));
                      },
                      onAdFailedToShowFullScreenContent: (ad, err) {
                        ad.dispose();
                        context.read<PostListBloc>().add(PostListAdLoadingChanged());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.black,
                            content: Text(
                              "Помилка",
                            ),
                          ),
                        );
                      },
                      onAdDismissedFullScreenContent: (ad) {
                        ad.dispose();
                      },
                      onAdClicked: (ad) {},
                    );
                    ad.show();
                  },
                  onAdFailedToLoad: (LoadAdError error) {
                    // ignore: avoid_print
                    print('InterstitialAd failed to load: $error');
                  },
                ),
              );
            }
            else {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: PostInfoPage(userInfo: userInfo, userId: userId, postId: postId, productList: productList,),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => PostInfoPage(userInfo: userInfo, userId: userId, postId: id,),
              //   ),
              // );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              height: MediaQuery.of(context).size.height * 0.52,
              width: double.infinity,
              child: Stack(
                children: [
                  GridTile(
                    footer: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF585858).withValues(alpha: 0.6),
                            // color: Colors.black45,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.13793,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.035,
                              right: MediaQuery.of(context).size.width * 0.035,
                              top: MediaQuery.of(context).size.height * 0.007,
                              // bottom: MediaQuery.of(context).size.height * 0.015,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SvgPicture.asset(width: 12, height: 12, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 5,),
                                          ),
                                          TextSpan(
                                            text: postData["likedBy"].length.toString(),
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                              // height: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(width: 20, height: 20, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                                    //     const SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text(
                                    //       textScaler: TextScaler.linear(1),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //       data["likes"].toString(),
                                    //       style: TextStyle(
                                    //         fontFamily: "Inter",
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 12,
                                    //         // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                    //         // height: 18,
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    RichText(
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SvgPicture.asset(width: 12, height: 12, "assets/icons/Chat Round Dots.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 5,),
                                          ),
                                          TextSpan(
                                            text: postData["comments"].toString(),
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                              // height: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(width: 20, height: 20, "assets/icons/Chat Round Dots.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                    //     const SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text(
                                    //       textScaler: TextScaler.linear(1),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //       data["comments"].toString(),
                                    //       style: TextStyle(
                                    //         fontFamily: "Inter",
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 12,
                                    //         // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                    //         // height: 18,
                                    //       ),
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                ),
                                Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  postData["title"],
                                  // maxLines: 2,
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                    // height: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // child: Image.asset(
                    //   fit: BoxFit.cover,
                    //   "assets/ModalBottomSheetPicture.png"
                    // ),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: postData["image"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF636363).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.height * 0.023,
                                    backgroundImage: NetworkImage(
                                      state.adminInfo["avatar"],
                                    ),
                                  ),
                                ),
                                Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  state.adminInfo["name"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class PostListVideoItem extends StatelessWidget {
  const PostListVideoItem({super.key, required this.postData, required this.userInfo, required this.showAds, required this.postId, required this.userId, required this.productList});

  final Map<String, dynamic> postData;
  final Map<String, dynamic> userInfo;
  final bool showAds;
  final String postId;
  final String userId;
  final List<Package> productList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostListBloc, PostListState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            // PersistentNavBarNavigator.pushNewScreen(
            //   context,
            //   screen: PostInfoPage(userInfo: userInfo, userId: userId, postId: id, productList: productList,),
            //   withNavBar: false,
            // );
            if (showAds && userInfo["role"] == "user") {
              context.read<PostListBloc>().add(PostListAdLoadingChanged());
              InterstitialAd.load(
                adUnitId: Platform.isAndroid ? androidAdsApiKey : iosAdsApiKey,
                request: const AdRequest(),
                adLoadCallback: InterstitialAdLoadCallback(
                  onAdLoaded: (InterstitialAd ad) {
                    ad.fullScreenContentCallback = FullScreenContentCallback(
                      onAdShowedFullScreenContent: (ad) {
                        context.read<PostListBloc>().add(PostListAdLoadingChanged());
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: PostVideoInfoPage(userInfo: userInfo, userId: userId, postId: postId, productList: productList,),
                          withNavBar: false,
                        );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => PostInfoPage(userInfo: userInfo, userId: userId, postId: id,),
                        //   ),
                        // );
                      },
                      onAdImpression: (ad) {
                        // context.read<PostsBloc>().add(GetFullPostInfo(postId: id, userId: userId));
                      },
                      onAdFailedToShowFullScreenContent: (ad, err) {
                        ad.dispose();
                        context.read<PostListBloc>().add(PostListAdLoadingChanged());
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.black,
                            content: Text(
                              "Помилка",
                            ),
                          ),
                        );
                      },
                      onAdDismissedFullScreenContent: (ad) {
                        ad.dispose();
                      },
                      onAdClicked: (ad) {},
                    );
                    ad.show();
                  },
                  onAdFailedToLoad: (LoadAdError error) {
                    // ignore: avoid_print
                    print('InterstitialAd failed to load: $error');
                  },
                ),
              );
            }
            else {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: PostVideoInfoPage(userInfo: userInfo, userId: userId, postId: postId, productList: productList,),
                withNavBar: false,
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => PostInfoPage(userInfo: userInfo, userId: userId, postId: id,),
              //   ),
              // );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              height: MediaQuery.of(context).size.height * 0.52,
              width: double.infinity,
              child: Stack(
                children: [
                  GridTile(
                    footer: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF585858).withValues(alpha: 0.6),
                            // color: Colors.black45,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.13793,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.035,
                              right: MediaQuery.of(context).size.width * 0.035,
                              top: MediaQuery.of(context).size.height * 0.007,
                              // bottom: MediaQuery.of(context).size.height * 0.015,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SvgPicture.asset(width: 12, height: 12, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 5,),
                                          ),
                                          TextSpan(
                                            text: postData["likedBy"].length.toString(),
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                              // height: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(width: 20, height: 20, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),),
                                    //     const SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text(
                                    //       textScaler: TextScaler.linear(1),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //       data["likedBy"].length.toString(),
                                    //       style: TextStyle(
                                    //         fontFamily: "Inter",
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 12,
                                    //         // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                    //         // height: 18,
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    RichText(
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: SvgPicture.asset(width: 12, height: 12, "assets/icons/Chat Round Dots.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 5,),
                                          ),
                                          TextSpan(
                                            text: postData["comments"].toString(),
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                              // height: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     SvgPicture.asset(width: 20, height: 20, "assets/icons/Chat Round Dots.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                    //     const SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text(
                                    //       textScaler: TextScaler.linear(1),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis,
                                    //       data["comments"].toString(),
                                    //       style: TextStyle(
                                    //         fontFamily: "Inter",
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 12,
                                    //         // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                    //         // height: 18,
                                    //       ),
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                ),
                                Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  postData["title"],
                                  // maxLines: 2,
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                    // height: 2,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.play_arrow
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 5,),
                                      ),
                                      TextSpan(
                                        text: postData["video duration"],
                                      )
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // child: Image.asset(
                    //   fit: BoxFit.cover,
                    //   "assets/ModalBottomSheetPicture.png"
                    // ),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: postData["video thumbnail"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF636363).withValues(alpha: 0.3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(60),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    radius: MediaQuery.of(context).size.height * 0.023,
                                    backgroundImage: NetworkImage(
                                      state.adminInfo["avatar"],
                                    ),
                                  ),
                                ),
                                Text(
                                  textScaler: TextScaler.linear(1),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  state.adminInfo["name"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class VideoNoteCategoryChips extends StatelessWidget {
  VideoNoteCategoryChips({super.key});

  final Map<String, String> categories = <String, String>{
    "Сімʼя": "assets/chip_images/img.png",
    "Стиль": "assets/chip_images/img_5.png",
    "Заробіток": "assets/chip_images/img_1.png",
    "Правильне харчування": "assets/chip_images/img_3.png",
    "Розвиток дітей": "assets/chip_images/img_4.png",
    "Спорт і схуднення": "assets/chip_images/img_2.png",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostBloc, NewPostState>(
      builder: (context, state) {
        return Wrap(
          spacing: 10,
          children: categories.keys.map((categoryName) {
            return FilterChip(
              selectedColor: Colors.white,
              showCheckmark: false,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: state.postCategories.contains(categoryName) ? Color(0xFFFF0022) : const Color(0xFFD9D9D9)),
              ),
              avatar: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(categories[categoryName]!),
              ),
              label: Text(
                textScaler: TextScaler.linear(1),
                categoryName,
                overflow: TextOverflow.ellipsis,
              ),
              selected: state.postCategories.contains(categoryName),
              onSelected: (newState) {
                if (newState) {
                  context.read<NewPostBloc>().add(NewPostCategoryAdded(postCategory: categoryName));
                }
                else {
                  context.read<NewPostBloc>().add(NewPostCategoryRemoved(postCategory: categoryName));
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class PostVideoNoteItem extends StatefulWidget {
  const PostVideoNoteItem({super.key, required this.url, required this.userId, required this.postId, required this.likes, required this.isAdmin});

  final String url;
  final String userId;
  final String postId;
  final List<dynamic> likes;
  final bool isAdmin;

  @override
  State<PostVideoNoteItem> createState() => _PostVideoNoteItemState();
}

class _PostVideoNoteItemState extends State<PostVideoNoteItem> {
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
    return BlocConsumer<PostListBloc, PostListState>(
      listenWhen: (previous, current) => previous.selectedVideoNote != current.selectedVideoNote,
      listener: (context, state) async {
        if (state.selectedVideoNote == widget.postId) {
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
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    context.read<PostListBloc>().add(PostListVideoNotePressed(videoNoteId: widget.postId));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                    child: ClipOval(child: VideoPlayer(controller)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: PostVideoNoteLikeButton(likes: widget.likes, userId: widget.userId, postId: widget.postId,),
              ),
              Align(
                alignment: Alignment.topRight,
                child: PostVideoNoteDeleteButton(postId: widget.postId, isAdmin: widget.isAdmin,),
              ),
            ]
          ),
        );
      },
    );
  }
}

class PostVideoNoteLikeButton extends StatelessWidget {
  const PostVideoNoteLikeButton({super.key, required this.likes, required this.userId, required this.postId});

  final String userId;
  final String postId;
  final List<dynamic> likes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (likes.contains(userId)) {
          context.read<PostListBloc>().add(PostListVideoNoteLikeCanceled(videoNoteId: postId, userId: userId,));
        }
        else {
          context.read<PostListBloc>().add(PostListVideoNoteLikeSet(videoNoteId: postId, userId: userId,));
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 15,
        ),
        width: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            likes.contains(userId) ? SvgPicture.asset(width: 23, height: 23, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 23, height: 23, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            Text(
              likes.length.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostVideoNoteDeleteButton extends StatelessWidget {
  const PostVideoNoteDeleteButton({super.key, required this.postId, required this.isAdmin});

  final String postId;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isAdmin,
      child: Container(
        margin: EdgeInsets.only(
          right: 15,
        ),
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF636363).withValues(alpha: 0.5),
        ),
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Iconsax.note_remove_copy, size: 30,),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.read<PostListBloc>().add(PostListVideoNoteDeleted(videoNoteId: postId));
          },
        ),
      ),
    );
  }
}

