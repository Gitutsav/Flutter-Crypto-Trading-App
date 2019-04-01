import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/auth/login_page.dart';
import 'package:flutter_trading_app_ui/tabs/switcher.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    loadNextPage();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
        ],
      ), //Stack
    );
  }


  void loadNextPage() async{

    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getBool("check")==true){
      Timer(Duration(seconds: 2), () => _launchSwitcherPage());
    }

    else{
      Timer(Duration(seconds: 2), () => _launchSignupPage());
    }

  }

  _launchSwitcherPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SwitcherPage(0)));
  }

  _launchSignupPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
