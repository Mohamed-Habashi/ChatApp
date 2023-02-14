import 'package:chat_app/const.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/dio_helper.dart';
import 'package:chat_app/end_points.dart';
import 'package:chat_app/shop_app/layout/cubit/shop_states.dart';
import 'package:chat_app/shop_app/models/cart_model.dart';
import 'package:chat_app/shop_app/models/categories_model.dart';
import 'package:chat_app/shop_app/models/category_products_model.dart';
import 'package:chat_app/shop_app/models/favourites_model.dart';
import 'package:chat_app/shop_app/models/product_details_model.dart';
import 'package:chat_app/shop_app/models/products_model.dart';
import 'package:chat_app/shop_app/models/shop_user_model.dart';
import 'package:chat_app/shop_app/pages/category_screen.dart';
import 'package:chat_app/shop_app/pages/farourites_screen.dart';
import 'package:chat_app/shop_app/pages/product_screen.dart';
import 'package:chat_app/shop_app/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cache_helper.dart';
import '../../login/login_screen.dart';
import '../../models/searchModel.dart';

class ShopCubit extends Cubit<ShopStates>{
  ShopCubit(): super(ShopInitialState());

  static ShopCubit get(context)=>BlocProvider.of(context);

  int currentIndex=0;
  List<BottomNavigationBarItem> bottomNavigationItem=[
    const BottomNavigationBarItem(
      icon:Icon(
          Icons.home,
      ),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon:Icon(
          Icons.category,
      ),
      label: 'Category',
    ),
    const BottomNavigationBarItem(
      icon:Icon(
          Icons.favorite,
      ),
      label: 'Favourite',
    ),
    const BottomNavigationBarItem(
      icon:Icon(
          Icons.settings,
      ),
      label: 'Settings',
    ),
  ];

  List<Widget> screens=[
    const ProductScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    const SettingsScreen(),
  ];

