import 'package:chat_app/shop_app/models/login_model.dart';

abstract class ShopLoginStates{}

class LoginInitialState extends ShopLoginStates{}

class LoginLoadingState extends ShopLoginStates{}

class LoginSuccessState extends ShopLoginStates{
  final LoginModel loginModel;

  LoginSuccessState(this.loginModel);
}

class LoginErrorState extends ShopLoginStates{}