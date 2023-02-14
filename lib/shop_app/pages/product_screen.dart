import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/const.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/models/products_model.dart';
import 'package:chat_app/shop_app/pages/product_details_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


var page = PageController();
int activeIndex = 0;

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: ShopCubit.get(context).productModel != null,
            builder: (context) {
              return homeBuilder(ShopCubit.get(context).productModel!, context);
            },
            fallback: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ));
      },
    );
  }

  Widget homeBuilder(ProductModel productModel, context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                items: productModel.data!.banners!
                    .map((e) => Image(
                          image: NetworkImage(e.image!),
                        ))
                    .toList(),
                options: CarouselOptions(
                    height: 250,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal),
              ),
              AnimatedSmoothIndicator(
                activeIndex: activeIndex,
                count:
                    ShopCubit.get(context).productModel!.data!.banners!.length,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 1.6,
              children: List.generate(
                productModel.data!.products!.length,
                (index) => buildGrid(productModel.data!.products![index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGrid(Products products) {
    return InkWell(
      onTap: (){
        ShopCubit.get(context).getProductDetails(productId: products.id!);
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
                  image: NetworkImage(products.image!),
                  width: double.infinity,
                ),
                if(products.discount!=0)
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
                    '${products.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${products.price.round()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                ShopCubit.get(context).addToFavourites(productId: products.id!);
                              },
                              icon: Icon(
                                ShopCubit.get(context).favourites[products.id]!?Icons.favorite_outlined:Icons.favorite_outline,
                                color: Colors.red,
                              )
                          ),
                          IconButton(
                              onPressed: (){
                                ShopCubit.get(context).addToCart(productId: products.id!);
                                ShopCubit.get(context).getCart();
                              },
                              icon: Icon(
                                ShopCubit.get(context).cart[
                                products.id]!
                                    ? Icons.shopping_cart
                                    : Icons.remove_shopping_cart,
                                color: Colors.red,
                              )
                          ),
                        ],
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
