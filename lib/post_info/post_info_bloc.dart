import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'post_info_event.dart';
part 'post_info_state.dart';

class PostInfoBloc extends Bloc<PostInfoEvent, PostInfoState> {
  PostInfoBloc() : super(const PostInfoState()) {
    on<PostInfoFetched>(_onFetched);
    on<PostInfoCommentChanged>(_onCommentChanged);
    on<PostInfoReplySet>(_onReplySet);
    on<PostInfoReplyCanceled>(_onReplyCanceled);
    on<PostInfoLikeSet>(_onLikeSet);
    on<PostInfoLikeCanceled>(_onLikeCanceled);
    on<PostInfoPostDeleted>(_onPostDeleted);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  void _onPostDeleted(PostInfoPostDeleted event, Emitter<PostInfoState> emit) {
    emit(state.copyWith(deletionStatus: DeletionStatus.inProgress));
    try {
      db.collection("Posts").doc(event.postId).collection("Comments").get().then((comments) {
        for (var comment in comments.docs) {
          db.collection("Posts").doc(event.postId).collection("Comments").doc(comment.id).collection("Replies").get().then((replies) {
            for (var reply in replies.docs) {
              db.collection("Posts").doc(event.postId).collection("Comments").doc(comment.id).collection("Replies").doc(reply.id).delete();
            }
          });
          db.collection("Posts").doc(event.postId).collection("Comments").doc(comment.id).delete();
        }});
      db.collection("Posts").doc(event.postId).delete();
      emit(state.copyWith(deletionStatus: DeletionStatus.success));
    }
    catch (e) {
      emit(state.copyWith(deletionStatus: DeletionStatus.failure));
    }
  }

  void _onLikeSet(PostInfoLikeSet event, Emitter<PostInfoState> emit) {
    db.collection("Posts")
        .doc(event.postID)
        .update({"likes": FieldValue.increment(1), "likedBy": FieldValue.arrayUnion([event.userID])});

    int likes = state.likes;
    likes += 1;

    List<dynamic> likedBy = state.likedBy.toList();
    likedBy.add(event.userID);

    emit(
      state.copyWith(
        likes: likes,
        likedBy: likedBy,
        deletionStatus: DeletionStatus.initial,
      ),
    );
  }

  void _onLikeCanceled(PostInfoLikeCanceled event, Emitter<PostInfoState> emit) {
    db.collection("Posts")
        .doc(event.postID)
        .update({"likes": FieldValue.increment(-1), "likedBy": FieldValue.arrayRemove([event.userID])});

    int likes = state.likes;
    likes -= 1;

    List<dynamic> likedBy = state.likedBy.toList();
    likedBy.remove(event.userID);

    emit(
      state.copyWith(
        likes: likes,
        likedBy: likedBy,
        deletionStatus: DeletionStatus.initial,
      ),
    );
  }

  void _onReplyCanceled(PostInfoReplyCanceled event, Emitter<PostInfoState> emit) {
    emit(
      state.copyWith(
        isReply: false,
        replyCommentId: "",
        deletionStatus: DeletionStatus.initial,
      ),
    );
  }

  void _onReplySet(PostInfoReplySet event, Emitter<PostInfoState> emit) {
    emit(
      state.copyWith(
        isReply: true,
        replyCommentId: event.commentId,
        deletionStatus: DeletionStatus.initial,
      ),
    );
  }

  void _onCommentChanged(PostInfoCommentChanged event, Emitter<PostInfoState> emit) {
    emit(
      state.copyWith(
        deletionStatus: DeletionStatus.initial,
      ),
    );
  }

  void _onFetched(PostInfoFetched event, Emitter<PostInfoState> emit) async {
    DocumentReference postDocument = db.collection("Posts").doc(event.postId);
    Stream<DocumentSnapshot> snapshot = postDocument.snapshots();

    // Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

    emit(
      state.copyWith(
        id: event.postId,
        postInfo: snapshot,
        // pictureLink: dataMap["image"],
        // title: dataMap["title"],
        // content: dataMap["content"],
        // categories: dataMap["category"],
        // likedBy: dataMap["likedBy"],
        // likes: dataMap["likes"],
        deletionStatus: DeletionStatus.initial,
      ),
    );
  }
}
