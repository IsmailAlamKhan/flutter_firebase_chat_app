import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';

class OnBoardingPage extends GetView<OnboardingController> {
  const OnBoardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 100,
              right: 0,
              left: 0,
              child: Center(
                child: Hero(
                  tag: 'hero',
                  child: Image.asset(
                    '$ImagePath/logo.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              left: 100,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroText(
                    text: 'Ismail Chat App',
                    tag: 'Ismail Chat App',
                    style: context.textTheme.headline4,
                  ),
                  20.0.sizedHeight,
                  Text(
                    'Online Calls and\nmesseging made easy',
                    style: context.textTheme.headline6.copyWith(
                      color: context.textTheme.headline6.color.withOpacity(.6),
                    ),
                  ),
                  20.0.sizedHeight,
                  Text(
                    'We will Provide all best call\nstreaming in one click',
                    style: context.textTheme.subtitle2.copyWith(
                      color: context.textTheme.subtitle2.color.withOpacity(.3),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: CustomButton(
                  tag: 'GetStarted',
                  text: 'Get Started',
                  onTap: () {
                    GetStorage box = GetStorage();
                    box.write('onBoarding', true);
                    Auth(
                      authState: AuthState.Registration,
                    ).offAll(
                      AuthBinding(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
