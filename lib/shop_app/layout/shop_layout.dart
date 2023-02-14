import 'package:chat_app/cache_helper.dart';
import 'package:chat_app/chat_app/pages/LoginScreen.dart';
import 'package:chat_app/const.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_cubit.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/pages/cart_screen.dart';
import 'package:chat_app/shop_app/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;

import '../../constants.dart';

class ShopLayout extends StatefulWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  State<ShopLayout> createState() => _ShopLayoutState();
}

class _ShopLayoutState extends State<ShopLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ShopCubit.get(context).getProfile(token: token!);
  }
  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: cubit.appBar[cubit.currentIndex],
            actions: [
              IconButton(
                  onPressed: () {
                    navigateTo(context, const SearchScreen());
                  },
                  icon: const Icon(
                    Icons.search,
                  )),
              IconButton(
                  onPressed: () {
                    navigateTo(context, const CartScreen());
                  },
                  icon: const Icon(
                    Icons.add_shopping_cart_outlined,
                  )),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ShopCubit.get(context).currentIndex,
            onTap: (index) {
              ShopCubit.get(context).changeNavigationBottom(index);
            },
            items: ShopCubit.get(context).bottomNavigationItem,
            selectedItemColor: Colors.red,
            elevation: 0,
            unselectedItemColor: Colors.black,
          ),
        );
      },
    );
  }
}
