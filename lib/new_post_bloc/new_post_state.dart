part of 'new_post_bloc.dart';

enum CreationStatus { initial, inProgress, success, failure }

enum RecordVideoNoteModeStatus { initial, launching, working, stopping }

final class NewPostState extends Equatable {
  const NewPostState({
    this.picturePath = "",
    this.title = "",
    this.content = "",
    this.postCategories = const <String>[],
    this.creationStatus = CreationStatus.initial,
    this.recordVideoNoteModeStatus = RecordVideoNoteModeStatus.initial,
    this.isRecording = false,
    this.isPaused = false,
    this.videoNotePath = "",
    this.videoPath = "",
    this.videoThumbnailPath = "",
    this.videoDuration = "",
  });

  final String picturePath;
  final String title;
  final String content;
  final List<String> postCategories;
  final CreationStatus creationStatus;
  final RecordVideoNoteModeStatus recordVideoNoteModeStatus;
  final bool isRecording;
  final bool isPaused;
  final String videoNotePath;
  final String videoPath;
  final String videoThumbnailPath;
  final String videoDuration;

  NewPostState copyWith({
    String? picturePath,
    String? title,
    String? content,
    List<String>? postCategories,
    CreationStatus? creationStatus,
    RecordVideoNoteModeStatus? recordVideoNoteModeStatus,
    bool? isRecording,
    bool? isPaused,
    String? videoNotePath,
    String? videoPath,
    String? videoThumbnailPath,
    String? videoDuration,
  }) {
    return NewPostState(
      picturePath: picturePath ?? this.picturePath,
      title: title ?? this.title,
      content: content ?? this.content,
      postCategories: postCategories ?? this.postCategories,
      creationStatus: creationStatus ?? this.creationStatus,
      recordVideoNoteModeStatus: recordVideoNoteModeStatus ?? this.recordVideoNoteModeStatus,
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      videoNotePath: videoNotePath ?? this.videoNotePath,
      videoPath: videoPath ?? this.videoPath,
      videoThumbnailPath: videoThumbnailPath ?? this.videoThumbnailPath,
      videoDuration: videoDuration ?? this.videoDuration,
    );
  }

  @override
  List<Object> get props => [
    picturePath,
    title,
    content,
    postCategories,
    creationStatus,
    recordVideoNoteModeStatus,
    isRecording,
    isPaused,
    videoNotePath,
    videoPath,
    videoThumbnailPath,
    videoDuration,
  ];
}

