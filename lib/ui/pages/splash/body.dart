import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphx/graphx.dart';

class Splash extends GetView<SplashService> {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class SplashService extends GetxService {
  final GetStorage box = GetStorage();
  @override
  void onInit() {
    box.listenKey('onBoarding', (val) {
      trace(val);
      if (val != null) {
        Auth(authState: AuthState.Login).offAll(AuthBinding());
      } else {
        OnBoardingPage().offAll();
      }
    });
    super.onInit();
  }
}
