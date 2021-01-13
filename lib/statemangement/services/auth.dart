import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

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
    @required String username,
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
          final currentUser = auth.currentUser;
          await currentUser.updateProfile(displayName: username);
          final _user = UserModel(
            id: currentUser.uid,
            email: currentUser.email,
            username: username,
          );

          await UserCrud().createUser(
            user: _user,
          );
          break;
        default:
      }

      _userController.fillUser(await UserCrud().getUser(authResult.user.uid));
      return 'Sucessful';
    } on FirebaseAuthException catch (e) {
      trace(e.code);
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } on FirebaseException catch (e) {
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
