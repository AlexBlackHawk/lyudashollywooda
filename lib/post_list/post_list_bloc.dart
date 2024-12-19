import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'post_list_event.dart';
part 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  PostListBloc() : super(const PostListState()) {
    on<PostListFiltersChanged>(_onFiltersChanged);
    on<PostListFetched>(_onFetched);
    on<PostListAdLoadingChanged>(_onAdLoadingChanged);
    on<PostListVideoNotePressed>(_onVideoNotePressed);
    on<PostListVideoNoteLikeSet>(_onVideoNoteLikeSet);
    on<PostListVideoNoteLikeCanceled>(_onVideoNoteLikeCanceled);
    on<PostListVideoNoteDeleted>(_onVideoNoteDeleted);
    on<PostListRecordVideoNoteModeChanged>(_onRecordVideoNoteModeChanged);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;

  void _onRecordVideoNoteModeChanged(PostListRecordVideoNoteModeChanged event, Emitter<PostListState> emit) {
    emit(
      state.copyWith(
        isRecordVideoNoteMode: event.recordVideoNoteMode,
      ),
    );
  }

  Future<void> _onVideoNoteLikeSet(PostListVideoNoteLikeSet event, Emitter<PostListState> emit) async {
    db.collection("Posts")
        .doc(event.videoNoteId)
        .update({"likes": FieldValue.increment(1), "likedBy": FieldValue.arrayUnion([event.userId])});
    emit(
      state.copyWith(
        deletionStatus: VideoNoteDeletionStatus.initial,
      ),
    );
  }

  Future<void> _onVideoNoteLikeCanceled(PostListVideoNoteLikeCanceled event, Emitter<PostListState> emit) async {
    await db.collection("Posts")
        .doc(event.videoNoteId)
        .update({"likedBy": FieldValue.arrayRemove([event.userId])});
    emit(
      state.copyWith(
        deletionStatus: VideoNoteDeletionStatus.initial,
      ),
    );
  }

  void _onVideoNoteDeleted(PostListVideoNoteDeleted event, Emitter<PostListState> emit) {
    emit(state.copyWith(deletionStatus: VideoNoteDeletionStatus.inProgress));
    try {
      db.collection("Posts").doc(event.videoNoteId).collection("Comments").get().then((comments) {
        for (var comment in comments.docs) {
          db.collection("Posts").doc(event.videoNoteId).collection("Comments").doc(comment.id).collection("Replies").get().then((replies) {
            for (var reply in replies.docs) {
              db.collection("Posts").doc(event.videoNoteId).collection("Comments").doc(comment.id).collection("Replies").doc(reply.id).delete();
            }
          });
          db.collection("Posts").doc(event.videoNoteId).collection("Comments").doc(comment.id).delete();
        }});
      db.collection("Posts").doc(event.videoNoteId).delete();
      emit(state.copyWith(deletionStatus: VideoNoteDeletionStatus.success));
    }
    catch (e) {
      emit(state.copyWith(deletionStatus: VideoNoteDeletionStatus.failure));
    }
  }


  void _onVideoNotePressed(PostListVideoNotePressed event, Emitter<PostListState> emit) {
    String videoNoteValue = event.videoNoteId == state.selectedVideoNote ? "" : event.videoNoteId;

    emit(
      state.copyWith(
        selectedVideoNote: videoNoteValue,
      ),
    );
  }

  void _onAdLoadingChanged(PostListAdLoadingChanged event, Emitter<PostListState> emit) {
    bool isAdLoading = !state.isAdLoading;
    emit(
      state.copyWith(
        isAdLoading: isAdLoading,
      ),
    );
  }

  Future<void> _onFiltersChanged(PostListFiltersChanged event, Emitter<PostListState> emit) async {
    List<String> filters = List.from(state.filters);
    Stream<QuerySnapshot> fetchedPosts;
    if (event.isSelected) {
      filters.add(event.filter);
    }
    else {
      filters.remove(event.filter);
    }
    if (filters.isEmpty) {
      fetchedPosts = db.collection('Posts').orderBy('time', descending: true).snapshots();
    }
    else {
      fetchedPosts = db.collection('Posts').where("category", arrayContainsAny: filters).orderBy("time", descending: true).snapshots();
    }
    emit(
      state.copyWith(
        filters: filters,
        posts: fetchedPosts,
      ),
    );
  }

  Future<void> _onFetched(PostListFetched event, Emitter<PostListState> emit) async {
    Stream<QuerySnapshot> fetchedPosts = db.collection('Posts').orderBy('time', descending: true).snapshots();
    QuerySnapshot<Map<String, dynamic>>  fetchedAdmin = await db.collection("Users").where("role", isEqualTo: "admin").get();
    Map<String, dynamic> adminData = fetchedAdmin.docs.first.data();
    // DocumentSnapshot<Map<String, dynamic>> fetchedAdmin = await db.collection("Users").doc("7hlUwyI2FpO6B6pAJaFJLSHi3Ed2").get();
    // Map<String, dynamic> adminData = fetchedAdmin.data() as Map<String, dynamic>;
    emit(
      state.copyWith(
        posts: fetchedPosts,
        adminInfo: adminData,
      ),
    );
  }
}
