import 'package:chat_app/const.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/pages/category_products_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state){
          return ConditionalBuilder(
            condition: ShopCubit.get(context).categoriesModel!=null,
            builder: (context)=>ListView.separated(
              itemBuilder: (context,index)=>buildCategoryList(ShopCubit.get(context).categoriesModel!.data!.data![index],context),
              separatorBuilder: (context,index){
                return const SizedBox(
                  height: 20,
                );
              },
              itemCount: ShopCubit.get(context).categoriesModel!.data!.data!.length,
            ),
            fallback: (context)=>const Center(child: CircularProgressIndicator(color: Colors.red,),),
          );
        },
    );
  }
}

Widget buildCategoryList(DataModel model,context){
  return InkWell(
    onTap: (){
      navigateTo(context, const CategoryProductsScreen());
      ShopCubit.get(context).getCategoryProducts(categoryId: model.id!);
    },
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image(
          width: double.infinity,
          height: 200,
          image: NetworkImage(model.image!),
          fit: BoxFit.fill,
        ),
        Container(
          height: 30,
          color: Colors.red.withOpacity(0.8),
          child: Center(
            child: Text(
              '${model.name}',
              style: const TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
