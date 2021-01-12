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
                Text(
                  'Ismail Chat App',
                  style: context.textTheme.headline4,
                ),
              ],
            ),
            20.0.sizedHeight,
            CustomButton.login(
              onTap: () => Auth(
                authState: AuthState.Login,
              ).to(AuthBinding()),
            ),
            20.0.sizedHeight,
            CustomButton.regiser(
              onTap: () => Auth(
                authState: AuthState.Registration,
              ).to(AuthBinding()),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.onTap,
    this.text,
  }) : super(key: key);
  CustomButton.login({this.onTap}) : text = 'Login';
  CustomButton.regiser({this.onTap}) : text = 'Register';

  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        onPressed: onTap,
        minWidth: 200,
        height: 45,
        child: Text(text),
        elevation: 10,
      ),
    );
  }
}
