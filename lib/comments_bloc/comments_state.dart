// part of 'comments_bloc.dart';
//
// final class CommentsState extends Equatable {
//   const CommentsState({
//     this.comment = "",
//     this.isReply = false,
//     this.replyCommentId = "",
//     this.commentsSnapshots,
//     this.postId = "",
//   });
//
//   final String postId;
//   final bool isReply;
//   final String replyCommentId;
//   final String comment;
//   final Stream<QuerySnapshot>? commentsSnapshots;
//
//   CommentsState copyWith({
//     bool? isReply,
//     String? replyCommentId,
//     String? comment,
//     Stream<QuerySnapshot>? commentsSnapshots,
//     String? postId,
//   }) {
//     return CommentsState(
//       postId: postId ?? this.postId,
//       isReply: isReply ?? this.isReply,
//       replyCommentId: replyCommentId ?? this.replyCommentId,
//       comment: comment ?? this.comment,
//       commentsSnapshots: commentsSnapshots ?? this.commentsSnapshots,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     isReply,
//     postId,
//     replyCommentId,
//     comment,
//     commentsSnapshots,
//   ];
// }
