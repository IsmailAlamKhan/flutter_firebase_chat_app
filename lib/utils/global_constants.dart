import 'package:firebase_chat_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const ADDNEW = 'add-new';
const EDIT = 'edit';

final TextTheme defaultTextTheme = GoogleFonts.poppinsTextTheme();
const double TextFieldIconSize = 28;

const APPNAME = 'Covid-19 Case Investigation';
const double TABLETCHANGEPOINT = 900;

/// [20.0]
const double DefPad = 20.0;
const FontWeight BoldFont = FontWeight.bold;
const FontWeight ExtraBoldFont = FontWeight.w800;

const EdgeInsetsGeometry DefPadAll = EdgeInsets.all(DefPad);

const EdgeInsetsGeometry DefPadVertical =
    EdgeInsets.symmetric(vertical: DefPad);

const EdgeInsetsGeometry DefPadHorizontal =
    EdgeInsets.symmetric(horizontal: DefPad);

const EdgeInsetsGeometry DefPadOnlyTop = EdgeInsets.only(top: DefPad);

const EdgeInsetsGeometry DefPadOnlyBottom = EdgeInsets.only(bottom: DefPad);

const EdgeInsetsGeometry DefPadOnlyLeft = EdgeInsets.only(left: DefPad);
const EdgeInsetsGeometry DefPadOnlyRight = EdgeInsets.only(right: DefPad);

const double DefaultElevation = 6.0;

const String AssetPath = 'assets';

const String ImagePath = '$AssetPath/images';
const String PLACEHOLDERIMAGE = '$ImagePath/placeholder.jpg';

const String AppLogo = '$ImagePath/logo-text.png'; //logo.svg';
const String AppLogoColor = '$ImagePath/logo_color.svg'; //logo.svg';

const String placeHolder = '$ImagePath/placeholder.png';

const String profilePlaceHolder = '$ImagePath/placeholder.png';

EdgeInsetsGeometry allPad({double val}) {
  return EdgeInsets.all(val ?? 8);
}

///Top Bottom
EdgeInsetsGeometry symetricVertPad({double val}) {
  return EdgeInsets.symmetric(
    vertical: val ?? 8,
  );
}

///Left Right
EdgeInsetsGeometry symetricHortPad({double val}) {
  return EdgeInsets.symmetric(
    horizontal: val ?? 8,
  );
}

EdgeInsetsGeometry onlyLeftPad({double val}) {
  return EdgeInsets.only(
    left: val ?? 8,
  );
}

EdgeInsetsGeometry onlyRightPad({double val}) {
  return EdgeInsets.only(
    right: val ?? 8,
  );
}

EdgeInsetsGeometry onlyTopPad({double val}) {
  return EdgeInsets.only(
    top: val ?? 8,
  );
}

EdgeInsetsGeometry onlyBottomPad({double val}) {
  return EdgeInsets.only(
    bottom: val ?? 8,
  );
}

EdgeInsetsGeometry onlyPad({
  double top,
  double bottom,
  double right,
  double left,
}) =>
    EdgeInsets.only(
      top: top ?? 0,
      bottom: bottom ?? 0,
      left: left ?? 0,
      right: right ?? 0,
    );
EdgeInsetsGeometry symPad({double vert, double hort}) {
  return EdgeInsets.symmetric(
    vertical: vert ?? 0,
    horizontal: hort ?? 0,
  );
}

final Color primaryColor = Get.context.theme.primaryColor;
final Color primaryColorOverlay = Get.overlayContext.theme.primaryColor;
final Color accentColor = Get.context.theme.accentColor;
final Color accentColorOverlay = Get.overlayContext.theme.accentColor;
final Color disabledColor = Get.context.theme.disabledColor;
final Color disabledColorOverlay = Get.overlayContext.theme.disabledColor;
final Color dividerColor = Get.context.theme.dividerColor;
final Color dividerColorOverlay = Get.overlayContext.theme.dividerColor;
const Color InfoColor = Color(0xFF00BCD4);
const Color WarningColor = Color(0xFFFF9800);
const Color SuccessColor = Color(0xFF4CAF50);
const Color ErrorColor = Color(0xFFF44336);
const Color RoseColor = Color(0xFFE91E63);

/// [Colors.grey[900]]

final Color darkBackgroundColor = Colors.grey[800];

Future<T> openDialog<T>({Widget child, bool barrierDismissible = false}) {
  return Get.dialog(
    child,
    barrierDismissible: barrierDismissible,
    transitionCurve: Curves.bounceInOut,
    transitionDuration: Duration(milliseconds: 500),
  );
}

String formatDate(DateTime date, String customFormat) {
  if (date == null) return null;
  return DateFormat(customFormat ?? 'MM/dd/yyyy').format(date);
}

final NumberFormat formatter = NumberFormat('000000');
DateTime stringToDate(String date) {
  if (date == null) return null;
  return DateTime.tryParse(date);
}

String dateFormat(DateTime date, {String format}) {
  if (date == null) return null;
  return DateFormat(format ?? 'dd-MM-yyyy').format(
    date,
  );
}

void confirmDialog({
  Function(RxBool isLoading) onConfirm,
  String title,
  String body,
}) {
  final isLoading = false.obs;
  Get.dialog(
    AlertDialog(
      content: DefaultText(
        body ?? 'Please confirm to delete',
      ),
      title: DefaultText(title ?? "Confirm"),
      actions: [
        TextButton(
          child: TextToLoading(
            textColor: ErrorColor,
            isLoading: isLoading,
            text: 'Yes',
          ),
          onPressed: () async {
            isLoading(true);
            await 800.milliseconds.delay();
            onConfirm(isLoading);
          },
        ),
        TextButton(
          child: DefaultText(
            'No',
            style: TextStyle(
              color: SuccessColor,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ),
  );
}

void showErrorSnackBar({
  @required String body,
  FlatButton button,
  Duration duration,
  SnackbarStatusCallback snackbarStatus,
}) {
  try {
    Get.rawSnackbar(
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: ErrorColor,
      snackPosition: SnackPosition.TOP,
      mainButton: button,
      borderRadius: 5,
      messageText: DefaultText(
        body,
        maxLines: 30,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      duration: button != null ? 10.seconds : duration ?? 4.seconds,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeInOut,
      barBlur: 20,
      snackbarStatus: snackbarStatus,
      margin: EdgeInsets.zero,
    );
  } catch (e) {
    return;
  }
}

void showInfoSnackBar({
  @required String body,
  FlatButton button,
  Duration duration,
}) {
  try {
    Get.rawSnackbar(
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: InfoColor,
      mainButton: button,
      snackPosition: SnackPosition.TOP,
      borderRadius: 5,
      messageText: DefaultText(
        body,
        maxLines: 30,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      duration: button != null ? 10.seconds : duration ?? 4.seconds,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeInOut,
      barBlur: 20,
      margin: EdgeInsets.zero,
    );
  } catch (e) {
    return;
  }
}

void showSuccessSnackBar({
  @required String body,
  FlatButton button,
  Duration duration,
}) {
  try {
    Get.rawSnackbar(
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: SuccessColor,
      snackPosition: SnackPosition.TOP,
      mainButton: button,
      borderRadius: 5,
      messageText: DefaultText(
        body ?? '',
        maxLines: 30,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      duration: button != null ? 10.seconds : duration ?? 4.seconds,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeInOut,
      barBlur: 20,
      margin: EdgeInsets.zero,
    );
  } catch (e) {
    return;
  }
}

void goBack() {
  return Get.back();
}
