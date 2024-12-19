import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<ChatMessageChanged>(_onMessageChanged);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatAllChatsFetched>(_onAllChatsFetched);
    on<ChatRoomCreated>(_onRoomCreated);
    on<ChatRoomFullInfoFetched>(_onRoomFullInfoFetched);
    on<ChatImageSent>(_onImageSent);
    on<ChatChatsFound>(_onChatsFound);
    on<ChatMessageViewedChanged>(_onMessageViewedChanged);
    on<ChatVideoNoteSent>(_onVideoNoteSent);
    on<ChatRecordingChanged>(_onRecordingChanged);
    on<ChatRecordVideoNoteModeChanged>(_onRecordVideoNoteModeChanged);
    on<ChatPausedChanged>(_onPausedChanged);
    on<ChatVideoNoteChanged>(_onVideoNoteChanged);
    on<ChatImageChanged>(_onImageChanged);
    on<ChatVideoNotePressed>(_onVideoNotePressed);
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storageIns = FirebaseStorage.instance;

  void _onVideoNotePressed(ChatVideoNotePressed event, Emitter<ChatState> emit) {
    String videoNoteValue = event.videoNoteId == state.selectedVideoNote ? "" : event.videoNoteId;

    emit(
      state.copyWith(
        selectedVideoNote: videoNoteValue,
      ),
    );
  }

  void _onVideoNoteChanged(ChatVideoNoteChanged event, Emitter<ChatState> emit) {
    String videoNote = event.videoNotePath;
    emit(
      state.copyWith(
        videoNotePath: videoNote,
      ),
    );
  }

  void _onPausedChanged(ChatPausedChanged event, Emitter<ChatState> emit) {
    bool isPaused = event.isPaused;
    emit(
      state.copyWith(
        isPaused: isPaused,
      ),
    );
  }

  void _onRecordVideoNoteModeChanged(ChatRecordVideoNoteModeChanged event, Emitter<ChatState> emit) {
    bool isRecordVideoNote = event.isRecordVideoNote;
    emit(
      state.copyWith(
        isRecordVideoNoteMode: isRecordVideoNote,
      ),
    );
  }

  void _onRecordingChanged(ChatRecordingChanged event, Emitter<ChatState> emit) {
    bool isRecording = event.isRecording;
    emit(
      state.copyWith(
        isRecording: isRecording,
      ),
    );
  }

  void _onMessageViewedChanged(ChatMessageViewedChanged event, Emitter<ChatState> emit) async {
    await db.collection("Chat rooms").doc(event.chatId).collection("Messages").doc(event.messageId).update({"isWatched": true,});
  }

  void _onVideoNoteSent(ChatVideoNoteSent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(videoNoteCreationStatus: VideoNoteCreationStatus.inProgress));
    try {

    } catch (e) {
      emit(state.copyWith(videoNoteCreationStatus: VideoNoteCreationStatus.failure));
    }
    File file = File(state.videoNotePath);
    String fileName = basename(file.path);
    String chatId = state.chatRoomId;
    final newMessageRef = db.collection("Chat rooms").doc(chatId).collection("Messages").doc();
    final newMessageRefId = newMessageRef.id;
    var snapshot = await storageIns.ref().child("Chats/$chatId/$newMessageRefId/").child(fileName).putFile(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    Map<String, dynamic> chatMessageData = {
      "sendBy": event.senderId,
      "url": downloadUrl,
      "time": FieldValue.serverTimestamp(),
      "type": "video note",
      "isWatched": false,
    };
    newMessageRef.set(chatMessageData);
    Map<String, dynamic> dataUpdate = <String, dynamic>{
      "last message": "",
      "time": FieldValue.serverTimestamp(),
    };
    db.collection("Chat rooms").doc(chatId).update(dataUpdate);
    emit(
      state.copyWith(
        videoNotePath: "",
        videoNoteCreationStatus: VideoNoteCreationStatus.success,
      )
    );
  }

  void _onImageChanged(ChatImageChanged event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        selectedImage: event.selectedImage,
      ),
    );
  }

  void _onImageSent(ChatImageSent event, Emitter<ChatState> emit) async {
    File file = File(state.selectedImage);
    String fileName = basename(file.path);
    String chatId = state.chatRoomId;

    final newMessageRef = db.collection("Chat rooms").doc(chatId).collection("Messages").doc();
    final newMessageRefId = newMessageRef.id;
    var snapshot = await storageIns.ref().child("Chats/$chatId/$newMessageRefId/").child(fileName).putFile(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    Map<String, dynamic> chatMessageData = {
      "sendBy": event.senderId,
      "url": downloadUrl,
      "time": FieldValue.serverTimestamp(),
      "type": "image",
      "isWatched": false,
    };
    newMessageRef.set(chatMessageData);
    Map<String, dynamic> dataUpdate = <String, dynamic>{
      "last message": "",
      "time": FieldValue.serverTimestamp(),
    };
    db.collection("Chat rooms").doc(chatId).update(dataUpdate);
    emit(
      state.copyWith(
        selectedImage: "",
      ),
    );
  }

  void _onChatsFound(ChatChatsFound event, Emitter<ChatState> emit) async {
    final String query = event.query;
    final searchUsers = await db.collection("Users").where("name", isGreaterThanOrEqualTo: query).where("name", isLessThanOrEqualTo: "$query\uf7ff").get();
    final List<String> userIds = searchUsers.docs.map((e) => e.id).toList();
    final searchedChats = db.collection("Chat rooms").where("users", arrayContainsAny: userIds).snapshots();
    emit(
      state.copyWith(
        searchedChats: searchedChats,
      )
    );
  }

  void _onRoomFullInfoFetched(ChatRoomFullInfoFetched event, Emitter<ChatState> emit) async {
    final String chatRoomId = event.chatRoomId;
    DocumentSnapshot chatRoom = await db.collection("Chat rooms").doc(event.chatRoomId).get();
    Map<String, dynamic> chatRoomData = chatRoom.data() as Map<String, dynamic>;
    final companionData = db.collection("Users").doc(chatRoomData["users"][0] == event.userId ? chatRoomData["users"][1] : chatRoomData["users"][0]).snapshots();
    // final data = userSnapshot.data() as Map<String, dynamic>;
    Stream<QuerySnapshot> messages = db.collection("Chat rooms").doc(event.chatRoomId).collection("Messages").orderBy('time').snapshots();
    emit(
      state.copyWith(
        chatRoomId: chatRoomId,
        chatCompanionInfo: companionData,
        messages: messages,
      ),
    );
  }

  void _onRoomCreated(ChatRoomCreated event, Emitter<ChatState> emit) async {
    QuerySnapshot<Map<String, dynamic>>  fetchedAdmin = await db.collection("Users").where("role", isEqualTo: "admin").get();
    String adminId = fetchedAdmin.docs.first.id;
    Map<String, dynamic> chatRoom = <String, dynamic>{
      'users': [event.firstCompanionId, adminId],
      'last message': null,
      'time': FieldValue.serverTimestamp(),
    };
    DocumentReference snapshot = await db.collection("Chat rooms").add(chatRoom);
    emit(
      state.copyWith(
        chatRoomId: snapshot.id,
        isNewChatRoomCreated: true,
      ),
    );
  }

  void _onAllChatsFetched(ChatAllChatsFetched event, Emitter<ChatState> emit) {
    Stream<QuerySnapshot> chatRooms = db.collection("Chat rooms").orderBy('time', descending: true).snapshots();
    emit(
      state.copyWith(
        chats: chatRooms,
      ),
    );
  }

  void _onMessageChanged(ChatMessageChanged event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        message: event.message,
      ),
    );
  }

  void _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) {
    Map<String, dynamic> chatMessageData = {
      "sendBy": event.senderId,
      "message": state.message,
      "time": FieldValue.serverTimestamp(),
      "type": "text",
      "isWatched": false,
    };

    db.collection("Chat rooms").doc(state.chatRoomId).collection("Messages").add(chatMessageData);
    Map<String, dynamic> dataUpdate = <String, dynamic>{
      "last message": state.message,
      "time": FieldValue.serverTimestamp(),
    };
    db.collection("Chat rooms").doc(state.chatRoomId).update(dataUpdate);

    emit(
      state.copyWith(
        message: "",
      ),
    );
  }
}
