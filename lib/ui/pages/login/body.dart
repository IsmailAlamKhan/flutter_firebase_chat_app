import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui.dart';

class Login extends GetView<LoginController> {
  Login({Key key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
