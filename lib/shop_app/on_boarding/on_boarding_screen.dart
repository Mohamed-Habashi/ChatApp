import 'package:chat_app/cache_helper.dart';
import 'package:chat_app/const.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/login_screen.dart';

var pageController=PageController();
bool isLast=false;
class BoardingModel {
  String? image;
  String? title;
  String? body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/shopping1.webp',
      title: 'Screen title1',
      body: 'body1',
    ),
    BoardingModel(
      image: 'assets/images/shopping2.jpg',
      title: 'Screen title2',
      body: 'body2',
    ),
    BoardingModel(
      image: 'assets/images/shopping3.jpg',
      title: 'Screen title3',
      body: 'body3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: (){
                CacheHelper.saveData(key: 'onBoarding', value: 'clicked').then((value){
                  navigateToFinish(context, const ShopLoginScreen());
                });
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index){
                  if(index==boarding.length-1){
                    setState(() {
                      isLast=true;
                    });
                  }else{
                    setState(() {
                      isLast=false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return buildOnBoarding(boarding[index]);
                },
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: pageController,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.red,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4,
                      spacing: 5
                    ),
                    count: boarding.length,
                ),
                const Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    if(isLast){
                      CacheHelper.saveData(key: 'onBoarding', value: 'clicked').then((value){
                        navigateToFinish(context, const ShopLoginScreen());
                      });
                    }
                    pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.bounceInOut);
                  },
                  child:  Icon(
                    isLast?Icons.check:Icons.arrow_forward_ios,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildOnBoarding(BoardingModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          child: Image(
              image: AssetImage('${model.image}'),

          )),
      const SizedBox(
        height: 30,
      ),
      Text(
        '${model.title}',
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Text(
        '${model.body}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
    ],
  );
}
