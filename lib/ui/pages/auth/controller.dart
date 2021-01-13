import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/ui/pages/auth/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController {
  final AuthService _authController = Get.find();
  final _authState = AuthState.Login.obs;
  AuthState get authState => _authState.value;
  set authState(AuthState value) => _authState(value);
  final obscure = true.obs;
  final TextEditingController usernameTec = TextEditingController();
  final TextEditingController emailTec = TextEditingController();
  final TextEditingController passTec = TextEditingController();

  void submit() {}
}
