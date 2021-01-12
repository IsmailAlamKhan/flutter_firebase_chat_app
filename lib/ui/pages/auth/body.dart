import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/utils/utils.dart';

import '../../ui.dart';

enum AuthState { Login, Registration, ForgotPass }

class Auth extends GetView<LoginController> {
  Auth({Key key, @required this.authState}) : super(key: key) {
    Get.put<LoginController>(LoginController()).authState = authState;
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthState authState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'hero',
                child: Image.asset(
                  '$ImagePath/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Obx(
                      () => DefaultTextField.password(
                        tec: null,
                        hidePass: () => controller.obscure(true),
                        showPass: () => controller.obscure(false),
                        obscure: controller.obscure,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
  }) : super(key: key);
  final TextEditingController tec;
  final InputDecoration decoration;
  final RxBool obscure;
  DefaultTextField.password({
    @required this.tec,
    @required this.obscure,
    @required VoidCallback showPass,
    @required VoidCallback hidePass,
  }) : decoration = InputDecoration(
          suffixIcon: Obx(
            () => AnimatedCrossFade(
              firstChild: IconButton(
                icon: Icon(Icons.visibility),
                onPressed: showPass,
              ),
              secondChild: IconButton(
                icon: Icon(Icons.visibility),
                onPressed: hidePass,
              ),
              crossFadeState: obscure.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: 500.milliseconds,
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: tec,
      obscureText: obscure.value,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        labelText: decoration?.labelText,
        suffixIcon: decoration?.suffixIcon,
        border: decoration?.border ?? OutlineInputBorder(),
        contentPadding: decoration?.contentPadding,
        counter: decoration?.counter,
        counterStyle: decoration?.counterStyle,
      ),
    );
  }
}
