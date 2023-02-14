import 'package:chat_app/const.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/dio_helper.dart';
import 'package:chat_app/end_points.dart';
import 'package:chat_app/shop_app/login/login_cubit/login_states.dart';
import 'package:chat_app/shop_app/models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>{
  ShopLoginCubit(): super(LoginInitialState());

  static ShopLoginCubit get(context)=>BlocProvider.of(context);

  LoginModel ?loginModel;

  userLogin({
    required String email,
    required String password,
}){

    emit(LoginLoadingState());
    DioHelper.postData(url: LOGIN, data: {
      'email':email,
      'password':password,
    },

    ).then((value){
      loginModel=LoginModel.fromJson(value.data);
      token=loginModel!.data!.token;
      emit(LoginSuccessState(loginModel!));
    }).catchError((error){
      showToast(message: loginModel!.message!,color: Colors.red);
      emit(LoginErrorState());
    });
  }
}