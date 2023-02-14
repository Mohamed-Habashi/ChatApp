import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/weather_app/model/search_weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const.dart';

var nameController = TextEditingController();
var mail = TextEditingController();
var phoneController = TextEditingController();
var passController=TextEditingController();

var formKey=GlobalKey<FormState>();

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = ShopCubit.get(context).userModel;
        nameController.text = userModel!.data!.name!;
        mail.text = userModel.data!.email!;
        phoneController.text = userModel.data!.phone!;
        return Form(
          key: formKey,
          child: Scaffold(
            appBar:
            defaultAppBar(context: context, title: 'Edit Profile', action: [
              TextButton(
                onPressed: () {
                  if(formKey.currentState!.validate()){
                    ShopCubit.get(context).updateUserData(
                        name: nameController.text,
                        password: passController.text,
                        email: mail.text,
                        phone: phoneController.text
                    );
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ]),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(state is ShopUpdateUserLoadingState)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 5,
                      ),
                      defaultFormField(
                        controller: nameController,
                        obscure: false,
                        prefixIcon: const Icon(
                          Icons.person,
                        ),
                        keyboardType: TextInputType.text,
                        label: 'Name',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'name must not be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        obscure: false,
                        prefixIcon: const Icon(
                          Icons.phone,
                        ),
                        keyboardType: TextInputType.text,
                        label: 'Name',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'phone must not be empty';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: mail,
                        obscure: false,
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
                        keyboardType: TextInputType.text,
                        label: 'email',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'email must not be empty';
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultFormField(
                        controller: passController,
                        obscure: true,
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
                        keyboardType: TextInputType.text,
                        label: 'Enter password to confirm',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pass must not be empty';
                          }
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
