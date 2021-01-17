import 'package:firebase_chat_app/statemangement/index.dart';
import 'package:firebase_chat_app/ui/index.dart';
import 'package:firebase_chat_app/utils/index.dart';
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
    Get.put(AuthController());
  }
}

class AuthController extends BaseController with SingleGetTickerProviderMixin {
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

  final StorageService _storageService = StorageService();
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
      await _storageService.write('email', emailTec.text);
      await _storageService.write('password', passTec.text);
      usernameTec.clear();
      emailTec.clear();
      passTec.clear();
      conPassTec.clear();
      _submitState(SubmitState.Success);
      await 1000.milliseconds.delay();
      _submitState(SubmitState.Idle);
      Get.offAll(
        Home(),
      );
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
  Future<void> onReady() async {
    trace(await _storageService.read('password'));
    super.onReady();
  }

  @override
  Future<void> onInit() async {
    passTec.text = await _storageService.read('password');
    emailTec.text = await _storageService.read('email');
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
