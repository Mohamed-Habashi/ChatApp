import 'package:chat_app/const.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/models/searchModel.dart';
import 'package:chat_app/shop_app/pages/product_details_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
var searchController=TextEditingController();

bool isSearch=false;
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                defaultFormField(
                    controller: searchController,
                    obscure: false,
                    keyboardType: TextInputType.text,
                    label: 'Search',
                    onChange: (value){
                      ShopCubit.get(context).searchData(text: searchController.text);
                      setState(() {
                        isSearch=!isSearch;
                      });
                    },
                    validator: (value){
                      return null;
                    }
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: ShopCubit.get(context).searchModel!=null,
                    builder: (context)=>ListView.separated(
                      itemBuilder: (context,index)=>searchData(ShopCubit.get(context).searchModel!.data!.data![index], context),
                      separatorBuilder: (context,index)=>Container(height: 1,color: Colors.grey,),
                      itemCount: ShopCubit.get(context).searchModel!.data!.data!.length,
                    ),
                    fallback:  (context)=>!isSearch?Container():const Center(child: CircularProgressIndicator(color: Colors.red,),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchData(DataModel model, context) {
    return InkWell(
      onTap: (){
        ShopCubit.get(context).getProductDetails(productId: model.id!);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: 100,
              height: 150,
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: Text(
                '${model.name}',
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
