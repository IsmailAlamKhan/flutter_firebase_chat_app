import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/statemangement/index.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  DefaultAppBar({
    Key key,
    @required this.title,
    this.leading,
    this.actions,
    this.bottom,
  }) : super(key: key);
  final AuthService authController = Get.find();

  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final PreferredSizeWidget bottom;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (authController.currentUser == null) return SizedBox.shrink();
        if (!authController.currentUser.emailVerified) {
          return AppBar(
            backgroundColor: Colors.transparent,
            title: GestureDetector(
              onTap: () async => await authController.verifyEmail(),
              child: Text(
                'Click here to verify your email',
                style: context.textTheme.headline6.copyWith(
                  color: context.theme.errorColor,
                ),
              ),
            ),
          );
        }
        return AppBar(
          leading: leading,
          bottom: bottom,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: title,
          actions: actions,
        );
      },
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize?.height ?? 0));
}
