import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';

class OnBoardingPage extends GetView<OnboardingController> {
  const OnBoardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('$ImagePath/intro.png'),
            ),
            ClipPath(
              clipper: MyInvertedCurvyPath(),
              child: Container(
                height: context.height / 2,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                ),
                width: context.width,
                alignment: Alignment.center,
                child: _build(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          60.0.sizedHeight,
          Text(
            'Let\'s connect\nwith each other',
            textAlign: TextAlign.center,
            style: context.textTheme.headline4.copyWith(
              color: Colors.white,
            ),
          ),
          20.0.sizedHeight,
          Text(
            'A messege is a discrete communication\nintended by the source consumption',
            textAlign: TextAlign.center,
            style: context.textTheme.subtitle1.copyWith(
              color: Color(0xFF4F5474),
            ),
          ),
          25.0.sizedHeight,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFE55D6F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: Size(140, 50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lets Start'),
                10.0.sizedWidth,
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Clipper sample.
class MyCurvyPath extends GraphicsClipper {
  @override
  void draw(Graphics g, Size size) {
    final curveSize = 60.0;
    final targetW = size.width;
    final targetH = size.height;
    g
        .moveTo(0, curveSize)
        .curveTo(0, 0, curveSize, 0)
        .lineTo(targetW - curveSize, 0)
        .curveTo(targetW, 0, targetW, -curveSize)
        .lineTo(targetW, targetH)
        .lineTo(0, targetH)
        .closePath();
    y = curveSize;
  }
}

/// Clipper sample.
class MyInvertedCurvyPath extends GraphicsClipper {
  @override
  void draw(Graphics g, Size size) {
    final curveSize = 60.0;
    final targetW = size.width;
    final targetH = size.height;
    g
        .moveTo(0, curveSize)
        .curveTo(0, 0, curveSize, 0)
        .lineTo(targetW - curveSize, 0)
        .curveTo(targetW, 0, targetW, -curveSize)
        .lineTo(targetW, targetH)
        .lineTo(0, targetH)
        .closePath();
    y = curveSize;
  }
}
