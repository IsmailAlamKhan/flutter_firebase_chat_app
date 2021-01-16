import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:get/get.dart';

class UserController extends BaseController with StateMixin<UserModel> {
  final user = UserModel().obs;
  UserModel get currentUser => user.value;

  void fillUser(Stream<UserModel> val) {
    user.bindStream(val);
  }
}
