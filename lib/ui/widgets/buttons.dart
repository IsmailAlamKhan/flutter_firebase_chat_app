import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';

const String LOGINTAG = 'LOGIN';
const String REGTAG = 'Register';
const String FORGOTTAG = 'Forgot Password';

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
        tag = LOGINTAG;
  CustomButton.regiser({@required this.onTap})
      : text = 'Register',
        tag = REGTAG;

  CustomButton.forgotPass({@required this.onTap})
      : text = 'Forgot Password',
        tag = FORGOTTAG;

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
    return AnimatedContainer(
      width: 200,
      height: 45,
      duration: 500.milliseconds,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: context.theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: Size(200, 45),
          elevation: 10,
        ),
        child: AnimatedSwitcher(
          duration: 500.milliseconds,
          child: DefaultText(text),
        ),
      ),
    );
  }
}

class RoundedLoadingButton extends StatelessWidget {
  const RoundedLoadingButton({
    Key key,
    this.tag,
    @required this.width,
    @required this.height,
    @required this.onTap,
    @required this.title,
    @required this.submitState,
    @required this.animDuration,
  }) : super(key: key);
  final String tag;
  final double width;
  final double height;
  final Function onTap;
  final String title;
  final SubmitState submitState;
  final Duration animDuration;
  Widget _buildLoadingState() {
    return AnimatedCrossFade(
      crossFadeState: submitState.loading
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: animDuration,
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeIn,
      firstChild: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
      secondChild: Icon(
        submitState.success ? Icons.check : Icons.close,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSubmitText() {
    return DefaultText(
      title,
      key: ValueKey<String>(title),
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tag != null) {
      return Hero(
        tag: tag,
        child: _build(context),
      );
    } else {
      return _build(context);
    }
  }

  AnimatedContainer _build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: submitState.success
            ? Colors.green
            : submitState.error
                ? Theme.of(context).errorColor
                : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: submitState.idle ? onTap : null,
          child: AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              final inAnim = Tween<Offset>(
                begin: Offset(0.0, -1.0),
                end: Offset(0.0, 0.0),
              ).animate(animation);
              final outAnim = Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end: Offset(0.0, 0.0),
              ).animate(animation);
              if (child.key == ValueKey<String>(title)) {
                return ClipRRect(
                  child: SlideTransition(
                    child: Center(child: child),
                    position: inAnim,
                  ),
                );
              } else {
                return ClipRRect(
                  child: SlideTransition(
                    child: Center(child: child),
                    position: outAnim,
                  ),
                );
              }
            },
            duration: animDuration,
            child: submitState.idle ? _buildSubmitText() : _buildLoadingState(),
          ),
        ),
      ),
    );
  }
}
