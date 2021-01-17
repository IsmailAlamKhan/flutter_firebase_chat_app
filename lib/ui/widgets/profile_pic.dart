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
        fit: BoxFit.cover,
        placeholder: (_, __) => Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Image.asset(
      '$ImagePath/defaultDark.png',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AnimatedContainer(
        duration: 500.milliseconds,
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
        width: profilePicSize ?? ProfilePicSize,
        height: profilePicSize ?? ProfilePicSize,
        padding: EdgeInsets.all(isUserProfile ? 20 : 5),
        child: Obx(
          () => CircleAvatar(
            key: isUserProfile ? ValueKey<int>(counter) : null,
            backgroundColor: context.theme.primaryColor,
            child: ClipOval(
              child: SizedBox(
                width: ProfilePicSize,
                height: ProfilePicSize,
                child: Material(
                  child: InkWell(
                    onTap: onTap,
                    child: _profilePic() ?? profilePic,
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
