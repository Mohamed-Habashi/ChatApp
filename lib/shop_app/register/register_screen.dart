import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const.dart';
import 'register_cubit/register_cubit.dart';
import 'register_cubit/register_states.dart';


var nameController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();
var passwordController = TextEditingController();
var formKey=GlobalKey<FormState>();
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                title: const Text('Register Screen'),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Register',
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
                          controller: nameController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'this field mustn\'t be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Name',
                            labelStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            prefixIcon: const Icon(
                              Icons.account_circle_outlined,
                              color: Colors.red,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'this field mustn\'t be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.red,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: passwordController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'this field mustn\'t be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.red),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.red,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: phoneController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'this field mustn\'t be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: 'Phone',
                            labelStyle: const TextStyle(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.red,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                              label: 'Register',
                              function: () {
                                if(formKey.currentState!.validate()){

                                }
                              }),
                          fallback: (context) =>
                          const Center(child: CircularProgressIndicator(
                            color: Colors.red,
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account ?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.red,
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
