part of 'chat_bot_bloc.dart';

sealed class ChatBotEvent extends Equatable {
  const ChatBotEvent();

  @override
  List<Object> get props => [];
}

final class ChatBotQueryChanged extends ChatBotEvent {
  const ChatBotQueryChanged({required this.query});

  final String query;

  @override
  List<Object> get props => [query];
}

final class ChatBotImageChanged extends ChatBotEvent {
  const ChatBotImageChanged({required this.imagePath});

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}

final class ChatBotRequestSent extends ChatBotEvent {
  const ChatBotRequestSent({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

final class ChatBotNewChatCreated extends ChatBotEvent {}

final class ChatBotChatChanged extends ChatBotEvent {
  const ChatBotChatChanged({required this.chatId});

  final String chatId;

  @override
  List<Object> get props => [chatId];
}

final class ChatBotChatsLoaded extends ChatBotEvent {
  const ChatBotChatsLoaded({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}

final class ChatBotImageSourceChanged extends ChatBotEvent {
  const ChatBotImageSourceChanged({required this.imageSource});

  final ImageSource imageSource;

  @override
  List<Object> get props => [imageSource];
}
