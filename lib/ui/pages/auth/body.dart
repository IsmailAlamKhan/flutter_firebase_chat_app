import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/utils/utils.dart';

import '../../ui.dart';

enum AuthState { Login, Registration, ForgotPass }

class Auth extends GetView<AuthController> {
  Auth({Key key, @required this.authState}) : super(key: key) {
    Get.put<AuthController>(AuthController()).authState = authState;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthState authState;

  final FocusNode passFocusNode = FocusNode();
  final FocusNode conPassFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  void _submit() {
    if (!_formKey.currentState.validate()) {
      showErrorSnackBar(body: 'Please enter the mandatory fields');
      return;
    } else {
      controller.submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => AnimatedCrossFade(
                        crossFadeState: controller.authState.register
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: 500.milliseconds,
                        secondChild: SizedBox.shrink(),
                        alignment: Alignment.topLeft,
                        firstChild: Text(
                          'Welcome to Ismail\nChat App',
                          style: context.textTheme.headline4.copyWith(
                            color: context.theme.accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _Build(
                    submit: _submit,
                    controller: controller,
                    usernameFocusNode: usernameFocusNode,
                    emailFocusNode: emailFocusNode,
                    passFocusNode: passFocusNode,
                    conPassFocusNode: conPassFocusNode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Build extends StatelessWidget {
  _Build({
    Key key,
    this.submit,
    @required this.controller,
    @required this.usernameFocusNode,
    @required this.emailFocusNode,
    @required this.passFocusNode,
    @required this.conPassFocusNode,
  }) : super(
          key: key,
        );
  final Function submit;
  final AuthController controller;
  final FocusNode usernameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passFocusNode;
  final FocusNode conPassFocusNode;

  Widget _buildSubmitButton(AuthState state) {
    switch (state) {
      case AuthState.Login:
        return Obx(
          () => RoundedLoadingButton(
            tag: LOGINTAG,
            onTap: submit,
            width: controller.submitButtonWidth,
            height: 40,
            title: controller.submitButtonTitle,
            animDuration: 500.milliseconds,
            submitState: controller.submitState,
          ),
        );

        break;
      case AuthState.ForgotPass:
        return Obx(
          () => RoundedLoadingButton(
            tag: FORGOTTAG,
            onTap: submit,
            width: controller.submitButtonWidth,
            height: 40,
            title: controller.submitButtonTitle,
            animDuration: 500.milliseconds,
            submitState: controller.submitState,
          ),
        );

        break;
      case AuthState.Registration:
        return Obx(
          () => RoundedLoadingButton(
            tag: REGTAG,
            onTap: submit,
            width: controller.submitButtonWidth,
            height: 40,
            title: controller.submitButtonTitle,
            animDuration: 500.milliseconds,
            submitState: controller.submitState,
          ),
        );

        break;
      default:
        return SizedBox.shrink();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizeTransition(
            sizeFactor: controller.usernameSizeAnimation,
            child: SlideTransition(
              position: controller.usernameSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Obx(
                  () => DefaultTextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                    ),
                    focusNode: usernameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                    tec: controller.usernameTec,
                    label: 'Username',
                    mandatory: controller.authState.register,
                  ),
                ),
              ),
            ),
          ),
          DefaultTextField(
            validator: (value) {
              if (!value.isEmail) {
                return "Please input a valid email";
              }
              return null;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
            ),
            focusNode: emailFocusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => passFocusNode.requestFocus(),
            tec: controller.emailTec,
            label: 'Email',
            mandatory: true,
          ),
          SizeTransition(
            sizeFactor: controller.passSizeAnimation,
            child: SlideTransition(
              position: controller.passSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Obx(() => DefaultTextField.password(
                      false,
                      mandatory: !controller.authState.forgotPass,
                      focusNode: passFocusNode,
                      textInputAction: controller.authState.register
                          ? TextInputAction.next
                          : TextInputAction.done,
                      tec: controller.passTec,
                      onFieldSubmitted: (_) {
                        if (controller.authState.register) {
                          conPassFocusNode.requestFocus();
                        } else {
                          submit();
                        }
                      },
                      hidePass: () => controller.obscure(true),
                      showPass: () => controller.obscure(false),
                      obscure: controller.obscure.value,
                    )),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: controller.conPassSizeAnimation,
            child: SlideTransition(
              position: controller.conPassSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DefaultTextField.password(
                        true,
                        mandatory: controller.authState.register,
                        tec: controller.conPassTec,
                        onFieldSubmitted: (_) => submit(),
                        focusNode: conPassFocusNode,
                        validator: (value) {
                          if (!controller.authState.register) return null;
                          if (value != controller.passTec.text) {
                            return 'Password mismatch';
                          } else {
                            return null;
                          }
                        },
                        hidePass: () => controller.conObscure(true),
                        showPass: () => controller.conObscure(false),
                        obscure: controller.conObscure.value,
                      ),
                      20.0.sizedHeight,
                      Text('Gender'),
                      Row(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          20.0.sizedHeight,
          SizeTransition(
            sizeFactor: controller.forgotPassButtonSizeAnimation,
            child: SlideTransition(
              position: controller.forgotPassButtonSlideAnimation,
              child: Center(
                child: TextButton(
                  onPressed: () => controller.authState = AuthState.ForgotPass,
                  child: Text(
                    'Forgot Pass?',
                    style: context.textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
          20.0.sizedHeight,
          Align(
            child: Obx(
              () => _buildSubmitButton(controller.authState),
            ),
          ),
          20.0.sizedHeight,
          Align(
            child: Obx(
              () => TextButton(
                child: Text(
                  controller.authStateChangeButtonTitle,
                  style: context.textTheme.subtitle1,
                ),
                onPressed: () {
                  switch (controller.authState) {
                    case AuthState.ForgotPass:
                    case AuthState.Registration:
                      controller.authState = AuthState.Login;
                      break;
                    case AuthState.Login:
                      controller.authState = AuthState.Registration;
                      break;
                    default:
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