  List appBar=[
    const Text(
      'HomeScreen',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    const Text(
      'CategoriesScreen',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    const Text(
      'FavouritesScreen',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    const Text(
      'SettingsScreen',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ];

  changeNavigationBottom(index){
    currentIndex=index;
    if(index==1){
      getCategoryData();
      emit(ShopChangeBottomSuccessState());
    }else if (index==2){
      getFavourites();
      emit(ShopChangeBottomSuccessState());
    }else{
      emit(ShopChangeBottomSuccessState());
    }

  }
  ProductModel ? productModel;

  Map<int,bool?>favourites={};
  Map<int,bool?>cart={};
  getHomeData(){

    emit(ShopHomeLoadingState());
    DioHelper.getData(url: HOME,token: token).then((value) {
      productModel=ProductModel.fromJson(value.data);
      productModel!.data!.products!.forEach((element) {
        favourites.addAll(
          {
            element.id!:element.inFavorites,
          }
        );
        cart.addAll(
          {
            element.id!:element.inCart,
          }
        );
      });
      emit(ShopHomeSuccessState());
    }).catchError((error){
      emit(ShopHomeErrorState());
    });
  }

  CategoriesModel ?categoriesModel;
  getCategoryData(){
    emit(ShopCategoryLoadingState());
    DioHelper.getData(
        url: CATEGORIES,
      token: token,
    ).then((value){
      categoriesModel=CategoriesModel.fromJson(value.data);
      emit(ShopCategorySuccessState());
    }).catchError((error){
      emit(ShopCategoryErrorState());
    });
  }

  CategoryProductsModel ? categoryProductsModel;
  getCategoryProducts({
    required int categoryId,
}){
    emit(ShopCategoryDetailsLoadingState());
    DioHelper.getData(
        url: PRODUCTS,
      token: token,
      query: {
          'category_id':categoryId,
      }
    ).then((value){
      categoryProductsModel=CategoryProductsModel.fromJson(value.data);
      emit(ShopCategoryDetailsSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(ShopCategoryDetailsErrorState());
    });
  }

  ProductDetailsModel? productDetailsModel;

  getProductDetails({
    required int productId,
}){
    emit(ShopProductsDetailsLoadingState());
    DioHelper.getData(
        url: '$PRODUCTS/$productId',
      token: token,
    ).then((value){
      productDetailsModel=ProductDetailsModel.fromJson(value.data);
      emit(ShopProductsDetailsSuccessState());
    }).catchError((error){
      emit(ShopProductsDetailsErrorState());
    });
  }

  FavouritesModel ? favouritesModel;

  addToFavourites({
    required int productId
}){
    favourites[productId]=!favourites[productId]!;
    emit(ShopAddFavouritesLoadingScreen());
    DioHelper.postData(
        url: FAVOURITES,
        token: token,
        data: {
          'product_id':productId,
        }
    ).then((value) {
      emit(ShopAddFavouritesSuccessScreen());
    }).catchError((error){
      emit(ShopAddFavouritesErrorScreen());
    });
  }

  getFavourites(){
    emit(ShopGetFavouritesLoadingScreen());
    DioHelper.getData(
        url: FAVOURITES,
      token: token,
    ).then((value) {
      favouritesModel=FavouritesModel.fromJson(value.data);
      emit(ShopGetFavouritesSuccessScreen());
    }).catchError((error){
      emit(ShopGetFavouritesErrorScreen());
    });
  }


  addToCart({
    required int productId,
}){
    cart[productId]=!cart[productId]!;
    emit(ShopAddCartLoadingScreen());
    DioHelper.postData(
        url: CART,
        token: token,
        data: {
          'product_id':productId,
        }
    ).then((value) {
      emit(ShopAddCartSuccessScreen());
      showToast(
          message: value.data['message']
      );
    }).catchError((error){
      emit(ShopAddCartErrorScreen());
    });
  }

  CartModel ? cartModel;
  getCart(){
    emit(ShopGetCartLoadingScreen());
    DioHelper.getData(
        url: CART,
      token: token,
    ).then((value) {
      cartModel=CartModel.fromJson(value.data);
      emit(ShopGetCartSuccessScreen());
    }).catchError((error){
     emit(ShopGetCartErrorScreen());
    });
  }

  ShopUserModel ?userModel;

  getProfile({
    required String token
}){
    emit(ShopGetUserLoadingState());
    DioHelper.getData(
        url: PROFILE,
      token: token,
    ).then((value) {
      userModel=ShopUserModel.fromJson(value.data);
      print(userModel!.data!.name);
      emit(ShopGetUserSuccessState());
    }).catchError((error){
      emit(ShopGetUserErrorState());
    });
  }

  updateUserData({
    required String name,
    required String password,
    required String email,
    required String phone,
}){
    emit(ShopUpdateUserLoadingState());
    DioHelper.putData(
        url: UPDATEPROFILE,
        token: token,
        data: {
          'name':name,
          'phone':phone,
          'email':email,
          'password':password,
          'image':'https://student.valuxapps.com/storage/uploads/users/6hJOGUt7hS_1675605090.jpeg',
        }
    ).then((value) {
      userModel=ShopUserModel.fromJson(value.data);
      print(userModel!.data!.email);
      emit(ShopUpdateUserSuccessState());
      getProfile(token: token!);
    }).catchError((error){
      print(error.toString());
      emit(ShopUpdateUserErrorState());
    });

  }

  SearchModel ? searchModel;

  searchData({
    required String text,
  }){
    emit(ShopSearchLoadingState());
    DioHelper.postData(
        url: 'products/search',
        token: token,
        data: {
          'text':text,
        }
    ).then((value){
      searchModel=SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessState());
    }).catchError((error){
      emit(ShopSearchErrorState());
    });
  }

  signOut(context){
    emit(ShopLogoutLoadingState());
    CacheHelper.removeKey(key: 'token').then((value) {
      emit(ShopLogoutSuccessState());
      showToast(message: 'Logout Successfully');
      navigateToFinish(context, const ShopLoginScreen());
    }).catchError((error){
      emit(ShopLogoutErrorState());
    });
  }


}