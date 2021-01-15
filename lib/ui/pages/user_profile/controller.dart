import 'dart:developer';

import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

class UserProfileController extends GetxController {
  final AuthService authController = Get.find();
  TextEditingController displayNameTEC;
  TextEditingController emailTEC;
  final TextEditingController passwordTEC = TextEditingController();

  Future<void> onSave() async {
    final _user = UserModel(
      displayName: displayNameTEC.text,
      email: emailTEC.text,
      id: authController.currentUser.uid,
      emailVerified: authController.currentUser.emailVerified,
    );
    trace(_user.id);
    await authController.updateUser(_user);
  }

  @override
  void onInit() {
    displayNameTEC = TextEditingController(
      text: authController.currentUser.displayName,
    );
    emailTEC = TextEditingController(
      text: authController.currentUser.email,
    );
    super.onInit();
  }
}
