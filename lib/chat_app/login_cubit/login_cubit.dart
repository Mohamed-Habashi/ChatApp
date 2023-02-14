import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/chat_user_model.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  ChatUserModel ? chatUserModel;

  static LoginCubit get(context) => BlocProvider.of(context);

  userLogin({
    required String email,
    required String password,
    context,
  })  {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value)  {
          uId=value.user?.uid;
      emit(LoginSuccessState(uId!));
      AnimatedSnackBar.rectangle(
        'Success',
        'Login Successfully',
        duration: const Duration(milliseconds: 300),
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        brightness: Brightness.light,
      ).show(
        context,
      );
    }).catchError((e) {
      emit(LoginErrorState());
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

}
