import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/ui/pages/auth/auth.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

enum SubmitState {
  Loading,
  Idle,
  Error,
  Success,
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class AuthController extends GetxController with SingleGetTickerProviderMixin {
  final AuthService _authController = Get.find();

  final _submitButtonWidth = 150.0.obs;

  double get submitButtonWidth => _submitButtonWidth.value;

  final _submitButtonTitle = 'Login'.obs;
  String get submitButtonTitle => _submitButtonTitle.value;

  String authStateChangeButtonTitle(AuthState authState) {
    if (authState.forgotPass || authState.register) {
      return 'Login';
    }
    return 'Register';
  }

  // final _authState = AuthState.Login.obs;
  // AuthState get authState => _authState.value;
  // set authState(AuthState value) => _authState(value);

  final _submitState = SubmitState.Idle.obs;
  SubmitState get submitState => _submitState.value;
  set submitState(SubmitState value) => _submitState(value);

  final obscure = true.obs;
  final conObscure = true.obs;

  final TextEditingController usernameTec = TextEditingController();
  final TextEditingController emailTec = TextEditingController();
  final TextEditingController passTec = TextEditingController();
  final TextEditingController conPassTec = TextEditingController();

  Future<void> submit(AuthState authState) async {
    try {
      _submitState(SubmitState.Loading);
      await 300.milliseconds.delay();
      await _authController.doAuth(
        authState,
        username: usernameTec.text,
        email: emailTec.text,
        password: passTec.text,
      );
      usernameTec.clear();
      emailTec.clear();
      passTec.clear();
      conPassTec.clear();
      _submitState(SubmitState.Success);
      await 1000.milliseconds.delay();
      _submitState(SubmitState.Idle);
    } catch (e) {
      _submitState(SubmitState.Error);
      showErrorSnackBar(body: e.toString());
      await 1000.milliseconds.delay();
      _submitState(SubmitState.Idle);

      throw Exception(e);
    }
  }

  Worker _submitWorker;
  @override
  void onClose() {
    _submitWorker?.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    _submitWorker = ever(_submitState, submitStateOnChange);
    super.onInit();
  }

  void submitStateOnChange(SubmitState val) {
    if (val.loading) {
      _submitButtonWidth(
        _submitButtonWidth.value - ((_submitButtonWidth.value - 40.0) * 1),
      );
    } else {
      _submitButtonWidth(150);
    }
  }
}
