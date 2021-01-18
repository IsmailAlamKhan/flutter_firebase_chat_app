import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/utils/index.dart';

const double ProfilePicSize = 200;

class UserProfilePic extends StatelessWidget {
  UserProfilePic({
    Key key,
    this.profilePicSize,
    this.profilePic,
    this.isUserProfile = false,
    this.onTap,
    this.counter,
  }) : super(
          key: key,
        );
  final double profilePicSize;
  final AuthService authController = Get.find();
  final Widget profilePic;
  final bool isUserProfile;
  final Function onTap;
  final int counter;

  Widget _profilePic() {
    if (authController.currentUser?.photoURL != null &&
        authController.currentUser?.photoURL != '') {
      return CachedNetworkImage(
        imageUrl: authController.currentUser?.photoURL,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Image.asset(
      '$ImagePath/defaultDark.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: profilePicSize ?? ProfilePicSize,
      height: profilePicSize ?? ProfilePicSize,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => CircleAvatar(
            key: isUserProfile ? ValueKey<int>(counter) : null,
            backgroundColor: context.theme.primaryColor.withOpacity(.5),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipOval(
                child: profilePic ?? _profilePic(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
