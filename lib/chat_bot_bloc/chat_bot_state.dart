part of 'chat_bot_bloc.dart';

enum ChatsLoadingStatus { initial, inProgress, failure, success }
enum MessagesLoadingStatus { initial, inProgress, failure, success }

final class ChatBotState extends Equatable {
  const ChatBotState({
    this.query = "",
    this.imagePath = "",
    this.userChats,
    this.chatSession,
    this.chatMessages,
    this.chatId = "",
    this.chatsLoadingStatus = ChatsLoadingStatus.initial,
    this.messagesLoadingStatus = MessagesLoadingStatus.initial,
    this.imageSource,
  });

  final String query;
  final String imagePath;
  final Stream<QuerySnapshot>? userChats;
  final ChatSession? chatSession;
  final Stream<QuerySnapshot>? chatMessages;
  final String chatId;
  final ChatsLoadingStatus chatsLoadingStatus;
  final MessagesLoadingStatus messagesLoadingStatus;
  final ImageSource? imageSource;

  ChatBotState copyWith({
    String? query,
    String? imagePath,
    Stream<QuerySnapshot>? userChats,
    ChatSession? chatSession,
    Stream<QuerySnapshot>? chatMessages,
    String? chatId,
    ChatsLoadingStatus? chatsLoadingStatus,
    MessagesLoadingStatus? messagesLoadingStatus,
    ImageSource? imageSource,
  }) {
    return ChatBotState(
      query: query ?? this.query,
      imagePath: imagePath ?? this.imagePath,
      userChats: userChats ?? this.userChats,
      chatSession: chatSession ?? this.chatSession,
      chatMessages: chatMessages ?? this.chatMessages,
      chatId: chatId ?? this.chatId,
      chatsLoadingStatus: chatsLoadingStatus ?? this.chatsLoadingStatus,
      messagesLoadingStatus: messagesLoadingStatus ?? this.messagesLoadingStatus,
      imageSource: imageSource ?? this.imageSource,
    );
  }

  @override
  List<Object?> get props => [
    query,
    imagePath,
    userChats,
    chatSession,
    chatMessages,
    chatId,
    chatsLoadingStatus,
    messagesLoadingStatus,
    imageSource,
  ];
}
