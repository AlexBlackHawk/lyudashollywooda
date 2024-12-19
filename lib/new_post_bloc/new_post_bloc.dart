import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

part 'new_post_event.dart';
part 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  NewPostBloc() : super(const NewPostState()) {
    on<NewPostPictureChanged>(_onPictureChanged);
    on<NewPostTitleChanged>(_onTitleChanged);
    on<NewPostContentChanged>(_onContentChanged);
    on<NewPostCreated>(_onCreated);
    on<NewPostCategoryAdded>(_onCategoryAdded);
    on<NewPostCategoryRemoved>(_onCategoryRemoved);
    on<NewPostVideoNoteCreated>(_onVideoNoteCreated);
    on<NewPostRecordingChanged>(_onRecordingChanged);
    on<NewPostRecordVideoNoteModeStatusChanged>(_onRecordVideoNoteModeStatusChanged);
    on<NewPostPausedChanged>(_onPausedChanged);
    on<NewPostVideoNoteChanged>(_onVideoNoteChanged);
    on<NewPostVideoChanged>(_onVideoChanged);
    on<NewPostVideoCreated>(_onVideoCreated);
    on<NewPostVideoThumbnailChanged>(_onVideoThumbnailChanged);
    on<NewPostVideoDurationChanged>(_onVideoDurationChanged);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storageIns = FirebaseStorage.instance;

  void _onVideoDurationChanged(NewPostVideoDurationChanged event, Emitter<NewPostState> emit) {
    emit(
      state.copyWith(
        videoDuration: event.videoDuration,
      ),
    );
  }

  void _onVideoThumbnailChanged(NewPostVideoThumbnailChanged event, Emitter<NewPostState> emit) {
    emit(
      state.copyWith(
        videoThumbnailPath: event.videoThumbnailPath,
      ),
    );
  }

  Future<void> _onVideoCreated(NewPostVideoCreated event, Emitter<NewPostState> emit) async {
    emit(state.copyWith(creationStatus: CreationStatus.inProgress));
    try {
      final newPostRef = db.collection("Posts").doc();
      final newPostRefId = newPostRef.id;

      File videoFile = File(state.videoPath);
      String videoFileName = basename(videoFile.path);
      var videoSnapshot = await storageIns.ref().child("Posts/$newPostRefId/Video/").child(videoFileName).putFile(videoFile);
      String videoDownloadUrl = await videoSnapshot.ref.getDownloadURL();

      File videoThumbnailFile = File(state.videoThumbnailPath);
      String videoThumbnailFileName = basename(videoThumbnailFile.path);
      var videoThumbnailSnapshot = await storageIns.ref().child("Posts/$newPostRefId/Thumbnail/").child(videoThumbnailFileName).putFile(videoThumbnailFile);
      String videoThumbnailDownloadUrl = await videoThumbnailSnapshot.ref.getDownloadURL();

      Map<String, dynamic> postInfo = <String, dynamic>{
        "title": state.title,
        "content": state.content,
        // "likes": 0,
        "likedBy": [],
        "comments": 0,
        "category": state.postCategories,
        "type": "video",
        "time": FieldValue.serverTimestamp(),
        "video": videoDownloadUrl,
        "video thumbnail": videoThumbnailDownloadUrl,
        "video duration": state.videoDuration,
      };
      await newPostRef.set(postInfo);
      List<String> categories = List.from(state.postCategories);
      categories.clear();
      emit(
          state.copyWith(
            videoPath: "",
            title: "",
            content: "",
            videoDuration: "",
            videoThumbnailPath: "",
            postCategories: categories,
            creationStatus: CreationStatus.success,
          )
      );
    }
    catch (e) {
      emit(state.copyWith(creationStatus: CreationStatus.failure));
    }
  }

  void _onVideoChanged(NewPostVideoChanged event, Emitter<NewPostState> emit) {
    String video = event.videoPath;
    emit(
      state.copyWith(
        videoPath: video,
      ),
    );
  }

  void _onVideoNoteChanged(NewPostVideoNoteChanged event, Emitter<NewPostState> emit) {
    String videoNote = event.videoNotePath;
    emit(
      state.copyWith(
        videoNotePath: videoNote,
      ),
    );
  }

  void _onPausedChanged(NewPostPausedChanged event, Emitter<NewPostState> emit) {
    bool isPaused = event.isPaused;
    emit(
      state.copyWith(
        isPaused: isPaused,
      ),
    );
  }

  void _onRecordVideoNoteModeStatusChanged(NewPostRecordVideoNoteModeStatusChanged event, Emitter<NewPostState> emit) {
    emit(
      state.copyWith(
        recordVideoNoteModeStatus: event.recordVideoNoteModeStatus,
      ),
    );
  }

  void _onRecordingChanged(NewPostRecordingChanged event, Emitter<NewPostState> emit) {
    bool isRecording = event.isRecording;
    emit(
      state.copyWith(
        isRecording: isRecording,
      ),
    );
  }

  void _onVideoNoteCreated(NewPostVideoNoteCreated event, Emitter<NewPostState> emit) async {
    emit(state.copyWith(creationStatus: CreationStatus.inProgress));
    try {
      File file = File(state.videoNotePath);
      String fileName = basename(file.path);
      final newPostRef = db.collection("Posts").doc();
      final newPostRefId = newPostRef.id;
      var snapshot = await storageIns.ref().child("Posts/$newPostRefId/").child(fileName).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> postInfo = {
        "video note": downloadUrl,
        "time": FieldValue.serverTimestamp(),
        "type": "video note",
        // "likes": 0,
        "likedBy": [],
        "comments": 0,
        "category": state.postCategories,
      };
      await newPostRef.set(postInfo);
      List<String> categories = List.from(state.postCategories);
      categories.clear();
      emit(
          state.copyWith(
            videoNotePath: "",
            postCategories: categories,
            creationStatus: CreationStatus.success,
          )
      );
    } catch (e) {
      emit(state.copyWith(creationStatus: CreationStatus.failure));
    }
  }

  void _onCategoryAdded(NewPostCategoryAdded event, Emitter<NewPostState> emit) {
    List<String> categories = List.from(state.postCategories);
    categories.add(event.postCategory);
    emit(
      state.copyWith(
        postCategories: categories,
        creationStatus: CreationStatus.initial,
      ),
    );
  }

  void _onCategoryRemoved(NewPostCategoryRemoved event, Emitter<NewPostState> emit) {
    List<String> categories = List.from(state.postCategories);
    categories.remove(event.postCategory);
    emit(
      state.copyWith(
        postCategories: categories,
        creationStatus: CreationStatus.initial,
      ),
    );
  }

  void _onPictureChanged(NewPostPictureChanged event, Emitter<NewPostState> emit) {
    final picturePath = event.picturePath;
    emit(
      state.copyWith(
        picturePath: picturePath,
      ),
    );
  }

  void _onTitleChanged(NewPostTitleChanged event, Emitter<NewPostState> emit) {
    final title = event.title;
    emit(
      state.copyWith(
        title: title,
        creationStatus: CreationStatus.initial,
      ),
    );
  }

  void _onContentChanged(NewPostContentChanged event, Emitter<NewPostState> emit) {
    String content = event.content;
    emit(
      state.copyWith(
        content: content,
        creationStatus: CreationStatus.initial,
      ),
    );
  }

  void _onCreated(NewPostCreated event, Emitter<NewPostState> emit) async {
    emit(state.copyWith(creationStatus: CreationStatus.inProgress));
    try {
      File file = File(state.picturePath);
      String fileName = basename(file.path);
      final newPostRef = db.collection("Posts").doc();
      final newPostRefId = newPostRef.id;
      var snapshot = await storageIns.ref().child("Posts/$newPostRefId/").child(fileName).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> postInfo = <String, dynamic>{
        "title": state.title,
        "content": state.content,
        "likes": 0,
        "likedBy": [],
        "comments": 0,
        "category": state.postCategories,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "image": downloadUrl,
      };
      await newPostRef.set(postInfo);
      List<String> categories = List.from(state.postCategories);
      categories.clear();
      emit(
        state.copyWith(
          picturePath: "",
          title: "",
          content: "",
          postCategories: categories,
          creationStatus: CreationStatus.success,
        )
      );
    }
    catch (e) {
      emit(state.copyWith(creationStatus: CreationStatus.failure));
    }
  }
}
