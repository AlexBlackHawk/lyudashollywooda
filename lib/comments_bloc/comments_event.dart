// part of 'comments_bloc.dart';
//
// sealed class CommentsEvent extends Equatable {
//   const CommentsEvent();
//
//   @override
//   List<Object?> get props => [];
// }
//
// final class CommentsChanged extends CommentsEvent {
//   const CommentsChanged({required this.comment});
//
//   final String comment;
//
//   @override
//   List<Object> get props => [comment];
// }
//
// final class CommentsFetched extends CommentsEvent {
//   const CommentsFetched({required this.postId});
//
//   final String postId;
//
//   @override
//   List<Object> get props => [postId];
// }
//
// final class CommentsLikeSet extends CommentsEvent {
//   const CommentsLikeSet({required this.postId, required this.commentId, required this.userId});
//
//   final String postId;
//   final String commentId;
//   final String userId;
//
//   @override
//   List<Object> get props => [postId, commentId, userId];
// }
//
// final class CommentsLikeCanceled extends CommentsEvent {
//   const CommentsLikeCanceled({required this.postId, required this.commentId, required this.userId});
//
//   final String postId;
//   final String commentId;
//   final String userId;
//
//   @override
//   List<Object> get props => [postId, commentId, userId];
// }
//
// final class CommentsReplyLikeSet extends CommentsEvent {
//   const CommentsReplyLikeSet({required this.postId, required this.commentId, required this.userId, required this.replyCommentId});
//
//   final String postId;
//   final String commentId;
//   final String userId;
//   final String replyCommentId;
//
//   @override
//   List<Object> get props => [postId, commentId, userId, replyCommentId];
// }
//
// final class CommentsReplyLikeCanceled extends CommentsEvent {
//   const CommentsReplyLikeCanceled({required this.postId, required this.commentId, required this.userId, required this.replyCommentId});
//
//   final String postId;
//   final String commentId;
//   final String userId;
//   final String replyCommentId;
//
//   @override
//   List<Object> get props => [postId, commentId, userId, replyCommentId];
// }
//
// final class CommentsSent extends CommentsEvent {
//   const CommentsSent({required this.userId});
//
//   final String userId;
//
//   @override
//   List<Object> get props => [userId];
// }
//
// final class CommentsReplySet extends CommentsEvent {
//   const CommentsReplySet({required this.commentId});
//
//   final String commentId;
//
//   @override
//   List<Object> get props => [commentId];
// }
//
// final class CommentsReplyCanceled extends CommentsEvent {
//   const CommentsReplyCanceled();
// }