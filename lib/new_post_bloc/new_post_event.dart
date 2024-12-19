part of 'new_post_bloc.dart';

sealed class NewPostEvent extends Equatable {
  const NewPostEvent();

  @override
  List<Object> get props => [];
}

final class NewPostPictureChanged extends NewPostEvent {
  const NewPostPictureChanged({required this.picturePath});

  final String picturePath;

  @override
  List<Object> get props => [picturePath];
}

final class NewPostTitleChanged extends NewPostEvent {
  const NewPostTitleChanged({required this.title});

  final String title;

  @override
  List<Object> get props => [title];
}

final class NewPostContentChanged extends NewPostEvent {
  const NewPostContentChanged({required  this.content});

  final String content;

  @override
  List<Object> get props => [content];
}

final class NewPostCreated extends NewPostEvent {
  const NewPostCreated();
}

final class NewPostCategoryAdded extends NewPostEvent {
  const NewPostCategoryAdded({required this.postCategory});

  final String postCategory;

  @override
  List<Object> get props => [postCategory];
}

final class NewPostCategoryRemoved extends NewPostEvent {
  const NewPostCategoryRemoved({required this.postCategory});

  final String postCategory;

  @override
  List<Object> get props => [postCategory];
}

final class NewPostPausedChanged extends NewPostEvent {
  const NewPostPausedChanged({required this.isPaused});

  final bool isPaused;

  @override
  List<Object> get props => [isPaused];
}

final class NewPostRecordingChanged extends NewPostEvent {
  const NewPostRecordingChanged({required this.isRecording});

  final bool isRecording;

  @override
  List<Object> get props => [isRecording];
}

final class NewPostRecordVideoNoteModeStatusChanged extends NewPostEvent {
  const NewPostRecordVideoNoteModeStatusChanged({required this.recordVideoNoteModeStatus});

  final RecordVideoNoteModeStatus recordVideoNoteModeStatus;

  @override
  List<Object> get props => [recordVideoNoteModeStatus];
}

final class NewPostVideoNoteCreated extends NewPostEvent {
  const NewPostVideoNoteCreated();
}

final class NewPostVideoNoteChanged extends NewPostEvent {
  const NewPostVideoNoteChanged({required this.videoNotePath});

  final String videoNotePath;

  @override
  List<Object> get props => [videoNotePath];
}

final class NewPostVideoChanged extends NewPostEvent {
  const NewPostVideoChanged({required this.videoPath});

  final String videoPath;

  @override
  List<Object> get props => [videoPath];
}

final class NewPostVideoCreated extends NewPostEvent {
  const NewPostVideoCreated();
}

final class NewPostVideoThumbnailChanged extends NewPostEvent {
  const NewPostVideoThumbnailChanged({required this.videoThumbnailPath});

  final String videoThumbnailPath;

  @override
  List<Object> get props => [videoThumbnailPath];
}

final class NewPostVideoDurationChanged extends NewPostEvent {
  const NewPostVideoDurationChanged({required this.videoDuration});

  final String videoDuration;

  @override
  List<Object> get props => [videoDuration];
}