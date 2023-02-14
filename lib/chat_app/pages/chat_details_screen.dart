import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../chat_cubit/chat_cubit.dart';
import '../chat_cubit/chat_states.dart';
import '../models/chat_user_model.dart';
import '../models/message_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key, required this.chatUserModel}) : super(key: key);
  ChatUserModel? chatUserModel;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        ChatCubit.get(context).getMessage(receiverId: chatUserModel!.uId!);
        return BlocConsumer<ChatCubit, ChatStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: Text(
                  '${chatUserModel?.name}',
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: ChatCubit.get(context).messages.length,
                      itemBuilder: (context, index) {
                        return buildMessage(
                            ChatCubit.get(context).messages[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 5,
                      ),
                    ),
                  ),
                  MessageBar(
                    onSend: (value) {
                      ChatCubit.get(context).sendMessage(
                          receiverId: chatUserModel!.uId!,
                          dateTime: DateTime.now().toString(),
                          text: value.toString(),

                      );
                    },
                    actions: [
                      InkWell(
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 24,
                        ),
                        onTap: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: InkWell(
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.green,
                            size: 24,
                          ),
                          onTap: () {
                            ChatCubit.get(context).getImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildMessage(MessageModel messageModel) {
  return  BubbleNormal(
    text: '${messageModel.text}',
    isSender: messageModel.senderId == chatUserModel!.uId ? true : false,
    color:
        messageModel.senderId == chatUserModel!.uId ? Colors.red : Colors.grey,
    tail: true,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  );
}
