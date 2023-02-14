import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chat_app/chat_app/register_cubit/register_state.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/chat_user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    context,
  }) {
    emit(RegisterUserLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(name: name, email: email, phone: phone, uId: value.user!.uid);
      uId=value.user!.uid;
      emit(RegisterUserSuccessfullyState());
      AnimatedSnackBar.rectangle(
        'Success',
        'RegisterSuccessfully',
        duration: const Duration(milliseconds: 300),
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        brightness: Brightness.light,
      ).show(
        context,
      );
    }).catchError((e) {

      emit(RegisterUserErrorState());
      AnimatedSnackBar.rectangle('Error', e.toString(),
          duration: const Duration(milliseconds: 300),
          type: AnimatedSnackBarType.error,
          brightness: Brightness.light,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom)
          .show(
        context,
      );
    });
  }

  userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    ChatUserModel chatUserModel =
        ChatUserModel(name: name, email: email, phone: phone, uId: uId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(chatUserModel.toMap()!).then((value){
          emit(RegisterCreateUserSuccessfullyState());
    }).catchError((error){
      emit(RegisterCreateUserErrorState());
    });
  }
}
