import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ChatScreenInput extends StatelessWidget {
  ChatScreenInput({
    Key key,
    @required this.controller,
  }) : super(key: key);
  final ChatController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      height: kBottomNavigationBarHeight,
      width: context.width,
      child: Padding(
        padding: 10.0.padSymHORT,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: DefaultTextField(
                onFieldSubmitted: (_) => controller.sendMessege(context),
                tec: controller.tec,
                focusNode: controller.focusNode,
                decoration: InputDecoration(
                  filled: false,
                ),
                label: 'Write something...',
              ),
            ),
            5.0.sizedWidth,
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.sendMessege(context),
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
