import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFF181D3D),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF181D3D),
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      initialBinding: BindingsBuilder.put(() => OnboardingController()),
      home: OnBoardingPage(),
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
