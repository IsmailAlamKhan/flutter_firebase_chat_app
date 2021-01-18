import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

class UserController extends BaseController
    with StateMixin<List<UserModel>>, WidgetsBindingObserver {
  final user = UserModel().obs;
  UserModel get currentUser => user.value;
  final list = <UserModel>[].obs;
  final UserCrud crud = Get.find();

  bool active;

  Future<void> fillUser(Stream<UserModel> val) async {
    trace('fillUser');
    user.bindStream(val);
  }

  listOnChange(List<UserModel> value) {
    List<UserModel> val = value
        .where(
          (element) => element.id != AuthService.to.currentUser?.uid,
        )
        .toList();
    list.stream.handleError((onError) {
      change(null, status: RxStatus.error(onError.toString()));
    });
    if (val.isEmpty) {
      change(null, status: RxStatus.empty());
    } else if (list == null) {
      change(null, status: RxStatus.loading());
    } else {
      change(val, status: RxStatus.success());
    }
  }

  Worker _listWorker;
  Worker _userWorker;
  @override
  void onClose() {
    _listWorker?.dispose();
    _userWorker?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    trace(state);
    if (state == AppLifecycleState.inactive) {
      if (active) {
        await UserCrud().updateUserStatus(
          userStatus: UserStatus.Inactive,
        );
      }
    }
    if (state == AppLifecycleState.resumed) {
      if (active) {
        await UserCrud().updateUserStatus(
          userStatus: UserStatus.Inactive,
        );
      }
    }
  }

  void initListWorker(User val) {
    if (val?.uid != null) {
      _listWorker = ever(list, listOnChange);
    }
  }

  @override
  void onReady() {
    initListWorker(AuthService.to.currentUser);
    _userWorker = ever(AuthService.to.user, (User val) {
      trace(val);
      initListWorker(val);
    });
    super.onReady();
  }

  @override
  void onInit() {
    list.bindStream(crud.getUsers);
    active = Get.put(AuthService()).loggedIn && currentUser.userStatus.active;
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }
}
