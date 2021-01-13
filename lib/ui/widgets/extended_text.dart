import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_chat_app/utils/utils.dart';

class DefaultText extends StatelessWidget {
  const DefaultText(
    this.text, {
    Key key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.isBold = false,
  }) : super(key: key);
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool isBold;
  @override
  Widget build(BuildContext context) {
    return Text(
      text?.tr ?? '',
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: style == null
          ? TextStyle(
              letterSpacing: 1,
              fontWeight: isBold ? BoldFont : null,
            )
          : style.copyWith(
              letterSpacing: 1,
              fontWeight: style.fontWeight != null
                  ? style.fontWeight
                  : isBold
                      ? BoldFont
                      : null,
            ),
    );
  }
}

class TextToLoading extends StatelessWidget {
  const TextToLoading({
    Key key,
    @required this.isLoading,
    @required this.text,
    this.textColor,
    this.isTextButton = true,
  }) : super(key: key);
  final RxBool isLoading;
  final String text;
  final Color textColor;
  final bool isTextButton;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: 400.milliseconds,
        transitionBuilder: (child, animation) {
          final inAnim = Tween(
            begin: Offset(0.0, -5),
            end: Offset(0.0, 0),
          ).animate(animation);
          final outAnim = Tween(
            begin: Offset(0.0, 5),
            end: Offset(0.0, 0),
          ).animate(animation);
          if (child.key == ValueKey<String>('Loading')) {
            return ClipRRect(
              child: SlideTransition(
                position: inAnim,
                child: child,
              ),
            );
          } else {
            return ClipRRect(
              child: SlideTransition(
                position: outAnim,
                child: child,
              ),
            );
          }
        },
        child: isLoading.value
            ? Container(
                height: 30,
                width: 30,
                key: ValueKey<String>('Loading'),
                padding: EdgeInsets.all(5),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                ),
              )
            : DefaultText(
                text,
                style: TextStyle(
                  color: textColor,
                ),
              ),
      ),
    );
  }
}

class HeroText extends StatelessWidget {
  const HeroText({
    Key key,
    @required this.text,
    @required this.tag,
    this.style,
  }) : super(key: key);
  final String text;
  final TextStyle style;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
