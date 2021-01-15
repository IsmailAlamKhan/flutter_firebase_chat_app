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
      initState: (_) {
        Get.put(UserProfileController());
      },
      builder: (AuthService controller) {
        if (controller.user.value?.uid != null) {
          return UserProfile();
        } else {
          return Login();
        }
      },
    );
  }
}
