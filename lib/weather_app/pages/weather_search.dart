import 'package:chat_app/const.dart';
import 'package:chat_app/weather_app/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';

var searchController=TextEditingController();

class WeatherSearchScreen extends StatelessWidget {
  const WeatherSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            defaultFormField(
                controller: searchController,
                obscure: false,
                keyboardType: TextInputType.text,
                label: 'search for city',
                validator: (value){
                  return null;
                },
              suffixIcon: IconButton(
                  onPressed: (){
                    WeatherCubit.get(context).searchWeather(city_name: searchController.text);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.search
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
