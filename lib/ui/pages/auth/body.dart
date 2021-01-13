import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/utils/utils.dart';

import '../../ui.dart';

enum AuthState { Login, Registration, ForgotPass }

class Auth extends GetView<LoginController> {
  Auth({Key key, @required this.authState}) : super(key: key) {
    Get.put<LoginController>(LoginController()).authState = authState;
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

  Widget _buildSubmitButton(AuthState state) {
    return Obx(() => RoundedLoadingButton(
          onTap: _submit,
          width: controller.submitButtonWidth,
          height: 40,
          title: controller.submitButtonTitle,
          animDuration: 500.milliseconds,
          submitState: controller.submitState,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeroText(
                  text: 'Ismail Chat App',
                  tag: 'Ismail Chat App',
                  style: context.textTheme.headline3,
                ),
                10.0.sizedHeight,
                Hero(
                  tag: 'hero',
                  child: Image.asset(
                    '$ImagePath/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                10.0.sizedHeight,
                Column(
                  children: [
                    SizeTransition(
                      sizeFactor: controller.usernameSizeAnimation,
                      child: SlideTransition(
                        position: controller.usernameSlideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: DefaultTextField(
                            decoration:
                                InputDecoration(prefixIcon: Icon(Icons.person)),
                            focusNode: usernameFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                emailFocusNode.requestFocus(),
                            tec: controller.usernameTec,
                            label: 'Username',
                            mandatory: true,
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
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Obx(
                            () => DefaultTextField.password(
                              false,
                              focusNode: passFocusNode,
                              textInputAction: TextInputAction.next,
                              tec: controller.passTec,
                              onFieldSubmitted: (_) =>
                                  conPassFocusNode.requestFocus(),
                              hidePass: () => controller.obscure(true),
                              showPass: () => controller.obscure(false),
                              obscure: controller.obscure.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: controller.conPassSizeAnimation,
                      child: SlideTransition(
                        position: controller.conPassSlideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: DefaultTextField.password(
                            true,
                            tec: controller.conPassTec,
                            focusNode: conPassFocusNode,
                            validator: (value) {
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
                  ],
                ),
                20.0.sizedHeight,
                SizeTransition(
                  sizeFactor: controller.forgotPassButtonSizeAnimation,
                  child: SlideTransition(
                    position: controller.forgotPassButtonSlideAnimation,
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
                20.0.sizedHeight,
                Obx(() => _buildSubmitButton(controller.authState)),
                20.0.sizedHeight,
                Obx(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
