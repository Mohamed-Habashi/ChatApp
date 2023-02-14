import 'dart:io';

import 'package:chat_app/chat_app/chat_cubit/chat_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/shop_layout.dart';
import 'package:chat_app/shop_app/login/login_screen.dart';
import 'package:chat_app/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:chat_app/todoapp/layout/cubit/to_do_cubit.dart';
import 'package:chat_app/todoapp/layout/todo_layout.dart';
import 'package:chat_app/weather_app/cubit/weather_cubit.dart';
import 'package:chat_app/weather_app/pages/weather_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'cache_helper.dart';
import 'chat_app/pages/LoginScreen.dart';
import 'chat_app/pages/chat_main_screen.dart';
import 'constants.dart';
import 'dio_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();


  Widget widget;
  DioHelper.init();
  uId=CacheHelper.getData(key: 'uId');

  var onBoarding=CacheHelper.getData(key: 'onBoarding');

  token=CacheHelper.getData(key: 'token');

  // if(onBoarding=='clicked'){
  //   if(token==null){
  //     widget=const ShopLoginScreen();
  //   }else{
  //     widget=const ShopLayout();
  //   }
  // }else{
  //   widget=OnBoardingScreen();
  // }



  if (uId == null || uId == '') {
    widget = const LoginScreen();
  } else {
    widget =  const ChatMainScreen();
  }
  runApp(MyApp(
    startPage: widget,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key,required this.startPage});
   Widget ?startPage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>ShopCubit()..getHomeData()),
          BlocProvider(create: (context)=>ChatCubit()),
          BlocProvider(create: (context)=>WeatherCubit()..determinePosition()),
          BlocProvider(create:(context)=>ToDoCubit()..createDatabase()),
        ],
        child:  MaterialApp(
          home: startPage,
        ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}