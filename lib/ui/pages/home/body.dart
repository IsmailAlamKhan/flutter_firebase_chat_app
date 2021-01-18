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
              final hasPhoto =
                  state[index].photoURL != null && state[index].photoURL != '';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.theme.primaryColor,
                  backgroundImage: hasPhoto
                      ? CachedNetworkImageProvider(
                          state[index].photoURL,
                        )
                      : AssetImage(
                          '$ImagePath/defaultDark.png',
                        ),
                ),
                title: Text(state[index].displayName),
                onTap: () => Get.to(
                  ChatScreen(
                    state[index].displayName,
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
