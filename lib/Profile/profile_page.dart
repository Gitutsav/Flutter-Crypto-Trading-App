import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/Profile/help_page.dart';
import 'package:flutter_trading_app_ui/Profile/account_page.dart';
import 'package:flutter_trading_app_ui/Profile/api_keys_page.dart';
import 'package:flutter_trading_app_ui/Profile/trade_settings_page.dart';
import 'package:flutter_trading_app_ui/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text("Profile",style: TextStyle(color: Colors.white)),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child:Column(
                  children:<Widget>[
                    FlatButton(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20.0,bottom: 10.0,left: 20.0,right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.person),
                            ),
                            Container(
                              child: Text("Account",style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountPage()));
                      },
                    ),
                    new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Divider()
                    ),
                    FlatButton(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 20.0,right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.lock),
                            ),
                            Container(
                              child: Text("API Keys",style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>APIKeysPage()));
                      },
                    ),
                    new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Divider()
                    ),
                    FlatButton(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 20.0,right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.show_chart),
                            ),
                            Container(
                              child: Text("Trade Settings",style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TradeSettingsPage()));
                      },
                    ),
                    new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Divider()
                    ),
                    FlatButton(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 20.0,right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.help),
                            ),
                            Container(
                              child:  Text("Help",style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      onPressed:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpPage()));
                      },
                    ),
                    new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: new Divider()
                    ),
                    FlatButton(
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 20.0,right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.exit_to_app),
                            ),
                            Container(
                              child:  Text("Logout",style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      onPressed:(){
                        _logoutFormApp(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _logoutFormApp(BuildContext context) async{

    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("check", false);
    sharedPreferences.setString("password", "");
    sharedPreferences.commit();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
}
