import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chat_app/const.dart';
import 'package:chat_app/todoapp/layout/cubit/to_do_cubit.dart';
import 'package:chat_app/todoapp/layout/cubit/to_do_states.dart';
import 'package:chat_app/weather_app/model/search_weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
var textController=TextEditingController();

var global=GlobalKey<FormState>();

class ToDoLayout extends StatelessWidget {
  const ToDoLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit=ToDoCubit.get(context);
    return BlocConsumer<ToDoCubit,ToDoStates>(
      listener: (context,state){},
      builder: (context,state){
        return Form(
          key: global,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: cubit.appBar[cubit.currentIndex],
            ),
            body: Column(
              children: [

              ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Add new task!!'),
                      content: defaultFormField(
                          controller: textController,
                          obscure: false,
                          keyboardType: TextInputType.text,
                          label: "Enter new task",
                          validator: (value){
                            if(value!.isEmpty){
                              return 'This field must not be empty';
                            }
                          }
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: (){
                            if(global.currentState!.validate()){
                              cubit.insertIntoDatabase(
                                  taskName: textController.text,

                              );
                              textController.clear();
                            }
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              child: const Icon(
                Icons.add,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              backgroundColor: Colors.grey,
                activeColor: Colors.blue,
                inactiveColor: Colors.black,
                icons: ToDoCubit.get(context).icons,
                activeIndex: ToDoCubit.get(context).currentIndex,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.verySmoothEdge,
                onTap: (index){
                  cubit.changeBottomNavigationBar(index);
                }
            ),
          ),
        );
      },
    );
  }
}
