import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/ui/index.dart';

class Home extends GetView<HomeController> {
  const Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(
            tag: 'user_profile',
            child: UserProfilePic(
              onTap: () => Get.to(
                UserProfile(),
                binding: BindingsBuilder.put(() => UserProfileController()),
              ),
            ),
          ),
        ),
        title: Text(
          'Chats',
          style: context.textTheme.headline6,
        ),
        bottom: AppBarBottom(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: DefaultIcon(
              Icons.chat,
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: DefaultIcon(Icons.people),
            label: 'People',
          ),
        ],
      ),
      body: Get.find<UserController>().obx(
        (state) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              final _data = state[index];
              final hasPhoto = _data.photoURL != null && _data.photoURL != '';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.theme.primaryColor,
                  backgroundImage: hasPhoto
                      ? CachedNetworkImageProvider(
                          _data.photoURL,
                        )
                      : AssetImage(
                          '$ImagePath/defaultDark.png',
                        ),
                ),
                trailing: _data.userStatus.active ? Icon(Icons.ballot) : null,
                title: Text(_data.displayName),
                onTap: () => Get.to(
                  ChatScreen(
                    _data.displayName,
                  ),
                  binding: BindingsBuilder.put(
                    () => ChatController(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
