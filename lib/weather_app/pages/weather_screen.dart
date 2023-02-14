import 'package:chat_app/const.dart';
import 'package:chat_app/weather_app/cubit/weather_cubit.dart';
import 'package:chat_app/weather_app/cubit/weather_state.dart';
import 'package:chat_app/weather_app/pages/weather_search.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit,WeatherStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTo(context, const WeatherSearchScreen());
                  },
                  icon: const Icon(
                    Icons.search
                  )
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: WeatherCubit.get(context).weatherModel!=null,
            builder: (context)=>Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      '${WeatherCubit.get(context).weatherModel!.sys!.country}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      '${WeatherCubit.get(context).weatherModel!.main!.temp}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      '${WeatherCubit.get(context).weatherModel!.weather![0].main}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900
                    ),
                  ),

                ],
              ),
            ),
            fallback: (context)=>const Center(child: CircularProgressIndicator(),),
          ),
        );
      },
    );
  }
}
