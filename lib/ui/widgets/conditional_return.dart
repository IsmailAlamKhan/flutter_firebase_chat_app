import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

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
  @override
  Widget build(BuildContext context) {
    trace(condition);
    if (condition) {
      return builder(context);
    } else {
      return (feedBack ?? SizedBox.shrink());
    }
  }
}
