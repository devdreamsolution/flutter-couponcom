// import 'package:couponcom/pages/main_page.dart';
import 'package:couponcom/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:couponcom/themes/theme.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Almarai'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar"),
      ],
      locale: Locale("ar"),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
          backgroundColor: mainColor,
          seconds: 3,
          navigateAfterSeconds: new OnboardingScreen(),
          // title: new Text(
          //   'كوبون كوم',
          //   style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0,color: Colors.greenAccent),
          // ),
          image: new Image.asset("assets/ios.png"),
          // backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.white
          ),
    );
  }
}
