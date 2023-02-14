import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/models/favourites_model.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
              ShopCubit.get(context).favouritesModel != null,
          builder: (context) =>ShopCubit.get(context).favouritesModel!.data!.data!.isEmpty?  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border_outlined,
                  size: 300,
                  color: Colors.red.withOpacity(0.5),
                ),
                const Text(
                  'Go to Home to add favourites',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ): ListView.separated(
            itemBuilder: (context, index) => getFavourites(
                ShopCubit.get(context)
                    .favouritesModel!
                    .data!
                    .data![index]
                    .product!,
                context),
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Colors.grey,
            ),
            itemCount:
                ShopCubit.get(context).favouritesModel!.data!.data!.length,
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }

  Widget getFavourites(Product model, context) {
    return SizedBox(
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
          const Spacer(),
          IconButton(
              onPressed: () {
                ShopCubit.get(context).addToFavourites(
                    productId:
                        model.id!);
                ShopCubit.get(context).getFavourites();
              },
              icon: Icon(
                ShopCubit.get(context).favourites[
                       model.id]!
                    ? Icons.favorite_outlined
                    : Icons.favorite_outline,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}
