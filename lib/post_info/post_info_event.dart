part of 'post_info_bloc.dart';

sealed class PostInfoEvent extends Equatable {
  const PostInfoEvent();

  @override
  List<Object?> get props => [];
}

final class PostInfoFetched extends PostInfoEvent {
  const PostInfoFetched({required this.postId, required this.userId});

  final String postId;
  final String userId;

  @override
  List<Object> get props => [postId, userId];
}

final class PostInfoCommentChanged extends PostInfoEvent {
  const PostInfoCommentChanged({required this.comment});

  final String comment;

  @override
  List<Object> get props => [comment];
}

final class PostInfoReplySet extends PostInfoEvent {
  const PostInfoReplySet({required this.commentId});

  final String commentId;

  @override
  List<Object> get props => [commentId];
}

final class PostInfoPostDeleted extends PostInfoEvent {
  const PostInfoPostDeleted({required this.postId});

  final String postId;

  @override
  List<Object> get props => [postId];
}

final class PostInfoReplyCanceled extends PostInfoEvent {
  const PostInfoReplyCanceled();
}

final class PostInfoLikeSet extends PostInfoEvent {
  const PostInfoLikeSet({required this.postID, required this.userID});

  final String postID;
  final String userID;

  @override
  List<Object> get props => [postID, userID];
}

final class PostInfoLikeCanceled extends PostInfoEvent {
  const PostInfoLikeCanceled({required this.postID, required this.userID});

  final String postID;
  final String userID;

  @override
  List<Object> get props => [postID, userID];
}

