import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../index.dart';

class Root extends StatelessWidget {
  Root({Key key}) : super(key: key);
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
      init: AuthService(),
      builder: (AuthService controller) {
        if (controller.user.value?.uid != null) {
          Get.put(HomeController());
          return Home();
        } else {
          return Auth(
            authState: AuthState.Login,
          );
        }
      },
    );
  }
}
