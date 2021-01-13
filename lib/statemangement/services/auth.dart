
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statemangement.dart';

class AuthService extends GetxService {
  final FirebaseService _firebaseService = Get.find();
  final UserController _userController = Get.find();
  static AuthService to = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User> user = Rx<User>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> doAuth(
    AuthState authState, {
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential authResult;
      switch (authState) {
        case AuthState.Login:
          authResult = await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        case AuthState.Registration:
          authResult = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        default:
      }

      _userController.fillUser(await UserCrud().getUser(authResult.user.uid));
      return 'Sucessful';
    } on FirebaseAuthException catch (e) {
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } catch (e) {
      return e.toString();
    }
  }
}
