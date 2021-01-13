import 'package:firebase_chat_app/statemangement/statemangement.dart';
import 'package:firebase_chat_app/ui/pages/auth/auth.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum SubmitState {
  Loading,
  Idle,
  Error,
  Success,
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LoginController extends GetxController with SingleGetTickerProviderMixin {
  final AuthService _authController = Get.find();

  final _submitButtonWidth = 150.0.obs;

  double get submitButtonWidth => _submitButtonWidth.value;

  final _submitButtonTitle = 'Login'.obs;
  String get submitButtonTitle => _submitButtonTitle.value;

  final _authStateChangeButtonTitle = 'Registration'.obs;
  String get authStateChangeButtonTitle => _authStateChangeButtonTitle.value;

  final _authState = AuthState.Login.obs;
  AuthState get authState => _authState.value;
  set authState(AuthState value) => _authState(value);

  final _submitState = SubmitState.Idle.obs;
  SubmitState get submitState => _submitState.value;
  set submitState(SubmitState value) => _submitState(value);

  final obscure = true.obs;
  final conObscure = true.obs;

  final TextEditingController usernameTec = TextEditingController();
  final TextEditingController emailTec = TextEditingController();
  final TextEditingController passTec = TextEditingController();
  final TextEditingController conPassTec = TextEditingController();

  Future<void> submit() async {
    try {
      _submitState(SubmitState.Loading);
      await 500.milliseconds.delay();
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
  Worker _authStateWorker;
  @override
  void onClose() {
    _submitWorker?.dispose();
    _authStateWorker?.dispose();
    super.onClose();
  }

  AnimationController usernameSizeController;
  AnimationController usernameSlideController;
  Animation<double> usernameSizeAnimation;
  Animation<Offset> usernameSlideAnimation;

  AnimationController passSizeController;
  AnimationController passSlideController;

  Animation<double> passSizeAnimation;
  Animation<Offset> passSlideAnimation;

  AnimationController conPassSizeController;
  AnimationController conPassSlideController;
  Animation<double> conPassSizeAnimation;
  Animation<Offset> conPassSlideAnimation;

  AnimationController emailSizeController;
  AnimationController emailSlideController;
  Animation<double> emailSizeAnimation;
  Animation<Offset> emailSlideAnimation;

  AnimationController forgotPassButtonController;
  Animation<double> forgotPassButtonSizeAnimation;
  Animation<Offset> forgotPassButtonSlideAnimation;

  AnimationController get initAnimController {
    return AnimationController(
      duration: 500.milliseconds,
      vsync: this,
    );
  }

  Tween<double> get initDoubleAnims {
    return Tween<double>(
      begin: 0.0,
      end: 1.0,
    );
  }

  Tween<Offset> get initOffsetAnims {
    return Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    );
  }

  CurvedAnimation doubleCurveAnimations(AnimationController anim) {
    return CurvedAnimation(
      parent: anim,
      curve: const Interval(0.0, .6875, curve: Curves.easeInOut),
      reverseCurve: const Interval(0.0, .6875, curve: Curves.easeInOut),
    );
  }

  CurvedAnimation offsetCurveAnimations(AnimationController anim) {
    return CurvedAnimation(
      parent: anim,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
  }

  @override
  void onInit() {
    usernameSlideController = initAnimController;
    usernameSizeController = initAnimController;
    usernameSizeAnimation = initDoubleAnims.animate(
      doubleCurveAnimations(usernameSizeController),
    );
    usernameSlideAnimation = initOffsetAnims.animate(
      offsetCurveAnimations(usernameSlideController),
    );

    forgotPassButtonController = initAnimController;
    forgotPassButtonSizeAnimation = initDoubleAnims.animate(
      doubleCurveAnimations(forgotPassButtonController),
    );
    forgotPassButtonSlideAnimation = initOffsetAnims.animate(
      offsetCurveAnimations(forgotPassButtonController),
    );
    passSlideController = initAnimController;
    passSizeController = initAnimController;
    passSizeAnimation = initDoubleAnims.animate(
      doubleCurveAnimations(passSizeController),
    );
    passSlideAnimation = initOffsetAnims.animate(
      offsetCurveAnimations(passSlideController),
    );
    conPassSlideController = initAnimController;
    conPassSizeController = initAnimController;
    conPassSizeAnimation = initDoubleAnims.animate(
      doubleCurveAnimations(conPassSizeController),
    );
    conPassSlideAnimation = initOffsetAnims.animate(
      offsetCurveAnimations(conPassSlideController),
    );

    emailSlideController = initAnimController;
    emailSizeController = initAnimController;
    emailSizeAnimation = initDoubleAnims.animate(
      doubleCurveAnimations(emailSizeController),
    );
    emailSlideAnimation = initOffsetAnims.animate(
      offsetCurveAnimations(emailSlideController),
    );
    authStateOnChange(_authState.value);
    _submitWorker = ever(_submitState, submitStateOnChange);
    _authStateWorker = ever(_authState, authStateOnChange);
    super.onInit();
  }

  Future<void> changeToLogin() async {
    _submitButtonTitle('Login');
    _authStateChangeButtonTitle('Registration');

    emailSizeController.forward();
    await 500.milliseconds.delay();
    emailSlideController.forward();

    passSizeController.forward();
    await 500.milliseconds.delay();
    passSlideController.forward();

    forgotPassButtonController.forward();
    usernameSlideController.reverse();
    await 500.milliseconds.delay();
    usernameSizeController.reverse();

    conPassSlideController.reverse();
    await 500.milliseconds.delay();
    conPassSizeController.reverse();
  }

  Future<void> changeToReg() async {
    _submitButtonTitle('Register');
    _authStateChangeButtonTitle('Back');

    usernameSizeController.forward();
    await 500.milliseconds.delay();
    usernameSlideController.forward();

    emailSizeController.forward();
    await 500.milliseconds.delay();
    emailSlideController.forward();

    passSizeController.forward();
    await 500.milliseconds.delay();
    passSlideController.forward();

    conPassSizeController.forward();
    await 500.milliseconds.delay();
    conPassSlideController.forward();

    forgotPassButtonController.forward();
  }

  Future<void> changeToForgotPass() async {
    _submitButtonTitle('Forgot Password');
    _authStateChangeButtonTitle('Back');

    forgotPassButtonController.reverse();
    passSlideController.reverse();
    await 500.milliseconds.delay();
    passSizeController.reverse();

    usernameSlideController.reverse();
    await 500.milliseconds.delay();
    usernameSizeController.reverse();

    conPassSlideController.reverse();
    await 500.milliseconds.delay();
    conPassSizeController.reverse();
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

  void authStateOnChange(AuthState val) {
    switch (val) {
      case AuthState.Login:
        changeToLogin();
        break;
      case AuthState.Registration:
        changeToReg();
        break;
      case AuthState.ForgotPass:
        changeToForgotPass();
        break;
      default:
    }
  }
}
