import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/ui/widgets/widgets.dart';
import 'package:firebase_chat_app/utils/utils.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthService authController;
  final UserProfileController controller;
  _AppBar({
    this.authController,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!authController.currentUser.emailVerified) {
        return AppBar(
          title: GestureDetector(
            onTap: () async => await authController.verifyEmail(),
            child: Text(
              'Click here to verify your email',
              style: TextStyle(
                color: context.theme.errorColor,
              ),
            ),
          ),
        );
      }
      return AppBar(
        title: Text(
          'Edit your profiles',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: controller.onSave,
            tooltip: 'Save profile',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: authController.logOut,
            tooltip: 'Log Out',
          ),
        ],
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class UserProfile extends GetView<UserProfileController> {
  final AuthService authController = Get.find();
  UserProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(
        controller: controller,
        authController: authController,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.0.sizedHeight,
              _BuildPhoto(),
              20.0.sizedHeight,
              Padding(
                padding: 20.0.padLEFT,
                child: DefaultTextField(
                  label: 'Username',
                  tec: controller.displayNameTEC,
                ),
              ),
              20.0.sizedHeight,
              Padding(
                padding: 20.0.padLEFT,
                child: DefaultTextField(
                  label: 'Email',
                  tec: controller.emailTEC,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildPhoto extends StatelessWidget {
  const _BuildPhoto({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey.shade300,
              spreadRadius: -50,
            )
          ],
          gradient: LinearGradient(
            colors: [
              context.theme.primaryColor.withOpacity(.5),
              Colors.white,
            ],
            end: Alignment(2.0, 0.0),
          ),
          shape: BoxShape.circle,
        ),
        width: 200,
        height: 200,
        padding: EdgeInsets.all(15),
        child: CircleAvatar(
          backgroundColor: context.theme.primaryColor,
          backgroundImage: AssetImage('$ImagePath/defaultDark.png'),
        ),
      ),
    );
  }
}
