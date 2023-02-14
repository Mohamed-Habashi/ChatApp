import 'package:chat_app/constants.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/login/login_screen.dart';
import 'package:chat_app/shop_app/pages/edit_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cache_helper.dart';
import '../../chat_app/pages/LoginScreen.dart';
import '../../const.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShopCubit cubit=ShopCubit.get(context);
    return  BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel!=null,
          builder: (context)=>Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 'Hi ${cubit.userModel!.data!.name}',
                 style: const TextStyle(
                   fontSize: 24
                 ),
                    ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'This is your data:'
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'email: ${cubit.userModel!.data!.email}'
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'phone: ${cubit.userModel!.data!.phone}'
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                          child: const Text(
                              'Edit',
                            style: TextStyle(
                              color: Colors.red
                            ),
                          ),
                          onPressed: (){
                            navigateTo(context, const EditProfile());
                          }
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        child:  const Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                        onPressed: (){
                          navigateTo(context, const EditProfile());
                        }
                    )
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                ConditionalBuilder(
                  condition: state is! ShopLogoutLoadingState,
                  builder: (context)=>Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                  color: Colors.red
                              ),
                            ),
                            onPressed: (){
                              ShopCubit.get(context).signOut(context);
                            }
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                          child:  const Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          onPressed: (){
                            ShopCubit.get(context).signOut(context);
                          }
                      )
                    ],
                  ),
                  fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.red,),),
                ),
              ],
            ),
          ),
          fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.red,),),
        );
      },
    );
  }
}
