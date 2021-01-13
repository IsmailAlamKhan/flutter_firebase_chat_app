import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphx/graphx.dart';

import 'ui/ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Color(0xFF22AD5C),
        textTheme: GoogleFonts.robotoTextTheme(
          _lightText(),
        ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF16162C),
        brightness: Brightness.dark,
        primaryColor: Color(0xFF22AD5C),
        textTheme: GoogleFonts.robotoTextTheme(
          _darkText(),
        ),
      ),
      initialBinding: BindingsBuilder.put(() => OnboardingController()),
      home: OnBoardingPage(),
    );
  }

  TextTheme _darkText() {
    return TextTheme(
      headline1: TextStyle(
        color: Colors.white,
      ),
      headline2: TextStyle(
        color: Colors.white,
      ),
      headline3: TextStyle(
        color: Colors.white,
      ),
      headline4: TextStyle(
        color: Colors.white,
      ),
      headline5: TextStyle(
        color: Colors.white,
      ),
      headline6: TextStyle(
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
      caption: TextStyle(
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        color: Colors.white,
      ),
    );
  }

  TextTheme _lightText() {
    return TextTheme(
      headline1: TextStyle(
        color: Colors.black,
      ),
      headline2: TextStyle(
        color: Colors.black,
      ),
      headline3: TextStyle(
        color: Colors.black,
      ),
      headline4: TextStyle(
        color: Colors.black,
      ),
      headline5: TextStyle(
        color: Colors.black,
      ),
      headline6: TextStyle(
        color: Colors.black,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
      ),
      caption: TextStyle(
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        color: Colors.black,
      ),
      subtitle2: TextStyle(
        color: Colors.black,
      ),
    );
  }

  TextTheme lightTextTheme(BuildContext context) {
    return TextTheme(
      bodyText1: context.textTheme.bodyText1.copyWith(
        color: Colors.black,
      ),
      bodyText2: context.textTheme.bodyText2.copyWith(
        color: Colors.black,
      ),
      button: context.textTheme.button.copyWith(
        color: Colors.black,
      ),
      caption: context.textTheme.caption.copyWith(
        color: Colors.black,
      ),
      headline1: context.textTheme.headline1.copyWith(
        color: Colors.black,
      ),
      headline2: context.textTheme.headline2.copyWith(
        color: Colors.black,
      ),
      headline3: context.textTheme.headline3.copyWith(
        color: Colors.black,
      ),
      headline4: context.textTheme.headline4.copyWith(
        color: Colors.black,
      ),
      headline5: context.textTheme.headline5.copyWith(
        color: Colors.black,
      ),
      headline6: context.textTheme.headline6.copyWith(
        color: Colors.black,
      ),
      overline: context.textTheme.overline.copyWith(
        color: Colors.black,
      ),
      subtitle1: context.textTheme.subtitle1.copyWith(
        color: Colors.black,
      ),
      subtitle2: context.textTheme.subtitle2.copyWith(
        color: Colors.black,
      ),
    );
  }

  TextTheme darkTextTheme(BuildContext context) {
    return TextTheme(
      bodyText1: context.textTheme.bodyText1.copyWith(
        color: Colors.white,
      ),
      bodyText2: context.textTheme.bodyText2.copyWith(
        color: Colors.white,
      ),
      button: context.textTheme.button.copyWith(
        color: Colors.white,
      ),
      caption: context.textTheme.caption.copyWith(
        color: Colors.white,
      ),
      headline1: context.textTheme.headline1.copyWith(
        color: Colors.white,
      ),
      headline2: context.textTheme.headline2.copyWith(
        color: Colors.white,
      ),
      headline3: context.textTheme.headline3.copyWith(
        color: Colors.white,
      ),
      headline4: context.textTheme.headline4.copyWith(
        color: Colors.white,
      ),
      headline5: context.textTheme.headline5.copyWith(
        color: Colors.white,
      ),
      headline6: context.textTheme.headline6.copyWith(
        color: Colors.white,
      ),
      overline: context.textTheme.overline.copyWith(
        color: Colors.white,
      ),
      subtitle1: context.textTheme.subtitle1.copyWith(
        color: Colors.white,
      ),
      subtitle2: context.textTheme.subtitle2.copyWith(
        color: Colors.white,
      ),
    );
  }
}
