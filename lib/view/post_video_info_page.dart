import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lyudashollywooda/post_info/post_info_bloc.dart';
import 'package:lyudashollywooda/view/subscription_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:video_player/video_player.dart';
import 'donate_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

// class PostInfoPage extends StatelessWidget {
//   const PostInfoPage({super.key, required this.userInfo, required this.userId, required this.postId});
//
//   final Map<String, dynamic> userInfo;
//   final String userId;
//   final String postId;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PostInfoBloc()..add(GetFullPostInfo(postId: postId, userId: userId, )),
//       child: PostInfoForm(userId: userId, userInfo: userInfo,),
//     );
//   }
// }


class PostVideoInfoPage extends StatefulWidget {
  const PostVideoInfoPage({super.key, required this.userId, required this.userInfo, required this.postId, required this.productList});

  final String userId;
  final Map<String, dynamic> userInfo;
  final String postId;
  final List<Package> productList;

  @override
  State<PostVideoInfoPage> createState() => _PostVideoInfoPageState();
}

class _PostVideoInfoPageState extends State<PostVideoInfoPage> {
  final TextEditingController commentTextFieldController = TextEditingController();

  late FocusNode commentFocusNode;
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    commentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    commentFocusNode.dispose();
    flickManager.dispose();
    super.dispose();
  }

  final Map<String, String> categoriesImages = <String, String>{
    "Сімʼя": "assets/chip_images/img.png",
    "Правильне харчування": "assets/chip_images/img_3.png",
    "Спорт і схуднення": "assets/chip_images/img_2.png",
    "Заробіток": "assets/chip_images/img_1.png",
    "Розвиток дітей": "assets/chip_images/img_4.png",
    "Стиль": "assets/chip_images/img_5.png",
  };

  Stream<DocumentSnapshot> getUserInfo(String userID) {
    DocumentReference userDocument = FirebaseFirestore.instance.collection("Users").doc(userID);
    Stream<DocumentSnapshot> snapshot = userDocument.snapshots();

    return snapshot;

    // if (snapshot) {
    //   return snapshot.data() as Map<String, dynamic>;
    // } else {
    //   throw Exception('Document does not exist');
    // }
  }

  Stream<QuerySnapshot> getReplies(String postID, String commentID) {
    final Stream<QuerySnapshot> repliesSnapshot = FirebaseFirestore.instance.collection("Posts").doc(postID).collection("Comments").doc(commentID).collection("Replies").orderBy('time', descending: true).snapshots();
    return repliesSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostInfoBloc()..add(PostInfoFetched(postId: widget.postId, userId: widget.userId, )),
      child: BlocListener<PostInfoBloc, PostInfoState>(
        listenWhen: (previous, current) => previous.deletionStatus != current.deletionStatus,
        listener: (context, state) {
          if (state.deletionStatus == DeletionStatus.failure) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.white,
                contentPadding: const EdgeInsets.all(10),
                content: Text("Сталася помилка"),
                actions: [
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Text(
                      textScaler: TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "Закрити",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black,
                        // fontSize: MediaQuery.textScalerOf(context).scale(12)
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (state.deletionStatus == DeletionStatus.success) {
            Navigator.of(context).pop();
          }
        },
        child: BlocBuilder<PostInfoBloc, PostInfoState>(
          builder: (context, state) {
            return ModalProgressHUD(
              inAsyncCall: state.deletionStatus == DeletionStatus.inProgress,
              child: Scaffold(
                extendBody: true,
                // resizeToAvoidBottomInset: false,
                // extendBody: true,
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        // margin: EdgeInsets.only(
                        //   left: 10,
                        //   right: 10,
                        // ),
                        height: MediaQuery.of(context).size.height * 0.08374,
                        decoration: BoxDecoration(
                          color: Color(0xFF585858).withValues(alpha: 0.7),
                          // color: Color(0xFF585858).withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: state.postInfo,
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data = snapshot.data!.data()! as Map<String, dynamic>;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    textScaler: TextScaler.linear(1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: IconButton(
                                            icon: data["likedBy"].contains(widget.userId) ? SvgPicture.asset(width: 20, height: 20, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 24, height: 24, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                            // Icon(Icons.favorite_border_outlined, color: state.likedBy.contains(userId) ? Colors.red : Colors.white,),
                                            onPressed: () {
                                              HapticFeedback.lightImpact();
                                              if (data["likedBy"].contains(widget.userId)) {
                                                context.read<PostInfoBloc>().add(PostInfoLikeCanceled(postID: state.id, userID: widget.userId,));
                                              }
                                              else {
                                                context.read<PostInfoBloc>().add(PostInfoLikeSet(postID: state.id, userID: widget.userId,));
                                              }
                                            },
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: const SizedBox(
                                            width: 5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: data["likedBy"].length.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Inter",
                                            color: Colors.white
                                          ),
                                        )
                                      ]
                                    ),
                                  ),
                                  //     const SizedBox(
                                  //       width: 15,
                                  //     ),
                                  //     Row(
                                  //       // mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         IconButton(
                                  //           icon: SvgPicture.asset(width: 24, height: 24, "assets/icons/Chat Round Dots.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                                  //           onPressed: () {
                                  //             HapticFeedback.lightImpact();
                                  //             showModalBottomSheet(
                                  //               backgroundColor: Colors.white,
                                  //               context: context,
                                  //               isScrollControlled: true,
                                  //               isDismissible: true,
                                  //               shape: const RoundedRectangleBorder(
                                  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                                  //               ),
                                  //               builder: (context) => BlocProvider.value(
                                  //                 value: cont,
                                  //                 child: BlocBuilder<PostInfoBloc, PostInfoState>(
                                  //                 builder: (context, state) {
                                  //                 return DraggableScrollableSheet(
                                  //                 initialChildSize: 0.9,
                                  //                 // minChildSize: 0.2,
                                  //                 maxChildSize: 0.9,
                                  //                 expand: false,
                                  //                 builder: (context, scrollController) => SafeArea(
                                  //                   child: Column(
                                  //                     children: [
                                  //                       Container(
                                  //                         margin: EdgeInsets.only(
                                  //                           bottom: 10,
                                  //                         ),
                                  //                         height: MediaQuery.of(context).size.height * 0.09,
                                  //                         width: double.infinity,
                                  //                         decoration: BoxDecoration(
                                  //                           border: Border(
                                  //                             bottom: BorderSide(
                                  //                               color: Color(0xFFD9D9D9),
                                  //                             )
                                  //                           )
                                  //                         ),
                                  //                         child: Center(
                                  //                           child: Text(
                                  //                             textScaler: TextScaler.linear(1),
                                  //                             maxLines: 1,
                                  //                             overflow: TextOverflow.ellipsis,
                                  //                             "Коментарі",
                                  //                             style: TextStyle(
                                  //                               fontFamily: "Inter",
                                  //                               color: Color(0xFF212121),
                                  //                               fontSize: 16,
                                  //                               // fontSize: MediaQuery.textScalerOf(context).scale(16),
                                  //                               fontWeight: FontWeight.w500,
                                  //                             ),
                                  //                           ),
                                  //                         ),
                                  //                       ),
                                  //                       // const Divider(
                                  //                       //   color: Color(0xFFD9D9D9),
                                  //                       // ),
                                  //                       Expanded(
                                  //                         child: StreamBuilder<QuerySnapshot>(
                                  //                           stream: state.commentsSnapshots,
                                  //                           // stream: state.commentsSnapshots,
                                  //                           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  //                             if (snapshot.hasError) {
                                  //                               return const Text(
                                  //                                   textScaler: TextScaler.linear(1),
                                  //                                   maxLines: 1,
                                  //                                   overflow: TextOverflow.ellipsis,
                                  //                                   'Помилка'
                                  //                               );
                                  //                             }
                                  //
                                  //                             if (snapshot.connectionState == ConnectionState.waiting) {
                                  //                               return const Text(
                                  //                                   textScaler: TextScaler.linear(1),
                                  //                                   maxLines: 1,
                                  //                                   overflow: TextOverflow.ellipsis,
                                  //                                   "Завантаження"
                                  //                               );
                                  //                             }
                                  //                             if (snapshot.hasData) {
                                  //                               return ListView.builder(
                                  //                                   controller: scrollController,
                                  //                                   itemCount: snapshot.data!.docs.length,
                                  //                                   // separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,),
                                  //                                   itemBuilder: (BuildContext context, int index) {
                                  //                                     String commentID = snapshot.data!.docs[index].id;
                                  //                                     Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
                                  //                                     final fetchedUser = getUserInfo(data["user"]);
                                  //                                     String commentTime = data["time"] != null ? DateFormat("dd.MM.yy HH:mm").format(data["time"].toDate()) : "";
                                  //                                     final replies = getReplies(state.id, commentID);
                                  //                                     // Timestamp commentTimestamp = data["time"];
                                  //                                     // DateTime commentDatetime = commentTimestamp.toDate();
                                  //                                     return Column(
                                  //                                       // crossAxisAlignment: CrossAxisAlignment.start,
                                  //                                       children: [
                                  //                                         // ----------------
                                  //                                         Padding(
                                  //                                           padding: EdgeInsets.only(
                                  //                                             left: MediaQuery.of(context).size.width * 0.05,
                                  //                                             bottom: 10,
                                  //                                           ),
                                  //                                           child: Row(
                                  //                                             crossAxisAlignment: CrossAxisAlignment.start,
                                  //                                             children: [
                                  //                                               StreamBuilder<DocumentSnapshot>(
                                  //                                                   stream: fetchedUser,
                                  //                                                   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                                  //                                                     if (userSnapshot.hasError) {
                                  //                                                       return const Text(
                                  //                                                           textScaler: TextScaler.linear(1),
                                  //                                                           maxLines: 1,
                                  //                                                           overflow: TextOverflow.ellipsis,
                                  //                                                           "Error"
                                  //                                                       );
                                  //                                                     }
                                  //
                                  //                                                     if (userSnapshot.connectionState == ConnectionState.waiting) {
                                  //                                                       return CircularProgressIndicator();
                                  //                                                     }
                                  //
                                  //                                                     if (userSnapshot.hasData) {
                                  //                                                       return CircleAvatar(
                                  //                                                         backgroundImage: NetworkImage(userSnapshot.data!["avatar"]),
                                  //                                                       );
                                  //                                                     }
                                  //                                                     return const Text(
                                  //                                                         textScaler: TextScaler.linear(1),
                                  //                                                         maxLines: 1,
                                  //                                                         overflow: TextOverflow.ellipsis,
                                  //                                                         "Немає даних"
                                  //                                                     );
                                  //                                                   }
                                  //                                               ),
                                  //                                               SizedBox(
                                  //                                                 width: 15,
                                  //                                               ),
                                  //                                               Flexible(
                                  //                                                 child: Padding(
                                  //                                                   padding: const EdgeInsets.only(
                                  //                                                     top: 13,
                                  //                                                     right: 10,
                                  //                                                   ),
                                  //                                                   child: Column(
                                  //                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                  //                                                     children: [
                                  //                                                       StreamBuilder<DocumentSnapshot>(
                                  //                                                           stream: fetchedUser,
                                  //                                                           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                                  //                                                             if (userSnapshot.hasError) {
                                  //                                                               return const Text(
                                  //                                                                   textScaler: TextScaler.linear(1),
                                  //                                                                   maxLines: 1,
                                  //                                                                   overflow: TextOverflow.ellipsis,
                                  //                                                                   "Помилка"
                                  //                                                               );
                                  //                                                             }
                                  //
                                  //                                                             if (userSnapshot.connectionState == ConnectionState.waiting) {
                                  //                                                               return const Text(
                                  //                                                                   textScaler: TextScaler.linear(1),
                                  //                                                                   maxLines: 1,
                                  //                                                                   overflow: TextOverflow.ellipsis,
                                  //                                                                   "Завантаження"
                                  //                                                               );
                                  //                                                             }
                                  //
                                  //                                                             if (userSnapshot.hasData) {
                                  //                                                               return Text(
                                  //                                                                   style: TextStyle(
                                  //                                                                       fontFamily: "Inter",
                                  //                                                                       fontWeight: FontWeight.w600,
                                  //                                                                       fontSize: 14,
                                  //                                                                       color: Colors.black,
                                  //                                                                   ),
                                  //                                                                   textScaler: TextScaler.linear(1),
                                  //                                                                   userSnapshot.data!["name"]
                                  //                                                               );
                                  //                                                             }
                                  //                                                             return const Text(
                                  //                                                                 textScaler: TextScaler.linear(1),
                                  //                                                                 maxLines: 1,
                                  //                                                                 overflow: TextOverflow.ellipsis,
                                  //                                                                 "Немає даних"
                                  //                                                             );
                                  //                                                           }
                                  //                                                       ),
                                  //                                                       SizedBox(
                                  //                                                         height: 8,
                                  //                                                       ),
                                  //                                                       Text(
                                  //                                                         textScaler: TextScaler.linear(1),
                                  //                                                         data["comment"],
                                  //                                                         style: TextStyle(
                                  //                                                             fontFamily: "Inter",
                                  //                                                             fontWeight: FontWeight.w400,
                                  //                                                             fontSize: 14,
                                  //                                                             color: Color(0xFF212121)
                                  //                                                         ),
                                  //                                                       ),
                                  //                                                       Row(
                                  //                                                         mainAxisAlignment: MainAxisAlignment.start,
                                  //                                                         // crossAxisAlignment: CrossAxisAlignment.start,
                                  //                                                         mainAxisSize: MainAxisSize.min,
                                  //                                                         children: [
                                  //                                                           GestureDetector(
                                  //                                                             onTap: () {
                                  //                                                               HapticFeedback.lightImpact();
                                  //                                                               if (data["likedBy"].contains(widget.userId)) {
                                  //                                                                 context.read<PostInfoBloc>().add(CancelCommentLike(postID: state.id, commentID: commentID, userID: widget.userId,));
                                  //                                                               }
                                  //                                                               else {
                                  //                                                                 context.read<PostInfoBloc>().add(SetCommentLike(postID: state.id, commentID: commentID, userID: widget.userId,));
                                  //                                                               }
                                  //                                                             },
                                  //                                                             child: data["likedBy"].contains(widget.userId) ? SvgPicture.asset(width: 16, height: 16, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 16, height: 16, "assets/icons/Heart.svg"),
                                  //                                                             // Icon(
                                  //                                                             //   Icons.favorite_outlined,
                                  //                                                             //   size: 20,
                                  //                                                             //   color: data["likedBy"].contains(userId) ? Colors.red : Color(0xFF7B7B7B),
                                  //                                                             //   // state.likedBy.contains(userId) ? SvgPicture.asset(width: 30, height: 30, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 30, height: 30, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn))
                                  //                                                             // ),
                                  //                                                           ),
                                  //                                                           SizedBox(
                                  //                                                             width: 12,
                                  //                                                           ),
                                  //                                                           Text(
                                  //                                                             textScaler: TextScaler.linear(1),
                                  //                                                             maxLines: 1,
                                  //                                                             overflow: TextOverflow.ellipsis,
                                  //                                                             data["likes"] < 0 ? "0" : data["likes"].toString(),
                                  //                                                             style: TextStyle(
                                  //                                                               fontFamily: "Inter",
                                  //                                                               color: Color(0xFF7B7B7B),
                                  //                                                               fontWeight: FontWeight.w500,
                                  //                                                               fontSize: 12,
                                  //                                                               // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                               // height: 18,
                                  //                                                             ),
                                  //                                                           ),
                                  //                                                           SizedBox(
                                  //                                                             width: 12,
                                  //                                                           ),
                                  //                                                           // TextButton.icon(
                                  //                                                           //   icon: Icon(Icons.favorite_outlined, color: data["likedBy"].contains(userId) ? Colors.red : Colors.grey,),
                                  //                                                           //   onPressed: () {
                                  //                                                           //     if (data["likedBy"].contains(userId)) {
                                  //                                                           //       context.read<PostInfoBloc>().add(CancelCommentLike(postID: state.id, commentID: commentID, userID: userId,));
                                  //                                                           //     }
                                  //                                                           //     else {
                                  //                                                           //       context.read<PostInfoBloc>().add(SetCommentLike(postID: state.id, commentID: commentID, userID: userId,));
                                  //                                                           //     }
                                  //                                                           //   },
                                  //                                                           //   label: Text(
                                  //                                                           //     textScaler: TextScaler.linear(1),
                                  //                                                           //     maxLines: 1,
                                  //                                                           //     overflow: TextOverflow.ellipsis,
                                  //                                                           //     data["likes"] < 0 ? "0" : data["likes"].toString(),
                                  //                                                           //     style: TextStyle(
                                  //                                                           //       fontFamily: "Inter",
                                  //                                                           //       color: Colors.black,
                                  //                                                           //       fontWeight: FontWeight.w400,
                                  //                                                           //       fontSize: 12,
                                  //                                                           //       // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                           //       // height: 18,
                                  //                                                           //     ),
                                  //                                                           //   ),
                                  //                                                           // ),
                                  //                                                           Text(
                                  //                                                             textScaler: TextScaler.linear(1),
                                  //                                                             maxLines: 1,
                                  //                                                             overflow: TextOverflow.ellipsis,
                                  //                                                             commentTime,
                                  //                                                             style: TextStyle(
                                  //                                                               fontFamily: "Inter",
                                  //                                                               color: Color(0xFF7B7B7B),
                                  //                                                               fontWeight: FontWeight.w500,
                                  //                                                               fontSize: 12,
                                  //                                                               // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                               // height: 18,
                                  //                                                             ),
                                  //                                                           ),
                                  //                                                           (state.isReply && state.replyCommentId == commentID) ? TextButton.icon(
                                  //                                                             onPressed: () {
                                  //                                                               HapticFeedback.lightImpact();
                                  //                                                               context.read<PostInfoBloc>().add(const CancelReply());
                                  //                                                               commentFocusNode.unfocus();
                                  //                                                             },
                                  //                                                             icon: const Icon(Icons.close, color: Color(0xFF7B7B7B), size: 20,),
                                  //                                                             label: const Text(
                                  //                                                               textScaler: TextScaler.linear(1),
                                  //                                                               'Скасувати',
                                  //                                                               maxLines: 1,
                                  //                                                               overflow: TextOverflow.ellipsis,
                                  //                                                               style: TextStyle(
                                  //                                                                 fontFamily: "Inter",
                                  //                                                                 color: Color(0xFF7B7B7B),
                                  //                                                                 fontWeight: FontWeight.w500,
                                  //                                                                 fontSize: 12,
                                  //                                                                 // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                 // height: 18,
                                  //                                                               ),
                                  //                                                             ),
                                  //                                                             iconAlignment: IconAlignment.start,
                                  //                                                           ) : TextButton.icon(
                                  //                                                             onPressed: () {
                                  //                                                               HapticFeedback.lightImpact();
                                  //                                                               context.read<PostInfoBloc>().add(SetReply(commentId: commentID));
                                  //                                                               commentFocusNode.requestFocus();
                                  //                                                               // FocusScope.of(context).requestFocus(commentFocusNode);
                                  //                                                             },
                                  //                                                             icon: SvgPicture.asset("assets/icons/Forward.svg", width: 20, height: 20,),
                                  //                                                             label: const Text(
                                  //                                                               textScaler: TextScaler.linear(1),
                                  //                                                               'Відповісти',
                                  //                                                               maxLines: 1,
                                  //                                                               overflow: TextOverflow.ellipsis,
                                  //                                                               style: TextStyle(
                                  //                                                                 fontFamily: "Inter",
                                  //                                                                 color: Color(0xFF7B7B7B),
                                  //                                                                 fontWeight: FontWeight.w500,
                                  //                                                                 fontSize: 12,
                                  //                                                                 // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                 // height: 18,
                                  //                                                               ),
                                  //                                                             ),
                                  //                                                             iconAlignment: IconAlignment.start,
                                  //                                                           ),
                                  //                                                           // ReplyButton(commentID: commentID,),
                                  //                                                         ],
                                  //                                                       )
                                  //                                                     ],
                                  //                                                   ),
                                  //                                                 ),
                                  //                                               )
                                  //                                             ],
                                  //                                           ),
                                  //                                         ),
                                  //                                         // ----------------
                                  //                                         StreamBuilder<QuerySnapshot>(
                                  //                                           stream: replies,
                                  //                                           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> replySnapshot) {
                                  //                                             if (replySnapshot.hasError) {
                                  //                                               return Container();
                                  //                                               // return const Text(
                                  //                                               //     textScaler: TextScaler.linear(1),
                                  //                                               //     maxLines: 1,
                                  //                                               //     overflow: TextOverflow.ellipsis,
                                  //                                               //     'Помилка'
                                  //                                               // );
                                  //                                             }
                                  //
                                  //                                             if (replySnapshot.connectionState == ConnectionState.waiting) {
                                  //                                               return Container();
                                  //                                               // return const Text(
                                  //                                               //     textScaler: TextScaler.linear(1),
                                  //                                               //     maxLines: 1,
                                  //                                               //     overflow: TextOverflow.ellipsis,
                                  //                                               //     "Завантаження"
                                  //                                               // );
                                  //                                             }
                                  //                                             if (replySnapshot.hasData) {
                                  //                                               return ListView.builder(
                                  //                                                   shrinkWrap: true,
                                  //                                                   physics: const ClampingScrollPhysics(),
                                  //                                                   itemCount: replySnapshot.data!.docs.length,
                                  //                                                   // separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,),
                                  //                                                   itemBuilder: (context, index) {
                                  //                                                     String replyCommentID = replySnapshot.data!.docs[index].id;
                                  //                                                     Map<String, dynamic> replyData = replySnapshot.data!.docs[index].data()! as Map<String, dynamic>;
                                  //                                                     final replyFetchedUser = getUserInfo(replyData["user"]);
                                  //                                                     String replyTime = DateFormat("dd.MM.yy HH:mm").format(replyData["time"].toDate());
                                  //                                                     // Timestamp replyCommentTimestamp = data["time"];
                                  //                                                     // DateTime replyCommentDatetime = replyCommentTimestamp.toDate();
                                  //                                                     return Padding(
                                  //                                                       padding: EdgeInsets.only(
                                  //                                                         left: MediaQuery.of(context).size.width * 0.17,
                                  //                                                         bottom: 15
                                  //                                                       ),
                                  //                                                       child: Row(
                                  //                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                  //                                                         children: [
                                  //                                                           StreamBuilder<DocumentSnapshot>(
                                  //                                                               stream: replyFetchedUser,
                                  //                                                               builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> replyUserSnapshot) {
                                  //                                                                 if (replyUserSnapshot.hasError) {
                                  //                                                                   return Container();
                                  //                                                                   // return const Text(
                                  //                                                                   //     textScaler: TextScaler.linear(1),
                                  //                                                                   //     maxLines: 1,
                                  //                                                                   //     overflow: TextOverflow.ellipsis,
                                  //                                                                   //     "Помилка"
                                  //                                                                   // );
                                  //                                                                 }
                                  //
                                  //                                                                 if (replyUserSnapshot.connectionState == ConnectionState.waiting) {
                                  //                                                                   return Container();
                                  //                                                                   // return const Text(
                                  //                                                                   //     textScaler: TextScaler.linear(1),
                                  //                                                                   //     maxLines: 1,
                                  //                                                                   //     overflow: TextOverflow.ellipsis,
                                  //                                                                   //     "Завантаження"
                                  //                                                                   // );
                                  //                                                                 }
                                  //
                                  //                                                                 if (replyUserSnapshot.hasData) {
                                  //                                                                   return CircleAvatar(
                                  //                                                                     backgroundImage: NetworkImage(replyUserSnapshot.data!["avatar"]),
                                  //                                                                   );
                                  //                                                                 }
                                  //                                                                 return Container();
                                  //                                                               }
                                  //                                                           ),
                                  //                                                           SizedBox(
                                  //                                                             width: 15,
                                  //                                                           ),
                                  //                                                           Flexible(
                                  //                                                             child: Padding(
                                  //                                                               padding: const EdgeInsets.only(
                                  //                                                                 top: 13,
                                  //                                                                 right: 10,
                                  //                                                               ),
                                  //                                                               child: Column(
                                  //                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                  //                                                                 children: [
                                  //                                                                   StreamBuilder<DocumentSnapshot>(
                                  //                                                                       stream: replyFetchedUser,
                                  //                                                                       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> replyUserSnapshot) {
                                  //                                                                         if (replyUserSnapshot.hasError) {
                                  //                                                                           return const Text(
                                  //                                                                               textScaler: TextScaler.linear(1),
                                  //                                                                               maxLines: 1,
                                  //                                                                               overflow: TextOverflow.ellipsis,
                                  //                                                                               "Error"
                                  //                                                                           );
                                  //                                                                         }
                                  //
                                  //                                                                         if (replyUserSnapshot.connectionState == ConnectionState.waiting) {
                                  //                                                                           return const Text(
                                  //                                                                               textScaler: TextScaler.linear(1),
                                  //                                                                               maxLines: 1,
                                  //                                                                               overflow: TextOverflow.ellipsis,
                                  //                                                                               "Завантаження"
                                  //                                                                           );
                                  //                                                                         }
                                  //
                                  //                                                                         if (replyUserSnapshot.hasData) {
                                  //                                                                           return Text(
                                  //                                                                               textScaler: TextScaler.linear(1),
                                  //                                                                               replyUserSnapshot.data!["name"],
                                  //                                                                               style: TextStyle(
                                  //                                                                                 fontFamily: "Inter",
                                  //                                                                                 color: Colors.black,
                                  //                                                                                 fontWeight: FontWeight.w600,
                                  //                                                                                 fontSize: 14,
                                  //                                                                                 // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                                 // height: 18,
                                  //                                                                               ),
                                  //                                                                           );
                                  //                                                                         }
                                  //                                                                         return const Text(
                                  //                                                                             textScaler: TextScaler.linear(1),
                                  //                                                                             maxLines: 1,
                                  //                                                                             overflow: TextOverflow.ellipsis,
                                  //                                                                             "No Data"
                                  //                                                                         );
                                  //                                                                       }
                                  //                                                                   ),
                                  //                                                                   SizedBox(
                                  //                                                                     height: 8,
                                  //                                                                   ),
                                  //                                                                   Text(
                                  //                                                                     textScaler: TextScaler.linear(1),
                                  //                                                                     replyData["comment"],
                                  //                                                                     style: TextStyle(
                                  //                                                                       fontFamily: "Inter",
                                  //                                                                       color: Color(0xFF212121),
                                  //                                                                       fontWeight: FontWeight.w400,
                                  //                                                                       fontSize: 12,
                                  //                                                                       // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                       // height: 18,
                                  //                                                                     ),
                                  //                                                                   ),
                                  //                                                                   Row(
                                  //                                                                     children: [
                                  //                                                                       GestureDetector(
                                  //                                                                         onTap: () {
                                  //                                                                           HapticFeedback.lightImpact();
                                  //                                                                           if (replyData["likedBy"].contains(widget.userId)) {
                                  //                                                                             context.read<PostInfoBloc>().add(CancelReplyLike(postID: state.id, commentID: commentID, userID: widget.userId, replyCommentID: replyCommentID,));
                                  //                                                                           }
                                  //                                                                           else {
                                  //                                                                             context.read<PostInfoBloc>().add(SetReplyLike(postID: state.id, commentID: commentID, userID: widget.userId, replyCommentID: replyCommentID,));
                                  //                                                                           }
                                  //                                                                         },
                                  //                                                                         child: replyData["likedBy"].contains(widget.userId) ? SvgPicture.asset(width: 16, height: 16, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 16, height: 16, "assets/icons/Heart.svg"),
                                  //                                                                         // Icon(
                                  //                                                                         //   Icons.favorite_outlined,
                                  //                                                                         //   size: 20,
                                  //                                                                         //   color: replyData["likedBy"].contains(userId) ? Colors.red : Color(0xFF7B7B7B),
                                  //                                                                         // ),
                                  //                                                                       ),
                                  //                                                                       SizedBox(
                                  //                                                                         width: 12,
                                  //                                                                       ),
                                  //                                                                       Text(
                                  //                                                                         textScaler: TextScaler.linear(1),
                                  //                                                                         maxLines: 1,
                                  //                                                                         overflow: TextOverflow.ellipsis,
                                  //                                                                         replyData["likes"] < 0 ? "0" : replyData["likes"].toString(),
                                  //                                                                         style: TextStyle(
                                  //                                                                           fontFamily: "Inter",
                                  //                                                                           color: Color(0xFF7B7B7B),
                                  //                                                                           fontWeight: FontWeight.w500,
                                  //                                                                           fontSize: 12,
                                  //                                                                           // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                           // height: 18,
                                  //                                                                         ),
                                  //                                                                       ),
                                  //                                                                       SizedBox(
                                  //                                                                         width: 12,
                                  //                                                                       ),
                                  //                                                                       // TextButton.icon(
                                  //                                                                       //   icon: Icon(Icons.favorite_outlined, color: replyData["likedBy"].contains(userId) ? Colors.red : Colors.grey,),
                                  //                                                                       //   onPressed: () {
                                  //                                                                       //     if (replyData["likedBy"].contains(userId)) {
                                  //                                                                       //       context.read<PostInfoBloc>().add(CancelReplyLike(postID: state.id, commentID: commentID, userID: userId, replyCommentID: replyCommentID,));
                                  //                                                                       //     }
                                  //                                                                       //     else {
                                  //                                                                       //       context.read<PostInfoBloc>().add(SetReplyLike(postID: state.id, commentID: commentID, userID: userId, replyCommentID: replyCommentID,));
                                  //                                                                       //     }
                                  //                                                                       //   },
                                  //                                                                       //   label: Text(
                                  //                                                                       //     textScaler: TextScaler.linear(1),
                                  //                                                                       //     maxLines: 1,
                                  //                                                                       //     overflow: TextOverflow.ellipsis,
                                  //                                                                       //     replyData["likes"] < 0 ? "0" : replyData["likes"].toString(),
                                  //                                                                       //     style: TextStyle(
                                  //                                                                       //       fontFamily: "Inter",
                                  //                                                                       //       color: Colors.black,
                                  //                                                                       //       fontWeight: FontWeight.w400,
                                  //                                                                       //       fontSize: 12,
                                  //                                                                       //       // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                       //       // height: 18,
                                  //                                                                       //     ),
                                  //                                                                       //   ),
                                  //                                                                       // ),
                                  //                                                                       //
                                  //                                                                       // const SizedBox(
                                  //                                                                       //   width: 10,
                                  //                                                                       // ),
                                  //                                                                       Text(
                                  //                                                                         textScaler: TextScaler.linear(1),
                                  //                                                                         maxLines: 1,
                                  //                                                                         overflow: TextOverflow.ellipsis,
                                  //                                                                         replyTime,
                                  //                                                                         style: TextStyle(
                                  //                                                                           fontFamily: "Inter",
                                  //                                                                           color: Color(0xFF7B7B7B),
                                  //                                                                           fontWeight: FontWeight.w400,
                                  //                                                                           fontStyle: FontStyle.normal,
                                  //                                                                           fontSize: 12,
                                  //                                                                           // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                         ),
                                  //                                                                       ),
                                  //                                                                       (state.isReply && state.replyCommentId == replyCommentID) ? TextButton.icon(
                                  //                                                                         onPressed: () {
                                  //                                                                           HapticFeedback.lightImpact();
                                  //                                                                           context.read<PostInfoBloc>().add(const CancelReply());
                                  //                                                                           commentFocusNode.unfocus();
                                  //                                                                         },
                                  //                                                                         icon: const Icon(Icons.close, color: Color(0xFF7B7B7B), size: 20,),
                                  //                                                                         label: const Text(
                                  //                                                                           textScaler: TextScaler.linear(1),
                                  //                                                                           'Скасувати',
                                  //                                                                           maxLines: 1,
                                  //                                                                           overflow: TextOverflow.ellipsis,
                                  //                                                                           style: TextStyle(
                                  //                                                                             fontFamily: "Inter",
                                  //                                                                             color: Color(0xFF7B7B7B),
                                  //                                                                             fontWeight: FontWeight.w500,
                                  //                                                                             fontSize: 12,
                                  //                                                                             // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                             // height: 18,
                                  //                                                                           ),
                                  //                                                                         ),
                                  //                                                                         iconAlignment: IconAlignment.start,
                                  //                                                                       ) : TextButton.icon(
                                  //                                                                         onPressed: () {
                                  //                                                                           HapticFeedback.lightImpact();
                                  //                                                                           context.read<PostInfoBloc>().add(SetReply(commentId: commentID));
                                  //                                                                           commentFocusNode.requestFocus();
                                  //                                                                           // FocusScope.of(context).requestFocus(commentFocusNode);
                                  //                                                                         },
                                  //                                                                         icon: SvgPicture.asset("assets/icons/Forward.svg", width: 20, height: 20,),
                                  //                                                                         label: const Text(
                                  //                                                                           textScaler: TextScaler.linear(1),
                                  //                                                                           'Відповісти',
                                  //                                                                           maxLines: 1,
                                  //                                                                           overflow: TextOverflow.ellipsis,
                                  //                                                                           style: TextStyle(
                                  //                                                                             fontFamily: "Inter",
                                  //                                                                             color: Color(0xFF7B7B7B),
                                  //                                                                             fontWeight: FontWeight.w500,
                                  //                                                                             fontSize: 12,
                                  //                                                                             // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                                                             // height: 18,
                                  //                                                                           ),
                                  //                                                                         ),
                                  //                                                                         iconAlignment: IconAlignment.start,
                                  //                                                                       ),
                                  //                                                                       //ReplyButton(commentID: replyCommentID,),
                                  //                                                                     ],
                                  //                                                                   ),
                                  //                                                                 ],
                                  //                                                               ),
                                  //                                                             ),
                                  //                                                           )
                                  //                                                         ],
                                  //                                                       ),
                                  //                                                     );
                                  //                                                   }
                                  //                                               );
                                  //                                             }
                                  //                                             else {
                                  //                                               return Container();
                                  //                                               // return const CircularProgressIndicator();
                                  //                                             }
                                  //                                           },
                                  //                                         )
                                  //                                       ],
                                  //                                     );
                                  //                                   }
                                  //                               );
                                  //                             }
                                  //                             else {
                                  //                               return const CircularProgressIndicator();
                                  //                             }
                                  //                           },
                                  //                         ),
                                  //                       ),
                                  //                       Padding(
                                  //                         padding: EdgeInsets.only(
                                  //                           bottom: MediaQuery.of(context).viewInsets.bottom,
                                  //                         ),
                                  //                         child: Container(
                                  //                           // height: 50,
                                  //                           height: MediaQuery.of(context).size.height * 0.09,
                                  //                           padding: const EdgeInsets.symmetric(
                                  //                               vertical: 15,
                                  //                               horizontal: 10
                                  //                           ),
                                  //                           decoration: const BoxDecoration(
                                  //                             border: Border(
                                  //                               bottom: BorderSide(
                                  //                                 color: Colors.black,
                                  //                               ),
                                  //                             ),
                                  //                               borderRadius: BorderRadius.only(
                                  //                                 topRight: Radius.circular(30),
                                  //                                 topLeft: Radius.circular(30),
                                  //                               )
                                  //                           ),
                                  //                           child: Row(
                                  //                             children: [
                                  //                               CircleAvatar(
                                  //                                 radius: 25,
                                  //                                 backgroundImage: NetworkImage(
                                  //                                   widget.userInfo["avatar"],
                                  //                                 ),
                                  //                               ),
                                  //                               const SizedBox(
                                  //                                 width: 10,
                                  //                               ),
                                  //                               Expanded(
                                  //                                 child: TextField(
                                  //                                   onTap: () {
                                  //                                     HapticFeedback.lightImpact();
                                  //                                   },
                                  //                                   focusNode: commentFocusNode,
                                  //                                   maxLines: null,
                                  //                                   expands: true,
                                  //                                   controller: commentTextFieldController,
                                  //                                   // onChanged: (value) {
                                  //                                   //   context.read<PostInfoBloc>().add(CommentChanged(comment: value));
                                  //                                   // },
                                  //                                   decoration: InputDecoration(
                                  //                                     contentPadding: EdgeInsets.only(
                                  //                                       left: MediaQuery.of(context).size.width * 0.05,
                                  //                                       right: MediaQuery.of(context).size.width * 0.05,
                                  //                                     ),
                                  //                                     hintText: "Додайте коментар...",
                                  //                                     helperStyle: TextStyle(
                                  //                                       fontFamily: "Inter",
                                  //                                       color: Color(0xFF7B7B7B),
                                  //                                       fontWeight: FontWeight.w500,
                                  //                                       fontSize: 12,
                                  //                                       // fontSize: MediaQuery.textScalerOf(context).scale(12),
                                  //                                     ),
                                  //                                     enabledBorder: OutlineInputBorder(
                                  //                                         borderSide: const BorderSide(
                                  //                                           color: Color(0xFFD9D9D9),
                                  //                                         ),
                                  //                                         borderRadius: BorderRadius.circular(30)
                                  //                                     ),
                                  //                                     focusedBorder: OutlineInputBorder(
                                  //                                         borderSide: const BorderSide(
                                  //                                           color: Colors.black,
                                  //                                         ),
                                  //                                         borderRadius: BorderRadius.circular(30)
                                  //                                     ),
                                  //                                   ),
                                  //                                 ),
                                  //                                 //child: CommentTextInputField(commentTextFieldController: commentTextFieldController,),
                                  //                               ),
                                  //                               Container(
                                  //                                 margin: const EdgeInsets.only(
                                  //                                   left: 20,
                                  //                                   // right: 5,
                                  //                                   // right: 10
                                  //                                 ),
                                  //                                 decoration: const BoxDecoration(
                                  //                                   shape: BoxShape.circle,
                                  //                                   color: Colors.black,
                                  //                                 ),
                                  //                                 child: IconButton(
                                  //                                   icon: const Icon(
                                  //                                     Iconsax.send_2_copy,
                                  //                                     color: Colors.white,
                                  //                                   ),
                                  //                                   onPressed: () {
                                  //                                     HapticFeedback.lightImpact();
                                  //                                     if ((commentTextFieldController.text != "" && RegExp(r'.*\S.*').hasMatch(commentTextFieldController.text))) {
                                  //                                       context.read<PostInfoBloc>().add(SendCommentButtonClicked(userId: widget.userId, comment: commentTextFieldController.text));
                                  //                                       commentFocusNode.unfocus();
                                  //                                       commentTextFieldController.clear();
                                  //                                     }
                                  //                                     // if (state.comment != "" && RegExp(r'.*\S.*').hasMatch(state.comment)) {
                                  //                                     //   context.read<PostsBloc>().add(SendCommentButtonClicked(userId: userId));
                                  //                                     //   // commentTextFieldController.clear();
                                  //                                     // }
                                  //                                     // else {
                                  //                                     //   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                                  //                                     //     SnackBar(
                                  //                                     //       backgroundColor: Colors.black,
                                  //                                     //       elevation: 7,
                                  //                                     //       content: const Center(child: Text(textAlign: TextAlign.center, 'Введіть коментар', style: TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w400, fontSize: 12),)),
                                  //                                     //       duration: const Duration(seconds: 5),
                                  //                                     //       width: MediaQuery.of(context).size.width * 0.7,
                                  //                                     //       behavior: SnackBarBehavior.floating,
                                  //                                     //       shape: RoundedRectangleBorder(
                                  //                                     //         borderRadius: BorderRadius.circular(30.0),
                                  //                                     //       ),
                                  //                                     //     ),
                                  //                                     //   );
                                  //                                     // }
                                  //                                   },
                                  //                                 ),
                                  //                               ),
                                  //                               // SendCommentButton(userId: userId, commentTextFieldController: commentTextFieldController,),
                                  //                             ],
                                  //                           ),
                                  //                         ),
                                  //                       )
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               );
                                  //   },
                                  // ),
                                  // ),
                                  //             );
                                  //           },
                                  //         ),
                                  //         const SizedBox(
                                  //           width: 5,
                                  //         ),
                                  //         Text(
                                  //             textScaler: TextScaler.linear(1),
                                  //             maxLines: 1,
                                  //             overflow: TextOverflow.ellipsis,
                                  //             state.commentsQuantity.toString(),
                                  //             style: const TextStyle(
                                  //                 fontFamily: "Inter",
                                  //                 color: Colors.white
                                  //             )
                                  //         ),
                                  //       ],
                                  //     )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }
                        ),
                      ),
                    ),
                  ),
                ),
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                body: SafeArea(
                  maintainBottomViewPadding: true,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: state.postInfo,
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!.data()! as Map<String, dynamic>;
                        flickManager = FlickManager(
                          videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(data["video"])),
                        );
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 5,
                                  right: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.height * 0.0591,
                                      height: MediaQuery.of(context).size.height * 0.0591,
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                        // right: 10
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF636363).withValues(alpha: 0.5),
                                      ),
                                      child: IconButton(
                                        color: Colors.white,
                                        icon: const Icon(Icons.arrow_back_ios_new),
                                        onPressed: () {
                                          HapticFeedback.lightImpact();
                                          Navigator.pop(context);
                                          // Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Visibility(
                                          visible: widget.userInfo["role"] == "user",
                                          child: Container(
                                            width: MediaQuery.of(context).size.height * 0.0591,
                                            height: MediaQuery.of(context).size.height * 0.0591,
                                            margin: const EdgeInsets.only(
                                              right: 15,
                                              // right: 10
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF636363).withValues(alpha: 0.5),
                                            ),
                                            child: IconButton(
                                              color: Colors.white,
                                              icon: const Icon(Icons.stars_outlined),
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
                                        ),
                                        Visibility(
                                          visible: widget.userInfo["role"] == "user",
                                          child: Container(
                                            width: MediaQuery.of(context).size.height * 0.0591,
                                            height: MediaQuery.of(context).size.height * 0.0591,
                                            margin: const EdgeInsets.only(
                                              right: 15,
                                              // right: 10
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF636363).withValues(alpha: 0.5),
                                            ),
                                            child: IconButton(
                                              color: Colors.white,
                                              icon: const Icon(Icons.volunteer_activism_outlined),
                                              onPressed: () {
                                                HapticFeedback.lightImpact();
                                                PersistentNavBarNavigator.pushNewScreen(
                                                  context,
                                                  screen: DonatePage(userInfo: widget.userInfo, userId: widget.userId, productList: widget.productList,),
                                                  withNavBar: true,
                                                );
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (context) => DonatePage(userInfo: userInfo, userId: userId,),
                                                //   ),
                                                // );
                                              },
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: widget.userInfo["role"] == "admin",
                                          child: Container(
                                            width: MediaQuery.of(context).size.height * 0.0591,
                                            height: MediaQuery.of(context).size.height * 0.0591,
                                            margin: const EdgeInsets.only(
                                              right: 15,
                                              // right: 10
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF636363).withValues(alpha: 0.5),
                                            ),
                                            child: IconButton(
                                              color: Colors.white,
                                              icon: const Icon(Iconsax.note_remove_copy),
                                              onPressed: () {
                                                HapticFeedback.lightImpact();
                                                context.read<PostInfoBloc>().add(PostInfoPostDeleted(postId: widget.postId));
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (context) => DonatePage(userInfo: userInfo, userId: userId,),
                                                //   ),
                                                // );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.21,
                                child: FlickVideoPlayer(
                                  flickManager: flickManager,
                                  flickVideoWithControls: FlickVideoWithControls(
                                    videoFit: BoxFit.fill,
                                    controls: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: FlickAutoHideChild(
                                            child: Container(color: Colors.black38),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: FlickShowControlsAction(
                                            child: FlickSeekVideoAction(
                                              child: Center(
                                                child: flickManager.flickVideoManager?.nextVideoAutoPlayTimer != null
                                                    ? FlickAutoPlayCircularProgress(
                                                  colors: FlickAutoPlayTimerProgressColors(
                                                    backgroundColor: Colors.white30,
                                                    color: Colors.red,
                                                  ),
                                                ) : FlickAutoHideChild(
                                                  child: FlickPlayToggle(size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: FlickAutoHideChild(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          FlickCurrentPosition(),
                                                          Text(
                                                            ' / ',
                                                            style: TextStyle(
                                                              color: Colors.white),
                                                          ),
                                                          FlickTotalDuration(),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                      FlickFullScreenToggle(),
                                                    ],
                                                  ),
                                                  FlickVideoProgressBar(
                                                    flickProgressBarSettings: FlickProgressBarSettings(
                                                      height: 5,
                                                      handleRadius: 5,
                                                      curveRadius: 50,
                                                      backgroundColor: Colors.white24,
                                                      bufferedColor: Colors.white38,
                                                      playedColor: Colors.red,
                                                      handleColor: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  flickVideoWithControlsFullscreen: FlickVideoWithControls(
                                    videoFit: BoxFit.fill,
                                    controls: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: FlickAutoHideChild(
                                            child: Container(color: Colors.black38),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: FlickShowControlsAction(
                                            child: FlickSeekVideoAction(
                                              child: Center(
                                                child: flickManager.flickVideoManager?.nextVideoAutoPlayTimer != null
                                                    ? FlickAutoPlayCircularProgress(
                                                  colors: FlickAutoPlayTimerProgressColors(
                                                    backgroundColor: Colors.white30,
                                                    color: Colors.red,
                                                  ),
                                                ) : FlickAutoHideChild(
                                                  child: FlickPlayToggle(size: 50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: FlickAutoHideChild(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          FlickCurrentPosition(),
                                                          Text(
                                                            ' / ',
                                                            style: TextStyle(
                                                              color: Colors.white),
                                                          ),
                                                          FlickTotalDuration(),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                      FlickFullScreenToggle(),
                                                    ],
                                                  ),
                                                  FlickVideoProgressBar(
                                                    flickProgressBarSettings: FlickProgressBarSettings(
                                                      height: 5,
                                                      handleRadius: 5,
                                                      curveRadius: 50,
                                                      backgroundColor: Colors.white24,
                                                      bufferedColor: Colors.white38,
                                                      playedColor: Colors.red,
                                                      handleColor: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        textScaler: TextScaler.linear(1),
                                        data["title"],
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          color: Color(0xFF212121),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          // fontSize: MediaQuery.textScalerOf(context).scale(20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Wrap(
                                      spacing: 5,
                                      children: data["category"].map<Widget>((category) {
                                        return Chip(
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                            side: const BorderSide(color: Colors.black),
                                          ),
                                          avatar: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage(categoriesImages[category]!),
                                          ),
                                          label: Text(
                                            textScaler: TextScaler.linear(1),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            category
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      textScaler: TextScaler.linear(1),
                                      data["content"],
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        color: Color(0xFF212121),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        // fontSize: MediaQuery.textScalerOf(context).scale(14),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.12,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// class CommentTextInputField extends StatelessWidget {
//   const CommentTextInputField({super.key, required this.commentTextFieldController});
//
//   final TextEditingController commentTextFieldController;
//
//   // final TextEditingController commentTextFieldController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PostInfoBloc, PostInfoState>(
//       builder: (context, state) {
//         return TextField(
//           onTap: () {
//             HapticFeedback.lightImpact();
//           },
//           // focusNode: commentFocusNode,
//           controller: commentTextFieldController,
//           onChanged: (value) {
//             context.read<PostInfoBloc>().add(PostInfoCommentChanged(comment: value));
//           },
//           decoration: InputDecoration(
//             hintText: "Додайте коментар...",
//             helperStyle: TextStyle(
//               fontFamily: "Inter",
//               color: Color(0xFF7B7B7B),
//               fontWeight: FontWeight.w500,
//               fontSize: 12,
//               // fontSize: MediaQuery.textScalerOf(context).scale(12),
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(40)),
//               borderSide: BorderSide(
//                 color: Color(0xFFD9D9D9),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class SendCommentButton extends StatelessWidget {
//   const SendCommentButton({super.key, required this.userId, required this.commentTextFieldController});
//
//   final String userId;
//   final TextEditingController commentTextFieldController;
//
//   // final TextEditingController commentTextFieldController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PostInfoBloc, PostInfoState>(
//       builder: (context, state) {
//         return Container(
//           margin: const EdgeInsets.only(
//             left: 10,
//             // right: 5,
//             // right: 10
//           ),
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.black,
//           ),
//           child: IconButton(
//             icon: const Icon(
//               Icons.send,
//               color: Colors.white,
//             ),
//             onPressed: (state.comment != "" && RegExp(r'.*\S.*').hasMatch(state.comment)) ? () {
//               context.read<PostInfoBloc>().add(SendCommentButtonClicked(userId: userId));
//               commentTextFieldController.clear();
//               // if (state.comment != "" && RegExp(r'.*\S.*').hasMatch(state.comment)) {
//               //   context.read<PostsBloc>().add(SendCommentButtonClicked(userId: userId));
//               //   // commentTextFieldController.clear();
//               // }
//               // else {
//               //   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
//               //     SnackBar(
//               //       backgroundColor: Colors.black,
//               //       elevation: 7,
//               //       content: const Center(child: Text(textAlign: TextAlign.center, 'Введіть коментар', style: TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w400, fontSize: 12),)),
//               //       duration: const Duration(seconds: 5),
//               //       width: MediaQuery.of(context).size.width * 0.7,
//               //       behavior: SnackBarBehavior.floating,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(30.0),
//               //       ),
//               //     ),
//               //   );
//               // }
//             } : null,
//           ),
//         );
//       },
//     );
//   }
// }

// class ReplyButton extends StatelessWidget {
//   const ReplyButton({super.key, required this.commentID});
//
//   final String commentID;
//
//   // final TextEditingController commentTextFieldController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PostInfoBloc, PostInfoState>(
//       builder: (context, state) {
//         return (state.isReply && state.replyCommentId == commentID) ? TextButton.icon(
//           onPressed: () {
//             HapticFeedback.lightImpact();
//             context.read<PostInfoBloc>().add(const PostInfoReplyCanceled());
//           },
//           icon: const Icon(Icons.cancel, color: Colors.black,),
//           label: const Text(
//             textScaler: TextScaler.linear(1),
//             'Скасувати',
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: Colors.black),),
//           iconAlignment: IconAlignment.start,
//         ) : TextButton.icon(
//           onPressed: () {
//             HapticFeedback.lightImpact();
//             context.read<PostInfoBloc>().add(PostInfoReplySet(commentId: commentID));
//             // FocusScope.of(context).requestFocus(commentFocusNode);
//           },
//           icon: const Icon(Icons.reply, color: Colors.black,),
//           label: const Text(
//             textScaler: TextScaler.linear(1),
//             'Відповісти',
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: Colors.black),),
//           iconAlignment: IconAlignment.start,
//         );
//       },
//     );
//   }
// }
