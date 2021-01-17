import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:get/get.dart';

class UserController extends BaseController with StateMixin<UserModel> {
  final user = UserModel().obs;
  UserModel get currentUser => user.value;
  final list = <UserModel>[].obs;
  final UserCrud crud = Get.find();

  void fillUser(Stream<UserModel> val) {
    user.bindStream(val);
  }

  @override
  void onInit() {
    list.bindStream(crud.getUsers);
    super.onInit();
  }
}
