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
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  Widget get _buildSubmitButton {
    Widget _widget;
    switch (authState) {
      case AuthState.Login:
        _widget = CustomButton.login(
          onTap: () {},
        );
        break;
      case AuthState.Registration:
        _widget = CustomButton.regiser(
          onTap: () {},
        );
        break;
      case AuthState.ForgotPass:
        _widget = CustomButton.forgotPass(
          onTap: () {},
        );
        break;
      default:
        _widget = Text('Error');
        break;
    }
    return _widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                10.0.sizedHeight,
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      DefaultTextField(
                        focusNode: usernameFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => passFocusNode.requestFocus(),
                        tec: null,
                        label: 'Username',
                        mandatory: true,
                      ),
                      20.0.sizedHeight,
                      Obx(
                        () => DefaultTextField.password(
                          focusNode: passFocusNode,
                          tec: null,
                          hidePass: () => controller.obscure(true),
                          showPass: () => controller.obscure(false),
                          obscure: controller.obscure.value,
                        ),
                      ),
                    ],
                  ),
                ),
                40.0.sizedHeight,
                _buildSubmitButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    Key key,
    @required this.tec,
    this.decoration,
    this.obscure,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.mandatory = false,
    @required this.label,
  }) : super(key: key);
  final TextEditingController tec;
  final InputDecoration decoration;
  final bool obscure;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputAction textInputAction;
  final FormFieldValidator<String> validator;
  final bool mandatory;
  final String label;
  DefaultTextField.password({
    @required this.tec,
    @required this.obscure,
    @required VoidCallback showPass,
    @required VoidCallback hidePass,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
  })  : mandatory = true,
        label = 'Password',
        decoration = InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
          ),
          suffixIcon: AnimatedCrossFade(
            firstChild: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: showPass,
            ),
            secondChild: IconButton(
              icon: Icon(Icons.visibility_off),
              onPressed: hidePass,
            ),
            crossFadeState:
                obscure ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: 200.milliseconds,
          ),
        );
  String get _labelText => mandatory
      ? label.substring(0, 1).toUpperCase() + label.substring(1) + '*'
      : label.substring(0, 1).toUpperCase() + label.substring(1);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (mandatory) {
          if (value == '') return '$label is required';

          return validator(value);
        } else {
          return validator(value);
        }
      },
      focusNode: focusNode,
      controller: tec,
      textInputAction: textInputAction ?? TextInputAction.done,
      obscureText: obscure ?? false,
      onFieldSubmitted: onFieldSubmitted,
      obscuringCharacter: '*',
      decoration: decoration == null
          ? InputDecoration(
              filled: true,
              hintText: mandatory ? 'Required' : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              labelText: _labelText,
            )
          : decoration.copyWith(
              hintText: mandatory ? 'Required' : null,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              labelText: _labelText,
            ),
    );
  }
}
