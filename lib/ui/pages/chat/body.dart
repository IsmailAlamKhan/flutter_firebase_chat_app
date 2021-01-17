import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/statemangement/models/chat.dart';
import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: Text(
          'Test User',
          style: context.textTheme.headline6,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.list.length,
                itemBuilder: (BuildContext context, int index) {
                  final Chat data = controller.list[index];
                  final UserModel _user =
                      Get.find<UserController>().list.firstWhere(
                            (element) => element.id == data.uidFrom,
                            orElse: () => null,
                          );
                  String _photoUrl = _user?.photoURL;
                  String _userName = _user?.displayName;
                  return ChatTile(
                    id: data.id,
                    imageURL: _photoUrl,
                    messege: data.messege ?? '',
                    name: _userName ?? '',
                    sent: data.dateCreated.convertToString() ?? '',
                  );
                },
              ),
            ),
            controller.loading
                ? CircularProgressIndicator()
                : SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: ChatScreenInput(
        controller: controller,
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    Key key,
    @required this.name,
    @required this.sent,
    @required this.imageURL,
    @required this.messege,
    @required this.id,
  }) : super(key: key);
  final String name;
  final String sent;
  final String imageURL;
  final String messege;
  final String id;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      margin: 8.0.padAll,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: ClipOval(
              child: SizedBox.expand(
                child: imageURL != null
                    ? CachedNetworkImage(
                        imageUrl: imageURL,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        '$ImagePath/defaultDark.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          15.0.sizedWidth,
          Container(
            width: context.width - 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: context.textTheme.headline6,
                    ),
                    10.0.sizedWidth,
                    Text(
                      sent,
                      style: context.textTheme.caption,
                    ),
                  ],
                ),
                5.0.sizedHeight,
                Text(
                  messege,
                  style: TextStyle(
                    color: id == ERRORID ? context.theme.errorColor : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatScreenInput extends StatelessWidget {
  ChatScreenInput({
    Key key,
    @required this.controller,
  }) : super(key: key);
  final ChatController controller;
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0,
        -1 * context.mediaQueryViewInsets.bottom,
      ),
      child: BottomAppBar(
        color: context.theme.scaffoldBackgroundColor,
        elevation: 0,
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
      ),
    );
  }
}
