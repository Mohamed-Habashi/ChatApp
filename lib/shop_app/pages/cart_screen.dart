import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const.dart';
import '../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ShopCubit.get(context).getCart();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: false,
            title: const Text(
              'CartScreen',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition:
            ShopCubit.get(context).cartModel != null,
            builder: (context) =>ShopCubit.get(context).cartModel!.data!.cartItems!.isEmpty?  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_shopping_cart,
                    size: 300,
                    color: Colors.red.withOpacity(0.5),
                  ),
                  const Text(
                    'Go to Home to add to cart',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ): ListView.separated(
              itemBuilder: (context, index) => getCart(
                  ShopCubit.get(context)
                      .cartModel!
                      .data!
                      .cartItems![index]
                      .product!,
                  context),
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: Colors.grey,
              ),
              itemCount:
              ShopCubit.get(context).cartModel!.data!.cartItems!.length,
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          ),
            bottomNavigationBar: ConditionalBuilder(
              condition: ShopCubit.get(context).cartModel!=null,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      'Total: ${ShopCubit.get(context).cartModel!.data!.total} L.E',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(child: defaultButton(label: 'check', function: (){}))
                  ],
                ),
              ),
              fallback: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            )
        );
      },
    );
  }

  Widget getCart(Product model, context) {
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
                ShopCubit.get(context).addToCart(
                    productId:
                    model.id!);
                ShopCubit.get(context).getCart();
              },
              icon: Icon(
                ShopCubit.get(context).cart[
                model.id]!
                    ? Icons.shopping_cart
                    : Icons.remove_shopping_cart,
                color: Colors.red,
              )
          ),
        ],
      ),
    );
  }
}
