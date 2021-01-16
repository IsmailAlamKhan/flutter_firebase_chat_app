import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/ui/index.dart';

class Home extends GetView<HomeController> {
  const Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        leading: Hero(
          tag: 'user_profile',
          child: UserProfilePic(
            onTap: () => Get.to(
              UserProfile(),
              binding: BindingsBuilder.put(() => UserProfileController()),
            ),
          ),
        ),
        title: Text(
          'Chats',
          style: context.textTheme.headline6,
        ),
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
      body: ListView(
        children: [
          AppBarBottom(),
        ],
      ),
    );
  }
}
