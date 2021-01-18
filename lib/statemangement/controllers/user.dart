import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

class UserController extends BaseController with StateMixin<List<UserModel>> {
  final user = UserModel().obs;
  UserModel get currentUser => user.value;
  final list = <UserModel>[].obs;
  final UserCrud crud = Get.find();

  void fillUser(Stream<UserModel> val) {
    user.bindStream(val);
  }

  listOnChange(List<UserModel> value) {
    List<UserModel> val = value
        .where(
          (element) => element.id != AuthService.to.currentUser.uid,
        )
        .toList();
    trace(val);
    list.stream.handleError((onError) {
      change(null, status: RxStatus.error(onError.toString()));
    });
    if (val.isEmpty) {
      change(null, status: RxStatus.empty());
    } else if (list == null) {
      change(null, status: RxStatus.loading());
    } else {
      trace('val', val);
      change(val, status: RxStatus.success());
    }
  }

  Worker _listWorker;
  @override
  void onClose() {
    _listWorker?.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    list.bindStream(crud.getUsers);
    _listWorker = ever(list, listOnChange);
    super.onInit();
  }
}
