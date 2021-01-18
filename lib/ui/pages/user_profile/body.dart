import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/statemangement/services/index.dart';
import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';

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
          appBar: DefaultAppBar(
            title: Text(
              'Edit your profile',
              style: context.textTheme.headline6,
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
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  20.0.sizedHeight,
                  Hero(
                    tag: 'user_profile',
                    child: Obx(
                      () {
                        trace(controller.imagePicked);
                        return UserProfilePic(
                          counter: controller.counter,
                          isUserProfile: true,
                          onTap: () => controller.pickPhoto(context),
                          profilePic: controller.imagePicked
                              ? Image.file(controller.image)
                              : null,
                        );
                      },
                    ),
                  ),
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
