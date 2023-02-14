import 'package:chat_app/shop_app/models/category_products_model.dart';
import 'package:chat_app/shop_app/pages/product_details_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const.dart';
import '../layout/cubit/shop_cubit.dart';
import '../layout/cubit/shop_states.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: false,
        title: const Text(
          'CategoryProducts',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is! ShopCategoryDetailsLoadingState&& ShopCubit.get(context).categoryProductsModel!=null,
              builder: (context) {
                return homeBuilder(ShopCubit.get(context).categoryProductsModel!, context);
              },
              fallback: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ));
        },
      ),
    );
  }

  Widget homeBuilder(CategoryProductsModel productModel, context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 1.6,
              children: List.generate(
                productModel.data!.data!.length,
                    (index) => buildGrid(productModel.data!.data![index],context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGrid(DataModel model,context) {
    return InkWell(
      onTap: (){
        ShopCubit.get(context).getProductDetails(productId: model.id!);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  height: 200,
                  image: NetworkImage(model.image!),
                  width: double.infinity,
                ),
                if(model.discount!=0)
                  Container(
                    color: Colors.red,
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      if(model.price!=model.oldPrice)
                        Text(
                          '${model.oldPrice}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
