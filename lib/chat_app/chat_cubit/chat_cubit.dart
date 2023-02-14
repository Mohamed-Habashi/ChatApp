import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_user_model.dart';
import '../models/message_model.dart';
import 'chat_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

ChatUserModel? chatUserModel;

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  List<ChatUserModel> users = [];

  getUserData(String id) {
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      chatUserModel = ChatUserModel.fromJson(value.data()!);
      emit(ChatGetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ChatGetUserDataErrorState());
    });
  }

  getAllUsers() {
    users = [];
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['uId'] != chatUserModel!.uId) {
          users.add(ChatUserModel.fromJson(element.data()));
        }
      }
      emit(ChatGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ChatGetAllUsersErrorState());
    });
  }

  sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
    String ? image,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: chatUserModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
      image: image?? '',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(chatUserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(ChatMessageSentSuccessState());
    }).catchError((error) {
      emit(ChatMessageSentErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(chatUserModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(ChatMessageSentSuccessState());
    }).catchError((error) {
      emit(ChatMessageSentErrorState());
    });
  }

  List<MessageModel> messages = [];

  getMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(chatUserModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(ChatGetMessageSuccessState());
    });
  }

  File? postImage;
  var picker = ImagePicker();
  Future<void> getPostImage({
  required String receiverId,
    required String dateTime
}) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);

      emit(ChatImageGetSuccessfullyState());
      uploadImage(
        receiverId: receiverId,
        dateTime: dateTime,
      );
    } else {
      emit(ChatImageGetErrorState());
    }
  }



  void uploadImage({
  required String receiverId,
    required String dateTime,
}) {
    emit(UploadImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!).then((value){
          value.ref.getDownloadURL().then((value) {
            sendMessage(receiverId: receiverId, dateTime: dateTime, text: '',image: value);
          });
    });
  }
}
