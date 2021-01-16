import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

import 'package:firebase_chat_app/utils/index.dart';

import '../../index.dart';

enum AuthState { Login, Registration, ForgotPass }

class Auth extends GetView<AuthController> {
  Auth({Key key, @required this.authState}) : super(key: key);
  final AuthState authState;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode passFocusNode = FocusNode();
  final FocusNode conPassFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  void _submit() {
    if (!_formKey.currentState.validate()) {
      showErrorSnackBar(body: 'Please enter the mandatory fields');
      return;
    } else {
      controller.submit(authState);
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
                  ConditionalReturn(
                    authState.register,
                    builder: (context) => Padding(
                      padding: 20.0.padLEFT,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
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
                    authState: authState,
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

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Auth(
      authState: AuthState.Login,
    );
  }
}

class Register extends StatelessWidget {
  const Register({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Auth(
      authState: AuthState.Registration,
    );
  }
}

class ForgotPass extends StatelessWidget {
  const ForgotPass({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Auth(
      authState: AuthState.ForgotPass,
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

  Widget _buildSubmitButton(AuthState state) {
    switch (state) {
      case AuthState.Login:
        return Obx(
          () => RoundedLoadingButton(
            tag: LOGINTAG,
            onTap: submit,
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
            onTap: submit,
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
            onTap: submit,
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ConditionalReturn(
            authState.register,
            builder: (context) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: DefaultTextField(
                decoration: InputDecoration(
                  prefixIcon: DefaultIcon(Icons.person),
                ),
                focusNode: usernameFocusNode,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => emailFocusNode.requestFocus(),
                tec: controller.usernameTec,
                label: 'Username',
                mandatory: authState.register,
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
              prefixIcon: DefaultIcon(Icons.email),
            ),
            focusNode: emailFocusNode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => passFocusNode.requestFocus(),
            tec: controller.emailTec,
            label: 'Email',
            mandatory: true,
          ),
          ConditionalReturn(
            !authState.forgotPass,
            builder: (context) => Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Obx(
                () => DefaultTextField.password(
                  false,
                  mandatory: !authState.forgotPass,
                  focusNode: passFocusNode,
                  textInputAction: authState.register
                      ? TextInputAction.next
                      : TextInputAction.done,
                  tec: controller.passTec,
                  onFieldSubmitted: (_) {
                    if (authState.register) {
                      conPassFocusNode.requestFocus();
                    } else {
                      submit();
                    }
                  },
                  hidePass: () => controller.obscure(true),
                  showPass: () => controller.obscure(false),
                  obscure: controller.obscure.value,
                ),
              ),
            ),
          ),
          ConditionalReturn(
            authState.register,
            builder: (context) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DefaultTextField.password(
                      true,
                      mandatory: authState.register,
                      tec: controller.conPassTec,
                      onFieldSubmitted: (_) => submit(),
                      focusNode: conPassFocusNode,
                      validator: (value) {
                        if (!authState.register) return null;
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
                  ],
                ),
              ),
            ),
          ),
          20.0.sizedHeight,
          ConditionalReturn(
            authState.login,
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => ForgotPass().to(),
                child: Text(
                  'Forgot Pass?',
                  style: context.textTheme.subtitle1,
                ),
              ),
            ),
          ),
          20.0.sizedHeight,
          Align(
            child: _buildSubmitButton(authState),
          ),
          20.0.sizedHeight,
          Align(
            child: TextButton(
              child: Text(
                controller.authStateChangeButtonTitle(authState),
                style: context.textTheme.subtitle1,
              ),
              onPressed: () {
                trace(authState);
                switch (authState) {
                  case AuthState.ForgotPass:
                  case AuthState.Registration:
                    Login().to();
                    break;
                  case AuthState.Login:
                    Register().to();
                    break;
                  default:
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
