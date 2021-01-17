import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionalReturn extends StatelessWidget {
  const ConditionalReturn(
    this.condition, {
    Key key,
    @required this.builder,
    this.feedBack,
  }) : super(key: key);
  final bool condition;
  final Function(BuildContext context) builder;
  final Widget feedBack;
  Widget _build(BuildContext context) {
    if (condition) {
      return builder(context);
    } else {
      return (feedBack ?? SizedBox.shrink());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 500.milliseconds,
      child: _build(context),
    );
  }
}
