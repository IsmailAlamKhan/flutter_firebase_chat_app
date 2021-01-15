import 'package:firebase_chat_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogWithLoader extends StatelessWidget {
  final RxDouble value;
  final RxInt sent;
  final RxString uploadText;
  final String nonProgressText;
  final bool wantProggress;
  final RxInt total;

  const DialogWithLoader({
    Key key,
    @required this.value,
    @required this.sent,
    @required this.uploadText,
    @required this.nonProgressText,
    @required this.total,
    @required this.wantProggress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: wantProggress
          ? Obx(
              () => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (wantProggress) ...[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                children: [
                                  currentChild,
                                  ...previousChildren,
                                ],
                              );
                            },
                            duration: 500.milliseconds,
                            transitionBuilder: (child, animation) {
                              final offsetAnimOut = Tween<Offset>(
                                begin: Offset(0.0, 1.0),
                                end: Offset(0.0, 0.0),
                              ).animate(animation);
                              final offsetAnimIn = Tween<Offset>(
                                begin: Offset(0.0, -1.0),
                                end: Offset(0.0, 0.0),
                              ).animate(animation);
                              if (child.key == ValueKey<int>(sent?.value)) {
                                return ClipRRect(
                                  child: SlideTransition(
                                    position: offsetAnimIn,
                                    child: child,
                                  ),
                                );
                              } else {
                                return ClipRRect(
                                  child: SlideTransition(
                                    position: offsetAnimOut,
                                    child: child,
                                  ),
                                );
                              }
                            },
                            child: DefaultText(
                              '$sent',
                              key: ValueKey<int>(sent?.value),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          DefaultText(
                            total == null ? '/100%' : '/$total',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      )
                    ] else
                      SizedBox(
                        height: 10,
                      ),
                    AnimatedSwitcher(
                      duration: 500.milliseconds,
                      child: DefaultText(
                        uploadText != null
                            ? uploadText?.value ?? 'Please Wait'
                            : 'Please Wait',
                        key: ValueKey<String>(uploadText?.value),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: context.width < 500 ? context.width : 400,
                      child: DefaultLoader(
                        value: value?.value,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  DefaultText(
                    nonProgressText ?? 'Please Wait',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: context.width < 500 ? context.width : 400,
                    child: DefaultLoader(
                      value: value?.value,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DefaultLoader extends StatefulWidget {
  final double value;
  const DefaultLoader({
    Key key,
    this.value,
  }) : super(key: key);
  @override
  _DefaultLoaderState createState() => _DefaultLoaderState();
}

class _DefaultLoaderState extends State<DefaultLoader>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: 700.milliseconds,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: widget.value != null
          ? widget.value == 0.0
              ? null
              : widget.value == -1.0
                  ? 0.0
                  : widget.value
          : null,
      minHeight: 10.0,
    );
  }
}

Future<void> showLoadingWithProggress({
  RxDouble value,
  RxInt sent,
  RxString uploadText,
  String nonProgressText,
  bool wantProggress = true,
  RxInt total,
}) async {
  Get.dialog(
    DialogWithLoader(
      uploadText: uploadText,
      nonProgressText: nonProgressText,
      sent: sent,
      total: total,
      value: value,
      wantProggress: wantProggress,
    ),
    barrierDismissible: false,
    barrierColor: Get.overlayContext.theme.primaryColor.withOpacity(.2),
  );
  await Future.delayed(1.seconds);
}
