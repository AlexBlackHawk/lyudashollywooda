// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
//
// part 'comments_event.dart';
// part 'comments_state.dart';
//
// class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
//   CommentsBloc() : super(CommentsState()) {
//     on<CommentsChanged>(_onCommentsChanged);
//     on<CommentsFetched>(_onCommentsFetched);
//     on<CommentsLikeSet>(_onCommentsLikeSet);
//     on<CommentsLikeCanceled>(_onCommentsLikeCanceled);
//     on<CommentsReplyLikeSet>(_onCommentsReplyLikeSet);
//     on<CommentsReplyLikeCanceled>(_onCommentsReplyLikeCanceled);
//     on<CommentsSent>(_onCommentsSent);
//     on<CommentsReplySet>(_onCommentsReplySet);
//     on<CommentsReplyCanceled>(_onCommentsReplyCanceled);
//   }
//
//   final FirebaseFirestore db = FirebaseFirestore.instance;
//
//   void _onCommentsChanged(CommentsChanged event, Emitter<CommentsState> emit) {
//     emit(
//       state.copyWith(
//         comment: event.comment,
//       ),
//     );
//   }
//
//   void _onCommentsFetched(CommentsFetched event, Emitter<CommentsState> emit) {
//     emit(
//       state.copyWith(
//         postId: event.postId,
//         commentsSnapshots: ,
//       ),
//     );
//   }
//
//   void _onCommentsLikeSet(CommentsLikeSet event, Emitter<CommentsState> emit) {
//     db.collection("Posts").doc(event.postId).collection("Comments").doc(event.commentId).update({
//       "likes": FieldValue.arrayUnion([event.userId]),
//     });
//     // emit(
//     //   state.copyWith(
//     //     isRecordVideoNoteMode: event.recordVideoNoteMode,
//     //   ),
//     // );
//   }
//
//   void _onCommentsLikeCanceled(CommentsLikeCanceled event, Emitter<CommentsState> emit) {
//     db.collection("Posts").doc(event.postId).collection("Comments").doc(event.commentId).update({
//       "likes": FieldValue.arrayRemove([event.userId]),
//     });
//     // emit(
//     //   state.copyWith(
//     //     isRecordVideoNoteMode: event.recordVideoNoteMode,
//     //   ),
//     // );
//   }
//
//   void _onCommentsReplyLikeSet(CommentsReplyLikeSet event, Emitter<CommentsState> emit) {
//     db.collection("Posts").doc(event.postId).collection("Comments").doc(event.commentId).collection("Replies").doc(event.replyCommentId).update({
//       "likes": FieldValue.arrayUnion([event.userId]),
//     });
//     // emit(
//     //   state.copyWith(
//     //     isRecordVideoNoteMode: event.recordVideoNoteMode,
//     //   ),
//     // );
//   }
//
//   void _onCommentsReplyLikeCanceled(CommentsReplyLikeCanceled event, Emitter<CommentsState> emit) {
//     db.collection("Posts").doc(event.postId).collection("Comments").doc(event.commentId).collection("Replies").doc(event.replyCommentId).update({
//       "likes": FieldValue.arrayRemove([event.userId]),
//     });
//     // emit(
//     //   state.copyWith(
//     //     isRecordVideoNoteMode: event.recordVideoNoteMode,
//     //   ),
//     // );
//   }
//
//   void _onCommentsSent(CommentsSent event, Emitter<CommentsState> emit) {
//     Map<String, dynamic> comment = <String, dynamic>{};
//     if (state.isReply) {
//       db.collection("Posts").doc(state.postId).collection("Comments").doc(state.replyCommentId).collection("Replies").add(comment);
//     }
//     else {
//       db.collection("Posts").doc(state.postId).collection("Comments").add(comment);
//     }
//     emit(
//       state.copyWith(
//         comment: "",
//       ),
//     );
//   }
//
//   void _onCommentsReplySet(CommentsReplySet event, Emitter<CommentsState> emit) {
//     emit(
//       state.copyWith(
//         isReply: true,
//         replyCommentId: event.commentId,
//       ),
//     );
//   }
//
//   void _onCommentsReplyCanceled(CommentsReplyCanceled event, Emitter<CommentsState> emit) {
//     emit(
//       state.copyWith(
//         isReply: false,
//         replyCommentId: "",
//       ),
//     );
//   }
// }
