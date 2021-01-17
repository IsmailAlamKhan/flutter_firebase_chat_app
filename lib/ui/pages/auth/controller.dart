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

  final _authStateChangeButtonTitle = 'Registration'.obs;
  String get authStateChangeButtonTitle => _authStateChangeButtonTitle.value;

  final _authState = AuthState.Login.obs;
  AuthState get authState => _authState.value;
  set authState(AuthState value) => _authState(value);

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
        username: usernameTec.text.trim(),
        email: emailTec.text.trim(),
        password: passTec.text.trim(),
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
  Worker _authStateWorker;
  @override
  void onClose() {
    _submitWorker?.dispose();
    _authStateWorker?.dispose();
    super.onClose();
  }

  @override
  Future<void> onReady() async {
    trace(await _storageService.read('password'));
    super.onReady();
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
      duration: 300.milliseconds,
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
      begin: const Offset(-2, 0),
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

  void initAnims() {
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
  }

  void authStateOnChange(AuthState val) {
    trace(val);
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

  @override
  Future<void> onInit() async {
    initAnims();
    authStateOnChange(authState);
    passTec.text = await _storageService.read('password');
    emailTec.text = await _storageService.read('email');
    _authStateWorker = ever(_authState, authStateOnChange);
    _submitWorker = ever(_submitState, submitStateOnChange);
    super.onInit();
  }

  Future<void> resetAllAnimations() async {
    _submitButtonTitle('');
    _authStateChangeButtonTitle('');

    emailSizeController.reverse();
    await 300.milliseconds.delay();
    emailSlideController.reverse();

    passSizeController.reverse();
    await 300.milliseconds.delay();
    passSlideController.reverse();

    forgotPassButtonController.reverse();
    usernameSlideController.reverse();
    await 300.milliseconds.delay();
    usernameSizeController.reverse();

    conPassSlideController.reverse();
    await 300.milliseconds.delay();
    conPassSizeController.reverse();
  }

  Future<void> changeToLogin() async {
    _submitButtonTitle('Login');
    _authStateChangeButtonTitle('Registration');

    emailSizeController.forward();
    await 300.milliseconds.delay();
    emailSlideController.forward();

    passSizeController.forward();
    await 300.milliseconds.delay();
    passSlideController.forward();

    forgotPassButtonController.forward();
    usernameSlideController.reverse();
    await 300.milliseconds.delay();
    usernameSizeController.reverse();

    conPassSlideController.reverse();
    await 300.milliseconds.delay();
    conPassSizeController.reverse();
  }

  Future<void> changeToReg() async {
    _submitButtonTitle('Register');
    _authStateChangeButtonTitle('Back');

    usernameSizeController.forward();
    await 300.milliseconds.delay();
    usernameSlideController.forward();

    emailSizeController.forward();
    await 300.milliseconds.delay();
    emailSlideController.forward();

    passSizeController.forward();
    await 300.milliseconds.delay();
    passSlideController.forward();

    conPassSizeController.forward();
    await 300.milliseconds.delay();
    conPassSlideController.forward();

    forgotPassButtonController.forward();
  }

  Future<void> changeToForgotPass() async {
    _submitButtonTitle('Forgot Password');
    _authStateChangeButtonTitle('Back');

    forgotPassButtonController.reverse();
    passSlideController.reverse();
    await 300.milliseconds.delay();
    passSizeController.reverse();

    usernameSlideController.reverse();
    await 300.milliseconds.delay();
    usernameSizeController.reverse();

    conPassSlideController.reverse();
    await 300.milliseconds.delay();
    conPassSizeController.reverse();
  }

  Future<void> submitStateOnChange(SubmitState val) async {
    if (val.loading) {
      _submitButtonWidth(
        _submitButtonWidth.value - ((_submitButtonWidth.value - 40.0) * 1),
      );
    } else {
      if (val.success) await resetAllAnimations();
      _submitButtonWidth(150);
    }
  }
}
