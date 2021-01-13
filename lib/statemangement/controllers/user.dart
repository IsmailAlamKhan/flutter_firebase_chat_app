import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:get/get.dart';

class UserController extends GetxController with StateMixin<UserModel> {
  final _user = UserModel().obs;
  UserModel get currentUser => _user.value;

  void fillUser(UserModel user) {
    _user(user);
  }
}
