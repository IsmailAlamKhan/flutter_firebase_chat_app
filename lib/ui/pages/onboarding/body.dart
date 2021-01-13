import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';

class OnBoardingPage extends GetView<OnboardingController> {
  const OnBoardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'hero',
                  child: Image.asset(
                    '$ImagePath/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                10.0.sizedWidth,
                HeroText(
                  text: 'Ismail Chat App',
                  tag: 'Ismail Chat App',
                  style: context.textTheme.headline4,
                ),
              ],
            ),
            20.0.sizedHeight,
            CustomButton.login(
              onTap: () => Auth(
                authState: AuthState.Login,
              ).to(
                AuthBinding(),
              ),
            ),
            20.0.sizedHeight,
            CustomButton.regiser(
              onTap: () => Auth(
                authState: AuthState.Registration,
              ).to(
                AuthBinding(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
