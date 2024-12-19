part of 'post_info_bloc.dart';

// sealed class PostInfoState extends Equatable {
//   const PostInfoState();
// }

enum DeletionStatus { initial, inProgress, success, failure }

final class PostInfoState extends Equatable {
  const PostInfoState({
    this.id = "",
    this.likedBy = const <dynamic>[],
    this.userLikes = const <String>[],
    this.likes = 0,
    this.isReply = false,
    this.replyCommentId = "",
    this.content = "",
    this.title = "",
    this.categories = const <dynamic>[],
    this.pictureLink = "",
    this.deletionStatus = DeletionStatus.initial,
    this.postInfo,
  });

  final String id;
  final List<dynamic> likedBy;
  final List<String> userLikes;
  final int likes;
  final bool isReply;
  final String replyCommentId;
  final String pictureLink;
  final String title;
  final String content;
  final List<dynamic> categories;
  final DeletionStatus deletionStatus;
  final Stream<DocumentSnapshot>? postInfo;

  PostInfoState copyWith({
    String? id,
    String? pictureLink,
    String? title,
    String? content,
    List<dynamic>? categories,
    List<dynamic>? likedBy,
    List<String>? userLikes,
    int? likes,
    bool? isReply,
    String? replyCommentId,
    DeletionStatus? deletionStatus,
    Stream<DocumentSnapshot>? postInfo,
  }) {
    return PostInfoState(
      id: id ?? this.id,
      likedBy: likedBy ?? this.likedBy,
      userLikes: userLikes ?? this.userLikes,
      likes: likes ?? this.likes,
      isReply: isReply ?? this.isReply,
      replyCommentId: replyCommentId ?? this.replyCommentId,
      pictureLink: pictureLink ?? this.pictureLink,
      title: title ?? this.title,
      content: content ?? this.content,
      categories: categories ?? this.categories,
      deletionStatus: deletionStatus ?? this.deletionStatus,
      postInfo: postInfo ?? this.postInfo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    likedBy,
    userLikes,
    likes,
    isReply,
    replyCommentId,
    pictureLink,
    title,
    content,
    categories,
    deletionStatus,
    postInfo,
  ];
}
