part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

final class ChatAllChatsFetched extends ChatEvent {
  const ChatAllChatsFetched();
}

final class ChatMessageChanged extends ChatEvent {
  const ChatMessageChanged({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

final class ChatVideoNoteChanged extends ChatEvent {
  const ChatVideoNoteChanged({required this.videoNotePath});

  final String videoNotePath;

  @override
  List<Object> get props => [videoNotePath];
}

final class ChatMessageSent extends ChatEvent {
  const ChatMessageSent({required this.senderId});

  final String senderId;

  @override
  List<Object> get props => [senderId];
}

final class ChatRoomCreated extends ChatEvent {
  const ChatRoomCreated({required this.firstCompanionId});

  final String firstCompanionId;

  @override
  List<Object> get props => [firstCompanionId];
}

final class ChatRoomFullInfoFetched extends ChatEvent {
  const ChatRoomFullInfoFetched({required this.chatRoomId, required this.userId});

  final String chatRoomId;
  final String userId;

  @override
  List<Object> get props => [chatRoomId, userId];
}

final class ChatImageChanged extends ChatEvent {
  const ChatImageChanged({required this.selectedImage});

  final String selectedImage;

  @override
  List<Object> get props => [selectedImage];
}

final class ChatImageSent extends ChatEvent {
  const ChatImageSent({required this.senderId});

  final String senderId;

  @override
  List<Object> get props => [senderId];
}

final class ChatVideoNoteSent extends ChatEvent {
  const ChatVideoNoteSent({required this.senderId});

  final String senderId;

  @override
  List<Object> get props => [senderId];
}

final class ChatChatsFound extends ChatEvent {
  const ChatChatsFound({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}

final class ChatPausedChanged extends ChatEvent {
  const ChatPausedChanged({required this.isPaused});

  final bool isPaused;

  @override
  List<Object> get props => [isPaused];
}

final class ChatRecordingChanged extends ChatEvent {
  const ChatRecordingChanged({required this.isRecording});

  final bool isRecording;

  @override
  List<Object> get props => [isRecording];
}

final class ChatRecordVideoNoteModeChanged extends ChatEvent {
  const ChatRecordVideoNoteModeChanged({required this.isRecordVideoNote});

  final bool isRecordVideoNote;

  @override
  List<Object> get props => [isRecordVideoNote];
}

final class ChatMessageViewedChanged extends ChatEvent {
  const ChatMessageViewedChanged({required this.chatId, required this.messageId});

  final String chatId;
  final String messageId;

  @override
  List<Object> get props => [chatId, messageId];
}

final class ChatVideoNotePressed extends ChatEvent {
  const ChatVideoNotePressed({required this.videoNoteId});

  final String videoNoteId;

  @override
  List<Object> get props => [videoNoteId];
}