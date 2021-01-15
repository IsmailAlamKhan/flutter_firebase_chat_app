import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui.dart';

class Root extends StatelessWidget {
  const Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AuthService>(
      init: AuthService(),
      builder: (AuthService controller) {
        if (controller.user.value?.uid != null) {
          Get.put(UserProfileController());
          return UserProfile();
        } else {
          return Login();
        }
      },
    );
  }
}
