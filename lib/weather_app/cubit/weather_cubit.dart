import 'package:chat_app/const.dart';
import 'package:chat_app/dio_helper.dart';
import 'package:chat_app/weather_app/cubit/weather_state.dart';
import 'package:chat_app/weather_app/model/search_weather_model.dart';
import 'package:chat_app/weather_app/model/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
class WeatherCubit extends Cubit<WeatherStates>{

  WeatherCubit():super(WeatherInitialState());

  static WeatherCubit get(context)=>BlocProvider.of(context);


   determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Geolocator.getCurrentPosition().then((value){
      getWeatherData(lat: value.latitude, lon: value.longitude);
      emit(WeatherGetLocationSuccessState());
    });
  }

  WeatherModel? weatherModel;

  getWeatherData({
    required dynamic lat,
    required dynamic lon,
}){
     emit(WeatherGetWeatherDataLoadingState());
     DioHelper.getData(
         url: 'https://api.openweathermap.org/data/2.5/weather',
       query: {
           'lat':lat,
         'lon':lon,
         'appid':'99fb63e4767ce6544bcea1da297a9b6d',
         'units': 'metric',
       }
     ).then((value){
       weatherModel=WeatherModel.fromJson(value.data);
       emit(WeatherGetWeatherDataSuccessState());
     }).catchError((error){
       emit(WeatherGetWeatherDataErrorState());
     });
  }

  SearchWeatherModel ? searchWeatherModel;

  searchWeather({
    required String city_name,
}){
    emit(WeatherSearchWeatherDataLoadingState());
    DioHelper.getData(
        url: 'https://api.openweathermap.org/data/2.5/weather',
      query: {
          'q':city_name,
        'appid':'99fb63e4767ce6544bcea1da297a9b6d',
        'units': 'metric',
      }
    ).then((value){
      weatherModel=WeatherModel.fromJson(value.data);
      emit(WeatherSearchWeatherDataSuccessState());
    }).catchError((error){
      showToast(message: 'City not found',color: Colors.red);
      emit(WeatherSearchWeatherDataErrorState());
    });
  }
}