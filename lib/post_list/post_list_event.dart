part of 'post_list_bloc.dart';

sealed class PostListEvent extends Equatable {
  const PostListEvent();

  @override
  List<Object?> get props => [];
}

final class PostListAdLoadingChanged extends PostListEvent {
  const PostListAdLoadingChanged();
}

final class PostListFetched extends PostListEvent {
  const PostListFetched();
}

final class PostListFiltersChanged extends PostListEvent {
  const PostListFiltersChanged({required this.filter, required this.isSelected});

  final String filter;
  final bool isSelected;

  @override
  List<Object> get props => [filter, isSelected];
}

final class PostListVideoNotePressed extends PostListEvent {
  const PostListVideoNotePressed({required this.videoNoteId});

  final String videoNoteId;

  @override
  List<Object> get props => [videoNoteId];
}

final class PostListVideoNoteLikeSet extends PostListEvent {
  const PostListVideoNoteLikeSet({required this.videoNoteId, required this.userId});

  final String videoNoteId;
  final String userId;

  @override
  List<Object> get props => [videoNoteId, userId];
}

final class PostListVideoNoteLikeCanceled extends PostListEvent {
  const PostListVideoNoteLikeCanceled({required this.videoNoteId, required this.userId});

  final String videoNoteId;
  final String userId;

  @override
  List<Object> get props => [videoNoteId, userId];
}

final class PostListVideoNoteDeleted extends PostListEvent {
  const PostListVideoNoteDeleted({required this.videoNoteId});

  final String videoNoteId;

  @override
  List<Object> get props => [videoNoteId];
}

final class PostListRecordVideoNoteModeChanged extends PostListEvent {
  const PostListRecordVideoNoteModeChanged({required this.recordVideoNoteMode});

  final bool recordVideoNoteMode;

  @override
  List<Object> get props => [recordVideoNoteMode];
}
