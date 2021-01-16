import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphx/graphx.dart';

import 'statemangement/statemangement.dart';
import 'ui/ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  traceConfig(
    argsSeparator: "=>",
    showClassname: true,
    showFilename: true,
    showLinenumber: true,
    showMethodname: true,
  );
  Get.put(FirebaseService());
  Get.put(UserController());
  Get.put(AuthService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      title: 'Ismail Chat App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Color(0xFF3CE261),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF16162C),
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        primaryColor: Color(0xFF3CE261),
      ),
      initialBinding: AuthBinding(),
      home: ('onBoarding'.getValue ?? false) ? Root() : OnBoardingPage(),
    );
  }
}
