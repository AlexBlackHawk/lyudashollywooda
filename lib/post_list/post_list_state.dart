part of 'post_list_bloc.dart';

enum VideoNoteDeletionStatus { initial, inProgress, success, failure }

// enum VideoNoteCreationStatus { initial, inProgress, success, failure }

final class PostListState extends Equatable {
  const PostListState({
    this.posts,
    this.filters = const <String>[],
    this.adminInfo = const <String, dynamic>{},
    this.isAdLoading = false,
    this.selectedVideoNote = "",
    this.deletionStatus = VideoNoteDeletionStatus.initial,
    this.isRecordVideoNoteMode = false,
    // this.videoNoteCreationStatus = VideoNoteCreationStatus.initial,
  });

  final Stream<QuerySnapshot>? posts;
  final List<String> filters;
  final Map<String, dynamic> adminInfo;
  final bool isAdLoading;
  final String selectedVideoNote;
  final VideoNoteDeletionStatus deletionStatus;
  final bool isRecordVideoNoteMode;
  // final VideoNoteCreationStatus videoNoteCreationStatus;

  PostListState copyWith({
    Stream<QuerySnapshot>? posts,
    List<String>? filters,
    Map<String, dynamic>? adminInfo,
    bool? isAdLoading,
    String? selectedVideoNote,
    VideoNoteDeletionStatus? deletionStatus,
    bool? isRecordVideoNoteMode,
    // VideoNoteCreationStatus? videoNoteCreationStatus,
  }) {
    return PostListState(
      posts: posts ?? this.posts,
      filters: filters ?? this.filters,
      adminInfo: adminInfo ?? this.adminInfo,
      isAdLoading: isAdLoading ?? this.isAdLoading,
      selectedVideoNote: selectedVideoNote ?? this.selectedVideoNote,
      deletionStatus: deletionStatus ?? this.deletionStatus,
      isRecordVideoNoteMode: isRecordVideoNoteMode ?? this.isRecordVideoNoteMode,
      // videoNoteCreationStatus: videoNoteCreationStatus ?? this.videoNoteCreationStatus,
    );
  }

  @override
  List<Object?> get props => [
    posts,
    filters,
    adminInfo,
    isAdLoading,
    selectedVideoNote,
    deletionStatus,
    isRecordVideoNoteMode,
    // videoNoteCreationStatus
  ];
}
