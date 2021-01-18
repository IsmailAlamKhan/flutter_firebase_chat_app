import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/utils/index.dart';

import '../../index.dart';

enum AuthState { Login, Registration, ForgotPass }

class Auth extends StatefulWidget {
  Auth({Key key, @required this.authState}) : super(key: key);
  final AuthState authState;

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final AuthController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode passFocusNode = FocusNode();

  final FocusNode conPassFocusNode = FocusNode();

  final FocusNode usernameFocusNode = FocusNode();

  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    controller.authState = widget.authState;
    super.initState();
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      showErrorSnackBar(body: 'Please fix the issues');
      return;
    } else {
      controller.submit();
    }
  }

  Widget _buildSubmitButton(AuthState state) {
    switch (state) {
      case AuthState.Login:
        return Obx(
          () => RoundedLoadingButton(
            tag: LOGINTAG,
            onTap: _submit,
            width: controller.submitButtonWidth,
            height: 40,
            title: 'Login',
            animDuration: 500.milliseconds,
            submitState: controller.submitState,
          ),
        );

        break;
      case AuthState.ForgotPass:
        return Obx(
          () => RoundedLoadingButton(
            tag: FORGOTTAG,
            onTap: _submit,
            width: controller.submitButtonWidth,
            height: 40,
            title: 'Send email',
            animDuration: 500.milliseconds,
            submitState: controller.submitState,
          ),
        );

        break;
      case AuthState.Registration:
        return Obx(
          () => RoundedLoadingButton(
            tag: REGTAG,
            onTap: _submit,
            width: controller.submitButtonWidth,
            height: 40,
            title: 'Register',
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
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Build(
                    submit: _submit,
                    authState: widget.authState,
                    controller: controller,
                    usernameFocusNode: usernameFocusNode,
                    emailFocusNode: emailFocusNode,
                    passFocusNode: passFocusNode,
                    conPassFocusNode: conPassFocusNode,
                  ),
                  SizeTransition(
                    sizeFactor: controller.forgotPassButtonSizeAnimation,
                    child: SlideTransition(
                      position: controller.forgotPassButtonSlideAnimation,
                      child: ClipRRect(
                        child: Center(
                          child: TextButton(
                            onPressed: () =>
                                controller.authState = AuthState.ForgotPass,
                            child: Text(
                              'Forgot Pass?',
                              style: context.textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.0.sizedHeight,
                  Obx(
                    () => Center(
                      child: _buildSubmitButton(controller.authState),
                    ),
                  ),
                  20.0.sizedHeight,
                  Obx(
                    () => Center(
                      child: TextButton(
                        child: Text(
                          controller.authStateChangeButtonTitle,
                          style: context.textTheme.subtitle1,
                        ),
                        onPressed: () {
                          trace(controller.authState);
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
    this.authState,
  }) : super(
          key: key,
        );
  final Function submit;
  final AuthController controller;
  final FocusNode usernameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passFocusNode;
  final FocusNode conPassFocusNode;
  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.0.padSymHORT,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizeTransition(
            sizeFactor: controller.usernameSizeAnimation,
            child: SlideTransition(
              position: controller.usernameSlideAnimation,
              child: ClipRRect(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Obx(
                    () => DefaultTextField(
                      decoration:
                          InputDecoration(prefixIcon: Icon(Icons.person)),
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
          ),
          SizeTransition(
            sizeFactor: controller.emailSizeAnimation,
            child: SlideTransition(
              position: controller.emailSlideAnimation,
              child: DefaultTextField(
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
            ),
          ),
          SizeTransition(
            sizeFactor: controller.passSizeAnimation,
            child: SlideTransition(
              position: controller.passSlideAnimation,
              child: ClipRRect(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Obx(
                    () => DefaultTextField.password(
                      false,
                      focusNode: passFocusNode,
                      mandatory: true,
                      textInputAction: controller.authState.login
                          ? TextInputAction.done
                          : TextInputAction.next,
                      tec: controller.passTec,
                      onFieldSubmitted: controller.authState.login
                          ? (_) => submit()
                          : (_) => conPassFocusNode.requestFocus(),
                      hidePass: () => controller.obscure(true),
                      showPass: () => controller.obscure(false),
                      obscure: controller.obscure.value,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: controller.conPassSizeAnimation,
            child: SlideTransition(
              position: controller.conPassSlideAnimation,
              child: ClipRRect(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Obx(
                    () => DefaultTextField.password(
                      true,
                      mandatory: controller.authState.register,
                      tec: controller.conPassTec,
                      focusNode: conPassFocusNode,
                      onFieldSubmitted: (_) => submit(),
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
                  ),
                ),
              ),
            ),
          ),
          20.0.sizedHeight,
        ],
      ),
    );
  }
}
