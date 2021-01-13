import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.tag,
    @required this.onTap,
    this.text,
  }) : super(key: key);

  final String tag;
  CustomButton.login({@required this.onTap})
      : text = 'Login',
        tag = 'Login';
  CustomButton.regiser({@required this.onTap})
      : text = 'Register',
        tag = 'Register';

  CustomButton.forgotPass({@required this.onTap})
      : text = 'Forgot Password',
        tag = 'Forgot Password';

  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    if (tag == null) {
      return _build(context);
    }
    return Hero(
      tag: tag,
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: context.theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(200, 45),
        elevation: 10,
      ),
      child: Text(text),
    );
  }
}
