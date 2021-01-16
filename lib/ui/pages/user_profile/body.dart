import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/ui/widgets/widgets.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:graphx/graphx.dart';

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
          'Edit your profile',
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
    return Obx(
      () {
        if (authController.currentUser == null) {
          return Scaffold();
        }
        return Scaffold(
          bottomNavigationBar: Obx(
            () => !authController.currentUser.emailVerified
                ? SizedBox.shrink()
                : Container(
                    height: 50,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.resolveWith<OutlinedBorder>(
                          (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (states) => context.theme.errorColor,
                        ),
                      ),
                      onPressed: controller.deleteProfile,
                      icon: Icon(Icons.delete_forever),
                      label: Text('Delete Account'),
                    ),
                  ),
          ),
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
      },
    );
  }
}

class _BuildPhoto extends GetView<UserProfileController> {
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
        width: ProfilePicSize,
        height: ProfilePicSize,
        padding: EdgeInsets.all(15),
        child: Obx(
          () => CircleAvatar(
            key: ValueKey<int>(controller.counter),
            backgroundColor: context.theme.primaryColor,
            child: ClipOval(
              child: SizedBox(
                width: ProfilePicSize,
                height: ProfilePicSize,
                child: Material(
                  child: InkWell(
                    onTap: () => controller.pickPhoto(context),
                    child: controller.profilePic(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
