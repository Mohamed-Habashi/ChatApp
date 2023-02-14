import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/const.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

int activeIndex = 0;

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
              'Product Details',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition: state is! ShopProductsDetailsLoadingState,
            builder: (context) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CarouselSlider(
                                items: ShopCubit.get(context)
                                    .productDetailsModel!
                                    .data!
                                    .images!
                                    .map((e) => Image(
                                          image: NetworkImage(e),
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
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        activeIndex = index;
                                      });
                                    },
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.3,
                                    scrollDirection: Axis.horizontal),
                              ),
                              AnimatedSmoothIndicator(
                                activeIndex: activeIndex,
                                count: ShopCubit.get(context)
                                    .productDetailsModel!
                                    .data!
                                    .images!
                                    .length,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    '${ShopCubit.get(context).productDetailsModel!.data!.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      ShopCubit.get(context).addToFavourites(
                                          productId: ShopCubit.get(context)
                                              .productDetailsModel!
                                              .data!
                                              .id!);
                                    },
                                    icon: Icon(
                                      ShopCubit.get(context).favourites[
                                              ShopCubit.get(context)
                                                  .productDetailsModel!
                                                  .data!
                                                  .id]!
                                          ? Icons.favorite_outlined
                                          : Icons.favorite_outline,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ReadMoreText(
                              '${ShopCubit.get(context).productDetailsModel!.data!.description}',
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: const TextStyle(fontSize: 18),
                              moreStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              lessStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            fallback: (context) => Container(),
          ),
          bottomNavigationBar: ConditionalBuilder(
            condition: state is! ShopProductsDetailsLoadingState &&
                ShopCubit.get(context).productDetailsModel != null,
            builder: (context) => ConditionalBuilder(
              condition: state is! ShopAddCartLoadingScreen,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: defaultButton(
                    label: ShopCubit.get(context).cart[ShopCubit.get(context)
                                .productDetailsModel!
                                .data!
                                .id] !=
                            true
                        ? 'Add to cart'
                        : 'Remove From cart',
                    function: () {
                      ShopCubit.get(context).addToCart(
                          productId: ShopCubit.get(context)
                              .productDetailsModel!
                              .data!
                              .id!);
                    }),
              ),
              fallback: (context) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
