
import 'package:chat_app/cache_helper.dart';
import 'package:chat_app/shop_app/layout/shop_layout.dart';
import 'package:chat_app/shop_app/register/register_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const.dart';
import '../../constants.dart';
import 'login_cubit/login_cubit.dart';
import 'login_cubit/login_states.dart';

var mailController=TextEditingController();
var passController=TextEditingController();
var globalKey=GlobalKey<FormState>();
class ShopLoginScreen extends StatelessWidget {
  const ShopLoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return  BlocProvider(
      create: (BuildContext context)=>ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context,state){
          if(state is LoginSuccessState){
            if(state.loginModel.status==true){

              CacheHelper.saveData(key: 'token', value: token!).then((value){
                showToast(
                  message: state.loginModel.message!,
                );
                navigateToFinish(context, const ShopLayout());
              });

            }else{
              showToast(
                  message: state.loginModel.message!,
                color: Colors.red,
              );
            }
          }
        },
        builder: (context,state){
          return Form(
            key: globalKey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                title: const Text(
                  'Login Screen',
                ),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'this field must\'t not be empty';
                            }
                            return null;
                          },
                          controller: mailController,
                          decoration: InputDecoration(
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email_outlined,color: Colors.red,),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'this field must\'t be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                                color: Colors.red
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.key,color: Colors.red,),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context){
                              return defaultButton(
                                  label: 'Login',
                                  function: (){
                                    if(globalKey.currentState!.validate()){
                                      ShopLoginCubit.get(context).userLogin(email: mailController.text, password: passController.text);
                                      mailController.clear();
                                      passController.clear();
                                    }
                                  }
                              );
                            },
                            fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.red,))
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Text(
                                'Don\'t have an account ?'
                            ),
                            TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return const RegisterScreen();
                                }));
                              }
                              , child: const Text(
                              'register',
                              style: TextStyle(
                                  color: Colors.red
                              ),
                            ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
