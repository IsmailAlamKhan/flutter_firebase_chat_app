import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/statemangement/models/chat.dart';
import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen(this.title, {Key key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(
          title,
          style: context.textTheme.headline6,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            child: controller.obx(
              (state) => ListView.builder(
                controller: controller.scrollController,
                itemCount: state.length,
                shrinkWrap: true,
                padding: 10.0.padAll,
                itemBuilder: (BuildContext context, int index) {
                  final Chat data = state[index];
                  final UserModel _user =
                      Get.find<UserController>().list.firstWhere(
                            (element) => element.id == data.uidFrom,
                            orElse: () => null,
                          );
                  String _photoUrl = _user?.photoURL;
                  String _userName = _user?.displayName;
                  bool _isMe = data.uidFrom == AuthService.to.currentUser.uid;
                  return ChatTile(
                    isMe: _isMe,
                    id: data.id,
                    imageURL: _photoUrl,
                    messege: data.messege ?? '',
                    name: _userName ?? '',
                    sent: data.dateCreated.convertToString() ?? '',
                  );
                },
              ),
              onEmpty: Center(
                child: Text(
                  'No Chat History found',
                  style: context.textTheme.headline6.copyWith(
                    color: context.textTheme.headline6.color.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            width: context.width,
            bottom: 0,
            child: ChatScreenInput(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
