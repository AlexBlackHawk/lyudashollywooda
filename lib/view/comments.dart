// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:intl/intl.dart';
//
// import '../comments_bloc/comments_bloc.dart';
//
// class CommentsPage extends StatefulWidget {
//   const CommentsPage({super.key, required this.postId, required this.userId, required this.userInfo});
//
//   final String postId;
//   final String userId;
//   final Map<String, dynamic> userInfo;
//
//   @override
//   State<CommentsPage> createState() => _CommentsPageState();
// }
//
// class _CommentsPageState extends State<CommentsPage> {
//   final TextEditingController commentTextFieldController = TextEditingController();
//
//   late FocusNode commentFocusNode;
//
//   @override
//   void initState() {
//     super.initState();
//
//     commentFocusNode = FocusNode();
//   }
//
//   @override
//   void dispose() {
//     // Clean up the focus node when the Form is disposed.
//     commentFocusNode.dispose();
//     commentTextFieldController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<CommentsBloc>(
//       create: (context) => CommentsBloc()..add(CommentsFetched(postId: widget.postId)),
//       child: BlocBuilder<CommentsBloc, CommentsState>(
//         builder: (context, state) {
//           return DraggableScrollableSheet(
//             initialChildSize: 0.9,
//             // minChildSize: 0.2,
//             maxChildSize: 0.9,
//             expand: false,
//             builder: (context, scrollController) => SafeArea(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(
//                       bottom: 10,
//                     ),
//                     height: MediaQuery.of(context).size.height * 0.09,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                               color: Color(0xFFD9D9D9),
//                             )
//                         )
//                     ),
//                     child: Center(
//                       child: Text(
//                         textScaler: TextScaler.linear(1),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         "Коментарі",
//                         style: TextStyle(
//                           fontFamily: "Inter",
//                           color: Color(0xFF212121),
//                           fontSize: 16,
//                           // fontSize: MediaQuery.textScalerOf(context).scale(16),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // const Divider(
//                   //   color: Color(0xFFD9D9D9),
//                   // ),
//                   Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: state.commentsSnapshots,
//                       // stream: state.commentsSnapshots,
//                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.hasError) {
//                           return const Text(
//                               textScaler: TextScaler.linear(1),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               'Помилка'
//                           );
//                         }
//
//                         if (snapshot.connectionState == ConnectionState.waiting) {
//                           return const Text(
//                               textScaler: TextScaler.linear(1),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               "Завантаження"
//                           );
//                         }
//                         if (snapshot.hasData) {
//                           return ListView.builder(
//                               controller: scrollController,
//                               itemCount: snapshot.data!.docs.length,
//                               // separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,),
//                               itemBuilder: (BuildContext context, int index) {
//                                 String commentId = snapshot.data!.docs[index].id;
//                                 Map<String, dynamic> data = snapshot.data!.docs[index].data()! as Map<String, dynamic>;
//                                 final fetchedUser = getUserInfo(data["user"]);
//                                 String commentTime = data["time"] != null ? DateFormat("dd.MM.yy HH:mm").format(data["time"].toDate()) : "";
//                                 final replies = getReplies(state.id, commentId);
//                                 // Timestamp commentTimestamp = data["time"];
//                                 // DateTime commentDatetime = commentTimestamp.toDate();
//                                 return Column(
//                                   // crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // ----------------
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         left: MediaQuery.of(context).size.width * 0.05,
//                                         bottom: 10,
//                                       ),
//                                       child: Row(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           StreamBuilder<DocumentSnapshot>(
//                                               stream: fetchedUser,
//                                               builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
//                                                 if (userSnapshot.hasError) {
//                                                   return const Text(
//                                                       textScaler: TextScaler.linear(1),
//                                                       maxLines: 1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                       "Error"
//                                                   );
//                                                 }
//
//                                                 if (userSnapshot.connectionState == ConnectionState.waiting) {
//                                                   return CircularProgressIndicator();
//                                                 }
//
//                                                 if (userSnapshot.hasData) {
//                                                   return CircleAvatar(
//                                                     backgroundImage: NetworkImage(userSnapshot.data!["avatar"]),
//                                                   );
//                                                 }
//                                                 return const Text(
//                                                     textScaler: TextScaler.linear(1),
//                                                     maxLines: 1,
//                                                     overflow: TextOverflow.ellipsis,
//                                                     "Немає даних"
//                                                 );
//                                               }
//                                           ),
//                                           SizedBox(
//                                             width: 15,
//                                           ),
//                                           Flexible(
//                                             child: Padding(
//                                               padding: const EdgeInsets.only(
//                                                 top: 13,
//                                                 right: 10,
//                                               ),
//                                               child: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   StreamBuilder<DocumentSnapshot>(
//                                                       stream: fetchedUser,
//                                                       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
//                                                         if (userSnapshot.hasError) {
//                                                           return const Text(
//                                                               textScaler: TextScaler.linear(1),
//                                                               maxLines: 1,
//                                                               overflow: TextOverflow.ellipsis,
//                                                               "Помилка"
//                                                           );
//                                                         }
//
//                                                         if (userSnapshot.connectionState == ConnectionState.waiting) {
//                                                           return const Text(
//                                                               textScaler: TextScaler.linear(1),
//                                                               maxLines: 1,
//                                                               overflow: TextOverflow.ellipsis,
//                                                               "Завантаження"
//                                                           );
//                                                         }
//
//                                                         if (userSnapshot.hasData) {
//                                                           return Text(
//                                                               style: TextStyle(
//                                                                 fontFamily: "Inter",
//                                                                 fontWeight: FontWeight.w600,
//                                                                 fontSize: 14,
//                                                                 color: Colors.black,
//                                                               ),
//                                                               textScaler: TextScaler.linear(1),
//                                                               userSnapshot.data!["name"]
//                                                           );
//                                                         }
//                                                         return const Text(
//                                                             textScaler: TextScaler.linear(1),
//                                                             maxLines: 1,
//                                                             overflow: TextOverflow.ellipsis,
//                                                             "Немає даних"
//                                                         );
//                                                       }
//                                                   ),
//                                                   SizedBox(
//                                                     height: 8,
//                                                   ),
//                                                   Text(
//                                                     textScaler: TextScaler.linear(1),
//                                                     data["comment"],
//                                                     style: TextStyle(
//                                                         fontFamily: "Inter",
//                                                         fontWeight: FontWeight.w400,
//                                                         fontSize: 14,
//                                                         color: Color(0xFF212121)
//                                                     ),
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     // crossAxisAlignment: CrossAxisAlignment.start,
//                                                     mainAxisSize: MainAxisSize.min,
//                                                     children: [
//                                                       GestureDetector(
//                                                         onTap: () {
//                                                           HapticFeedback.lightImpact();
//                                                           if (data["likedBy"].contains(widget.userId)) {
//                                                             context.read<CommentsBloc>().add(CommentsLikeCanceled(postId: widget.postId, commentId: commentId, userId: widget.userId,));
//                                                           }
//                                                           else {
//                                                             context.read<CommentsBloc>().add(CommentsLikeSet(postId: widget.postId, commentId: commentId, userId: widget.userId,));
//                                                           }
//                                                         },
//                                                         child: data["likedBy"].contains(widget.userId) ? SvgPicture.asset(width: 16, height: 16, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 16, height: 16, "assets/icons/Heart.svg"),
//                                                         // Icon(
//                                                         //   Icons.favorite_outlined,
//                                                         //   size: 20,
//                                                         //   color: data["likedBy"].contains(userId) ? Colors.red : Color(0xFF7B7B7B),
//                                                         //   // state.likedBy.contains(userId) ? SvgPicture.asset(width: 30, height: 30, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 30, height: 30, "assets/icons/Heart.svg", colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn))
//                                                         // ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 12,
//                                                       ),
//                                                       Text(
//                                                         textScaler: TextScaler.linear(1),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         data["likes"] < 0 ? "0" : data["likes"].toString(),
//                                                         style: TextStyle(
//                                                           fontFamily: "Inter",
//                                                           color: Color(0xFF7B7B7B),
//                                                           fontWeight: FontWeight.w500,
//                                                           fontSize: 12,
//                                                           // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                           // height: 18,
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         width: 12,
//                                                       ),
//                                                       // TextButton.icon(
//                                                       //   icon: Icon(Icons.favorite_outlined, color: data["likedBy"].contains(userId) ? Colors.red : Colors.grey,),
//                                                       //   onPressed: () {
//                                                       //     if (data["likedBy"].contains(userId)) {
//                                                       //       context.read<PostInfoBloc>().add(CancelCommentLike(postID: state.id, commentID: commentID, userID: userId,));
//                                                       //     }
//                                                       //     else {
//                                                       //       context.read<PostInfoBloc>().add(SetCommentLike(postID: state.id, commentID: commentID, userID: userId,));
//                                                       //     }
//                                                       //   },
//                                                       //   label: Text(
//                                                       //     textScaler: TextScaler.linear(1),
//                                                       //     maxLines: 1,
//                                                       //     overflow: TextOverflow.ellipsis,
//                                                       //     data["likes"] < 0 ? "0" : data["likes"].toString(),
//                                                       //     style: TextStyle(
//                                                       //       fontFamily: "Inter",
//                                                       //       color: Colors.black,
//                                                       //       fontWeight: FontWeight.w400,
//                                                       //       fontSize: 12,
//                                                       //       // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                       //       // height: 18,
//                                                       //     ),
//                                                       //   ),
//                                                       // ),
//                                                       Text(
//                                                         textScaler: TextScaler.linear(1),
//                                                         maxLines: 1,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         commentTime,
//                                                         style: TextStyle(
//                                                           fontFamily: "Inter",
//                                                           color: Color(0xFF7B7B7B),
//                                                           fontWeight: FontWeight.w500,
//                                                           fontSize: 12,
//                                                           // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                           // height: 18,
//                                                         ),
//                                                       ),
//                                                       (state.isReply && state.replyCommentId == commentId) ? TextButton.icon(
//                                                         onPressed: () {
//                                                           HapticFeedback.lightImpact();
//                                                           context.read<CommentsBloc>().add(const CommentsReplyCanceled());
//                                                           commentFocusNode.unfocus();
//                                                         },
//                                                         icon: const Icon(Icons.close, color: Color(0xFF7B7B7B), size: 20,),
//                                                         label: const Text(
//                                                           textScaler: TextScaler.linear(1),
//                                                           'Скасувати',
//                                                           maxLines: 1,
//                                                           overflow: TextOverflow.ellipsis,
//                                                           style: TextStyle(
//                                                             fontFamily: "Inter",
//                                                             color: Color(0xFF7B7B7B),
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 12,
//                                                             // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                             // height: 18,
//                                                           ),
//                                                         ),
//                                                         iconAlignment: IconAlignment.start,
//                                                       ) : TextButton.icon(
//                                                         onPressed: () {
//                                                           HapticFeedback.lightImpact();
//                                                           context.read<CommentsBloc>().add(CommentsReplySet(commentId: commentId));
//                                                           commentFocusNode.requestFocus();
//                                                           // FocusScope.of(context).requestFocus(commentFocusNode);
//                                                         },
//                                                         icon: SvgPicture.asset("assets/icons/Forward.svg", width: 20, height: 20,),
//                                                         label: const Text(
//                                                           textScaler: TextScaler.linear(1),
//                                                           'Відповісти',
//                                                           maxLines: 1,
//                                                           overflow: TextOverflow.ellipsis,
//                                                           style: TextStyle(
//                                                             fontFamily: "Inter",
//                                                             color: Color(0xFF7B7B7B),
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 12,
//                                                             // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                             // height: 18,
//                                                           ),
//                                                         ),
//                                                         iconAlignment: IconAlignment.start,
//                                                       ),
//                                                       // ReplyButton(commentID: commentID,),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     // ----------------
//                                     StreamBuilder<QuerySnapshot>(
//                                       stream: replies,
//                                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> replySnapshot) {
//                                         if (replySnapshot.hasError) {
//                                           return Container();
//                                           // return const Text(
//                                           //     textScaler: TextScaler.linear(1),
//                                           //     maxLines: 1,
//                                           //     overflow: TextOverflow.ellipsis,
//                                           //     'Помилка'
//                                           // );
//                                         }
//
//                                         if (replySnapshot.connectionState == ConnectionState.waiting) {
//                                           return Container();
//                                           // return const Text(
//                                           //     textScaler: TextScaler.linear(1),
//                                           //     maxLines: 1,
//                                           //     overflow: TextOverflow.ellipsis,
//                                           //     "Завантаження"
//                                           // );
//                                         }
//                                         if (replySnapshot.hasData) {
//                                           return ListView.builder(
//                                               shrinkWrap: true,
//                                               physics: const ClampingScrollPhysics(),
//                                               itemCount: replySnapshot.data!.docs.length,
//                                               // separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,),
//                                               itemBuilder: (context, index) {
//                                                 String replyCommentId = replySnapshot.data!.docs[index].id;
//                                                 Map<String, dynamic> replyData = replySnapshot.data!.docs[index].data()! as Map<String, dynamic>;
//                                                 final replyFetchedUser = getUserInfo(replyData["user"]);
//                                                 String replyTime = DateFormat("dd.MM.yy HH:mm").format(replyData["time"].toDate());
//                                                 // Timestamp replyCommentTimestamp = data["time"];
//                                                 // DateTime replyCommentDatetime = replyCommentTimestamp.toDate();
//                                                 return Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: MediaQuery.of(context).size.width * 0.17,
//                                                       bottom: 15
//                                                   ),
//                                                   child: Row(
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       StreamBuilder<DocumentSnapshot>(
//                                                           stream: replyFetchedUser,
//                                                           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> replyUserSnapshot) {
//                                                             if (replyUserSnapshot.hasError) {
//                                                               return Container();
//                                                               // return const Text(
//                                                               //     textScaler: TextScaler.linear(1),
//                                                               //     maxLines: 1,
//                                                               //     overflow: TextOverflow.ellipsis,
//                                                               //     "Помилка"
//                                                               // );
//                                                             }
//
//                                                             if (replyUserSnapshot.connectionState == ConnectionState.waiting) {
//                                                               return Container();
//                                                               // return const Text(
//                                                               //     textScaler: TextScaler.linear(1),
//                                                               //     maxLines: 1,
//                                                               //     overflow: TextOverflow.ellipsis,
//                                                               //     "Завантаження"
//                                                               // );
//                                                             }
//
//                                                             if (replyUserSnapshot.hasData) {
//                                                               return CircleAvatar(
//                                                                 backgroundImage: NetworkImage(replyUserSnapshot.data!["avatar"]),
//                                                               );
//                                                             }
//                                                             return Container();
//                                                           }
//                                                       ),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Flexible(
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.only(
//                                                             top: 13,
//                                                             right: 10,
//                                                           ),
//                                                           child: Column(
//                                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                                             children: [
//                                                               StreamBuilder<DocumentSnapshot>(
//                                                                   stream: replyFetchedUser,
//                                                                   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> replyUserSnapshot) {
//                                                                     if (replyUserSnapshot.hasError) {
//                                                                       return const Text(
//                                                                           textScaler: TextScaler.linear(1),
//                                                                           maxLines: 1,
//                                                                           overflow: TextOverflow.ellipsis,
//                                                                           "Error"
//                                                                       );
//                                                                     }
//
//                                                                     if (replyUserSnapshot.connectionState == ConnectionState.waiting) {
//                                                                       return const Text(
//                                                                           textScaler: TextScaler.linear(1),
//                                                                           maxLines: 1,
//                                                                           overflow: TextOverflow.ellipsis,
//                                                                           "Завантаження"
//                                                                       );
//                                                                     }
//
//                                                                     if (replyUserSnapshot.hasData) {
//                                                                       return Text(
//                                                                         textScaler: TextScaler.linear(1),
//                                                                         replyUserSnapshot.data!["name"],
//                                                                         style: TextStyle(
//                                                                           fontFamily: "Inter",
//                                                                           color: Colors.black,
//                                                                           fontWeight: FontWeight.w600,
//                                                                           fontSize: 14,
//                                                                           // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                           // height: 18,
//                                                                         ),
//                                                                       );
//                                                                     }
//                                                                     return const Text(
//                                                                         textScaler: TextScaler.linear(1),
//                                                                         maxLines: 1,
//                                                                         overflow: TextOverflow.ellipsis,
//                                                                         "No Data"
//                                                                     );
//                                                                   }
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 8,
//                                                               ),
//                                                               Text(
//                                                                 textScaler: TextScaler.linear(1),
//                                                                 replyData["comment"],
//                                                                 style: TextStyle(
//                                                                   fontFamily: "Inter",
//                                                                   color: Color(0xFF212121),
//                                                                   fontWeight: FontWeight.w400,
//                                                                   fontSize: 12,
//                                                                   // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                   // height: 18,
//                                                                 ),
//                                                               ),
//                                                               Row(
//                                                                 children: [
//                                                                   GestureDetector(
//                                                                     onTap: () {
//                                                                       HapticFeedback.lightImpact();
//                                                                       if (replyData["likedBy"].contains(widget.userId)) {
//                                                                         context.read<CommentsBloc>().add(CommentsReplyLikeCanceled(postId: widget.postId, commentId: commentId, userId: widget.userId, replyCommentId: replyCommentId,));
//                                                                       }
//                                                                       else {
//                                                                         context.read<CommentsBloc>().add(CommentsReplyLikeSet(postId: widget.postId, commentId: commentId, userId: widget.userId, replyCommentId: replyCommentId,));
//                                                                       }
//                                                                     },
//                                                                     child: replyData["likedBy"].contains(widget.userId) ? SvgPicture.asset(width: 16, height: 16, "assets/icons/HeartActive.svg") : SvgPicture.asset(width: 16, height: 16, "assets/icons/Heart.svg"),
//                                                                     // Icon(
//                                                                     //   Icons.favorite_outlined,
//                                                                     //   size: 20,
//                                                                     //   color: replyData["likedBy"].contains(userId) ? Colors.red : Color(0xFF7B7B7B),
//                                                                     // ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 12,
//                                                                   ),
//                                                                   Text(
//                                                                     textScaler: TextScaler.linear(1),
//                                                                     maxLines: 1,
//                                                                     overflow: TextOverflow.ellipsis,
//                                                                     replyData["likes"] < 0 ? "0" : replyData["likes"].toString(),
//                                                                     style: TextStyle(
//                                                                       fontFamily: "Inter",
//                                                                       color: Color(0xFF7B7B7B),
//                                                                       fontWeight: FontWeight.w500,
//                                                                       fontSize: 12,
//                                                                       // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                       // height: 18,
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 12,
//                                                                   ),
//                                                                   // TextButton.icon(
//                                                                   //   icon: Icon(Icons.favorite_outlined, color: replyData["likedBy"].contains(userId) ? Colors.red : Colors.grey,),
//                                                                   //   onPressed: () {
//                                                                   //     if (replyData["likedBy"].contains(userId)) {
//                                                                   //       context.read<PostInfoBloc>().add(CancelReplyLike(postID: state.id, commentID: commentID, userID: userId, replyCommentID: replyCommentID,));
//                                                                   //     }
//                                                                   //     else {
//                                                                   //       context.read<PostInfoBloc>().add(SetReplyLike(postID: state.id, commentID: commentID, userID: userId, replyCommentID: replyCommentID,));
//                                                                   //     }
//                                                                   //   },
//                                                                   //   label: Text(
//                                                                   //     textScaler: TextScaler.linear(1),
//                                                                   //     maxLines: 1,
//                                                                   //     overflow: TextOverflow.ellipsis,
//                                                                   //     replyData["likes"] < 0 ? "0" : replyData["likes"].toString(),
//                                                                   //     style: TextStyle(
//                                                                   //       fontFamily: "Inter",
//                                                                   //       color: Colors.black,
//                                                                   //       fontWeight: FontWeight.w400,
//                                                                   //       fontSize: 12,
//                                                                   //       // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                   //       // height: 18,
//                                                                   //     ),
//                                                                   //   ),
//                                                                   // ),
//                                                                   //
//                                                                   // const SizedBox(
//                                                                   //   width: 10,
//                                                                   // ),
//                                                                   Text(
//                                                                     textScaler: TextScaler.linear(1),
//                                                                     maxLines: 1,
//                                                                     overflow: TextOverflow.ellipsis,
//                                                                     replyTime,
//                                                                     style: TextStyle(
//                                                                       fontFamily: "Inter",
//                                                                       color: Color(0xFF7B7B7B),
//                                                                       fontWeight: FontWeight.w400,
//                                                                       fontStyle: FontStyle.normal,
//                                                                       fontSize: 12,
//                                                                       // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                     ),
//                                                                   ),
//                                                                   (state.isReply && state.replyCommentId == replyCommentId) ? TextButton.icon(
//                                                                     onPressed: () {
//                                                                       HapticFeedback.lightImpact();
//                                                                       context.read<CommentsBloc>().add(const CommentsReplyCanceled());
//                                                                       commentFocusNode.unfocus();
//                                                                     },
//                                                                     icon: const Icon(Icons.close, color: Color(0xFF7B7B7B), size: 20,),
//                                                                     label: const Text(
//                                                                       textScaler: TextScaler.linear(1),
//                                                                       'Скасувати',
//                                                                       maxLines: 1,
//                                                                       overflow: TextOverflow.ellipsis,
//                                                                       style: TextStyle(
//                                                                         fontFamily: "Inter",
//                                                                         color: Color(0xFF7B7B7B),
//                                                                         fontWeight: FontWeight.w500,
//                                                                         fontSize: 12,
//                                                                         // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                         // height: 18,
//                                                                       ),
//                                                                     ),
//                                                                     iconAlignment: IconAlignment.start,
//                                                                   ) : TextButton.icon(
//                                                                     onPressed: () {
//                                                                       HapticFeedback.lightImpact();
//                                                                       context.read<CommentsBloc>().add(CommentsReplySet(commentId: commentId));
//                                                                       commentFocusNode.requestFocus();
//                                                                       // FocusScope.of(context).requestFocus(commentFocusNode);
//                                                                     },
//                                                                     icon: SvgPicture.asset("assets/icons/Forward.svg", width: 20, height: 20,),
//                                                                     label: const Text(
//                                                                       textScaler: TextScaler.linear(1),
//                                                                       'Відповісти',
//                                                                       maxLines: 1,
//                                                                       overflow: TextOverflow.ellipsis,
//                                                                       style: TextStyle(
//                                                                         fontFamily: "Inter",
//                                                                         color: Color(0xFF7B7B7B),
//                                                                         fontWeight: FontWeight.w500,
//                                                                         fontSize: 12,
//                                                                         // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                                                         // height: 18,
//                                                                       ),
//                                                                     ),
//                                                                     iconAlignment: IconAlignment.start,
//                                                                   ),
//                                                                   //ReplyButton(commentID: replyCommentID,),
//                                                                 ],
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 );
//                                               }
//                                           );
//                                         }
//                                         else {
//                                           return Container();
//                                           // return const CircularProgressIndicator();
//                                         }
//                                       },
//                                     )
//                                   ],
//                                 );
//                               }
//                           );
//                         }
//                         else {
//                           return const CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                     ),
//                     child: Container(
//                       // height: 50,
//                       height: MediaQuery.of(context).size.height * 0.09,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                           horizontal: 10
//                       ),
//                       decoration: const BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: Colors.black,
//                             ),
//                           ),
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(30),
//                             topLeft: Radius.circular(30),
//                           )
//                       ),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundImage: NetworkImage(
//                               widget.userInfo["avatar"],
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                             child: TextField(
//                               onTap: () {
//                                 HapticFeedback.lightImpact();
//                               },
//                               focusNode: commentFocusNode,
//                               maxLines: null,
//                               expands: true,
//                               controller: commentTextFieldController,
//                               // onChanged: (value) {
//                               //   context.read<PostInfoBloc>().add(CommentChanged(comment: value));
//                               // },
//                               decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.only(
//                                   left: MediaQuery.of(context).size.width * 0.05,
//                                   right: MediaQuery.of(context).size.width * 0.05,
//                                 ),
//                                 hintText: "Додайте коментар...",
//                                 helperStyle: TextStyle(
//                                   fontFamily: "Inter",
//                                   color: Color(0xFF7B7B7B),
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 12,
//                                   // fontSize: MediaQuery.textScalerOf(context).scale(12),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Color(0xFFD9D9D9),
//                                     ),
//                                     borderRadius: BorderRadius.circular(30)
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                       color: Colors.black,
//                                     ),
//                                     borderRadius: BorderRadius.circular(30)
//                                 ),
//                               ),
//                             ),
//                             //child: CommentTextInputField(commentTextFieldController: commentTextFieldController,),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(
//                               left: 20,
//                               // right: 5,
//                               // right: 10
//                             ),
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.black,
//                             ),
//                             child: IconButton(
//                               icon: const Icon(
//                                 Iconsax.send_2_copy,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 HapticFeedback.lightImpact();
//                                 if ((commentTextFieldController.text != "" && RegExp(r'.*\S.*').hasMatch(commentTextFieldController.text))) {
//                                   context.read<CommentsBloc>().add(CommentsSent(userId: widget.userId));
//                                   commentFocusNode.unfocus();
//                                   commentTextFieldController.clear();
//                                 }
//                                 // if (state.comment != "" && RegExp(r'.*\S.*').hasMatch(state.comment)) {
//                                 //   context.read<PostsBloc>().add(SendCommentButtonClicked(userId: userId));
//                                 //   // commentTextFieldController.clear();
//                                 // }
//                                 // else {
//                                 //   ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
//                                 //     SnackBar(
//                                 //       backgroundColor: Colors.black,
//                                 //       elevation: 7,
//                                 //       content: const Center(child: Text(textAlign: TextAlign.center, 'Введіть коментар', style: TextStyle(color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.w400, fontSize: 12),)),
//                                 //       duration: const Duration(seconds: 5),
//                                 //       width: MediaQuery.of(context).size.width * 0.7,
//                                 //       behavior: SnackBarBehavior.floating,
//                                 //       shape: RoundedRectangleBorder(
//                                 //         borderRadius: BorderRadius.circular(30.0),
//                                 //       ),
//                                 //     ),
//                                 //   );
//                                 // }
//                               },
//                             ),
//                           ),
//                           // SendCommentButton(userId: userId, commentTextFieldController: commentTextFieldController,),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
