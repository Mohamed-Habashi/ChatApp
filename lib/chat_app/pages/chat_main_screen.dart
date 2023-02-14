import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const.dart';
import '../../constants.dart';
import '../chat_cubit/chat_cubit.dart';
import '../chat_cubit/chat_states.dart';
import '../models/chat_user_model.dart';
import 'chat_details_screen.dart';

class ChatMainScreen extends StatefulWidget {
   const ChatMainScreen({Key? key}) : super(key: key);


  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChatCubit.get(context).getUserData(uId!);
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit,ChatStates>(
      listener: (context,state){
        if(state is ChatGetUserDataSuccessState){
          ChatCubit.get(context).getAllUsers();
        }
      },
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: const Text(
              'Users Screen',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: ListView.separated(
              itemBuilder: (context,index)=>buildMainChat(ChatCubit.get(context).users[index],context),
              separatorBuilder: (context,index)=>Container(height: 1,color: Colors.grey,),
              itemCount: ChatCubit.get(context).users.length,
          ),
        );
      },
    );
  }
}

Widget buildMainChat(ChatUserModel chatUserModel,context){
  return  InkWell(
    onTap: (){
      navigateTo(context, ChatDetailsScreen(chatUserModel: chatUserModel));
    },
    child: SizedBox(
      width: double.infinity,
      height: 80,
      child: Center(
        child: Text(
            '${chatUserModel.name}',
        ),
      ),
    ),
  );
}
