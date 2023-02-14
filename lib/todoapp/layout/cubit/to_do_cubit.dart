import 'package:chat_app/todoapp/layout/cubit/to_do_states.dart';
import 'package:chat_app/todoapp/screens/archive_screen.dart';
import 'package:chat_app/todoapp/screens/done_screen.dart';
import 'package:chat_app/todoapp/screens/new_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(ToDoInitialState());

  static ToDoCubit get(context) => BlocProvider.of(context);

  List <IconData>icons=[
    Icons.home,
    Icons.done,
    Icons.archive,
    Icons.archive,
  ];

  List<Widget> appBar=[
    const Text(
      'New Screen',
    ),
    const Text(
      'Done Screen',
    ),
    const Text(
      'Archive Screen',
    ),
  ];

  List<Widget> screens=[
    const NewScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];

  int currentIndex = 0;

  changeBottomNavigationBar(index) {
    currentIndex = index;
    emit(ToDoBottomNavigationSuccessState());
  }

  Database? database;

  createDatabase(){
     openDatabase(
        'database.db',
        version: 1,
      onCreate: (database,version){
          database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, status TEXT)').then((value){
            print('table created successfully');
          });
      },
       onOpen: (database){
          getDatabase(database);
          print('database opened ');
       }
    ).then((value){
      database=value;
      emit(ToDoTableCreatedSuccessfullyState());
     }).catchError((error){
       print(error.toString());
       emit(ToDoTableCreatedErrorState());
     });
  }

  insertIntoDatabase({
    required String taskName,
}){
    database?.transaction((txn){
     return txn.rawInsert('INSERT INTO Test(name, status) VALUES("$taskName","new")');
    }).then((value){
      print('$value inserted successfully');
      emit(ToDoTableInsertSuccessState());
      getDatabase(database);
    });
  }

  List newTasks=[];
  List doneTasks=[];
  List archiveTasks=[];

  getDatabase( database){
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
    emit(ToDoTableDataGetLoadingState());
    database.rawQuery('SELECT * FROM Test').then((value){
      value.forEach((element) {
        if(element['status']=="new"){
          newTasks.add(element);
        }else if(element['status']=='done'){
          doneTasks.add(element);
        }else{
          archiveTasks.add(element);
        }
      });
      print(value);
      emit(ToDoTableDataGetSuccessState());
    });
  }
}
