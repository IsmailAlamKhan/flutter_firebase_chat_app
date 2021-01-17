import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/statemangement/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const ERRORID = 'ERROR';

class ChatController extends GetxController {
  FocusNode focusNode;
  final crud = Get.put(ChatCrud());
  final _hasFocus = false.obs;
  bool get hasFocus => _hasFocus.value;
  final TextEditingController tec = TextEditingController();
  final AuthService _authController = Get.find();
  final list = <Chat>[].obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onClose() {
    scrollController?.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    list.bindStream(crud.chatStream());
    focusNode = FocusNode()
      ..addListener(() {
        _hasFocus(focusNode.hasFocus);
      });
    super.onInit();
  }

  final _loading = false.obs;
  bool get loading => _loading.value;

  final _error = ''.obs;
  String get error => _error.value;

  Future<void> sendMessege(BuildContext context) async {
    try {
      _loading(true);
      FocusScope.of(context).unfocus();
      await 500.milliseconds.delay();
      await crud.addchat(
        chat: Chat(
          uidFrom: _authController.currentUser.uid,
          messege: tec.text,
        ),
      );
      tec.clear();
      _loading(false);
      await 500.milliseconds.delay();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: 500.milliseconds,
        curve: Curves.easeIn,
      );
    } catch (e) {
      list.add(
        Chat(
          id: ERRORID,
          dateCreated: Timestamp.now(),
          uidFrom: _authController.currentUser.uid,
          messege: e.toString(),
        ),
      );
      _loading(false);
    }
  }
}
