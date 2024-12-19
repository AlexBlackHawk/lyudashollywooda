part of 'chat_bloc.dart';

enum VideoNoteCreationStatus { initial, inProgress, success, failure }

final class ChatState extends Equatable {
  const ChatState({
    this.message = "",
    this.chatRoomId = "",
    this.messages,
    this.chats,
    this.chatCompanionInfo,
    this.isNewChatRoomCreated = false,
    this.searchedChats,
    this.isRecordVideoNoteMode = false,
    this.isRecording = false,
    this.isPaused = false,
    this.videoNotePath = "",
    this.selectedImage = "",
    this.selectedVideoNote = "",
    this.videoNoteCreationStatus = VideoNoteCreationStatus.initial,
  });

  final String message;
  final String chatRoomId;
  final Stream<QuerySnapshot>? messages;
  final Stream<QuerySnapshot>? chats;
  final Stream<DocumentSnapshot<Map<String, dynamic>>>? chatCompanionInfo;
  final bool isNewChatRoomCreated;
  final Stream<QuerySnapshot>? searchedChats;
  final bool isRecordVideoNoteMode;
  final bool isRecording;
  final bool isPaused;
  final String videoNotePath;
  final String selectedImage;
  final String selectedVideoNote;
  final VideoNoteCreationStatus videoNoteCreationStatus;

  ChatState copyWith({
    String? message,
    String? chatRoomId,
    Stream<QuerySnapshot>? messages,
    Stream<QuerySnapshot>? chats,
    Stream<DocumentSnapshot<Map<String, dynamic>>>? chatCompanionInfo,
    bool? isNewChatRoomCreated,
    Stream<QuerySnapshot>? searchedChats,
    bool? isRecordVideoNoteMode,
    bool? isRecording,
    bool? isPaused,
    String? videoNotePath,
    String? selectedImage,
    String? selectedVideoNote,
    VideoNoteCreationStatus? videoNoteCreationStatus,
  }) {
    return ChatState(
      message: message ?? this.message,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      messages: messages ?? this.messages,
      chats: chats ?? this.chats,
      chatCompanionInfo: chatCompanionInfo ?? this.chatCompanionInfo,
      isNewChatRoomCreated: isNewChatRoomCreated ?? this.isNewChatRoomCreated,
      searchedChats: searchedChats ?? this.searchedChats,
      isRecordVideoNoteMode: isRecordVideoNoteMode ?? this.isRecordVideoNoteMode,
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      videoNotePath: videoNotePath ?? this.videoNotePath,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedVideoNote: selectedVideoNote ?? this.selectedVideoNote,
      videoNoteCreationStatus: videoNoteCreationStatus ?? this.videoNoteCreationStatus,
    );
  }

  @override
  List<Object?> get props => [
    message,
    chatRoomId,
    messages,
    chats,
    chatCompanionInfo,
    isNewChatRoomCreated,
    searchedChats,
    isRecordVideoNoteMode,
    isRecording,
    isPaused,
    videoNotePath,
    selectedImage,
    selectedVideoNote,
    videoNoteCreationStatus,
  ];
}

