import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/auth/login_page.dart';
import 'package:flutter_trading_app_ui/auth/signup_page.dart';
import 'package:flutter_trading_app_ui/graph_page.dart';
import 'package:flutter_trading_app_ui/market_data_page.dart';
import 'package:flutter_trading_app_ui/splash_screen_page.dart';
import 'package:flutter_trading_app_ui/tabs/switcher.dart';


void main() async {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
    theme: new ThemeData(
      cursorColor: Colors.black,
      primarySwatch: MaterialColor(0xFF000000, <int, Color>{
        50: Color(0xFFe5e5e5),
        100: Color(0xFFcccccc),
        200: Color(0xFFb2b2b2),
        300: Color(0xFF999999),
        400: Color(0xFF7f7f7f),
        500: Color(0xFF666666),
        600: Color(0xFF4c4c4c),
        700: Color(0xFF323232),
        800: Color(0xFF191919),
        900: Color(0xFF000000),
      }
      ),
    ),
    initialRoute: '/',
    routes: {
      '/login': (context) => LoginScreen(),
      '/sigup': (context) => SignupScreen(),
      '/market_data': (context) => MarketDataPage(),
      '/switcher':(context)=>SwitcherPage(0),
      '/graph':(context)=>GraphPage(null,null),
    },
  ),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return new SplashScreen();
  }
}
