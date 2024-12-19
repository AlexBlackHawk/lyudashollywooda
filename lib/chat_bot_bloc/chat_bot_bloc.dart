import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

part 'chat_bot_event.dart';
part 'chat_bot_state.dart';

class ChatBotBloc extends Bloc<ChatBotEvent, ChatBotState> {
  ChatBotBloc() : super(ChatBotState()) {
    on<ChatBotRequestSent>(_onRequestSent);
    on<ChatBotImageChanged>(_onImageChanged);
    on<ChatBotQueryChanged>(_onQueryChanged);
    on<ChatBotNewChatCreated>(_onNewChatCreated);
    on<ChatBotChatChanged>(_onChatChanged);
    on<ChatBotChatsLoaded>(_onChatsLoaded);
    on<ChatBotImageSourceChanged>(_onImageSourceChanged);
  }

  final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-1.5-flash');
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final storageIns = FirebaseStorage.instance;

  void _onImageSourceChanged(ChatBotImageSourceChanged event, Emitter<ChatBotState> emit) {
    emit(
      state.copyWith(
        imageSource: event.imageSource,
      ),
    );
  }

  void _onChatsLoaded(ChatBotChatsLoaded event, Emitter<ChatBotState> emit) {
    emit(state.copyWith(chatsLoadingStatus: ChatsLoadingStatus.inProgress));
    try {
      final Stream<QuerySnapshot> chatBotRoomsStream = db.collection('Chat Bot Rooms').where("user", isEqualTo: event.userId).orderBy("time", descending: true).snapshots();
      emit(
        state.copyWith(
          userChats: chatBotRoomsStream,
          chatsLoadingStatus: ChatsLoadingStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(chatsLoadingStatus: ChatsLoadingStatus.failure));
    }
  }

  Future<void> _onChatChanged(ChatBotChatChanged event, Emitter<ChatBotState> emit) async {
    emit(state.copyWith(messagesLoadingStatus: MessagesLoadingStatus.inProgress));
    try {
      final Query messagesCollection = db.collection("Chat Bot Rooms").doc(event.chatId).collection("Messages").orderBy("time");
      final Stream<QuerySnapshot> messagesStream = messagesCollection.snapshots();
      final QuerySnapshot messages = await messagesCollection.get();
      List<Content> geminiMessages = messages.docs.map((message) {
        Map<String, dynamic> messageMap = message.data() as Map<String, dynamic>;
        if (messageMap.containsKey("images")) {
          List<FileData> imageParts = messageMap["images"].map((image) async {
            final imageReference = storageIns.refFromURL(image);
            final metadata = await imageReference.getMetadata();
            final mimeType = metadata.contentType;
            final bucket = imageReference.bucket;
            final fullPath = imageReference.fullPath;
            final storageUrl = 'gs://$bucket/$fullPath';
            return FileData(mimeType ?? "image/jpeg", storageUrl);
          }).toList();
          final prompt = TextPart(messageMap["prompt"]);
          return Content.multi([prompt, ...imageParts]);
        } else {
          return Content.text(messageMap["prompt"]);
        }
      }).toList();
      final chat = model.startChat(
        history: geminiMessages,
      );
      emit(
        state.copyWith(
          chatId: event.chatId,
          chatMessages: messagesStream,
          chatSession: chat,
          messagesLoadingStatus: MessagesLoadingStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(messagesLoadingStatus: MessagesLoadingStatus.failure));
    }
  }

  void _onNewChatCreated(ChatBotNewChatCreated event, Emitter<ChatBotState> emit) {
    emit(
      state.copyWith(
        chatSession: null,
        chatMessages: null,
        chatId: "",
      ),
    );
  }

  Future<void> _onRequestSent(ChatBotRequestSent event, Emitter<ChatBotState> emit) async {
    final chatBotRoomReference = db.collection("Chat Bot Rooms").doc(state.chatId.isEmpty ? null : state.chatId);
    final chatBotRoomMessagesReference = chatBotRoomReference.collection("Messages");
    final chatBotRoomUserMessageReference = chatBotRoomMessagesReference.doc();
    final chatBotRoomBotMessageReference = chatBotRoomMessagesReference.doc();

    chatBotRoomUserMessageReference.set({"is user": true,});
    chatBotRoomBotMessageReference.set({"is user": false,});

    List<Content> prompt = <Content>[];

    if (state.chatId.isEmpty) {
      chatBotRoomReference.set({"user": event.userId});
      final Stream<QuerySnapshot> messagesStream = chatBotRoomReference.collection("Messages").orderBy("time").snapshots();
      emit(state.copyWith(
        chatMessages: messagesStream,
        chatId: chatBotRoomReference.id,
      ));
    }

    if (state.imagePath.isNotEmpty) {
      File file = File(state.imagePath);
      String fileName = basename(file.path);
      final imageReference = storageIns.ref().child("Chat Bots/${chatBotRoomReference.id}/${chatBotRoomUserMessageReference.id}/$fileName");
      var snapshot = await imageReference.putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await chatBotRoomUserMessageReference.update({
        "time": FieldValue.serverTimestamp(),
        "query": state.query,
        "images": [downloadUrl],
      });
      final metadata = await imageReference.getMetadata();
      final mimeType = metadata.contentType;
      final bucket = imageReference.bucket;
      final fullPath = imageReference.fullPath;
      final queryText = TextPart(state.query);
      final storageUrl = 'gs://$bucket/$fullPath';
      final filePart = FileData(mimeType ?? "image/jpeg", storageUrl);
      prompt.add(Content.multi([queryText, filePart]));
    } else {
      await chatBotRoomUserMessageReference.update({
        "time": FieldValue.serverTimestamp(),
        "query": state.query,
      });
      prompt.add(Content.text(state.query));
      // content = Content.text("");
    }

    await chatBotRoomReference.update({
      "last message": state.query,
      "time": FieldValue.serverTimestamp(),
      "is generating message": true,
    });

    await chatBotRoomBotMessageReference.update({
      "time": FieldValue.serverTimestamp(),
      "answer": "",
      "is generating message": true,
    });

    final response = await model.generateContent(prompt);

    await chatBotRoomBotMessageReference.update({
      "time": FieldValue.serverTimestamp(),
      "answer": response.text ?? "",
      "is generating message": false,
    });

    await chatBotRoomReference.update({
      "last message": response.text ?? "",
      "time": FieldValue.serverTimestamp(),
      "is generating message": false,
    });
    emit(
      state.copyWith(
        query: "",
        imagePath: "",
      ),
    );
  }

  void _onImageChanged(ChatBotImageChanged event, Emitter<ChatBotState> emit) {
    emit(
      state.copyWith(
        imagePath: event.imagePath,
      ),
    );
  }

  void _onQueryChanged(ChatBotQueryChanged event, Emitter<ChatBotState> emit) {
    emit(
      state.copyWith(
        query: event.query,
      ),
    );
  }
}
