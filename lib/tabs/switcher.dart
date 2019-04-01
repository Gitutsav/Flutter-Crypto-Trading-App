import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/Profile/profile_page.dart';
import 'package:flutter_trading_app_ui/market_data_page.dart';
import 'package:flutter_trading_app_ui/trades/trades.dart';
import 'package:flutter_trading_app_ui/wallet_page.dart';
class SwitcherPage extends StatefulWidget {

  int index;

  SwitcherPage(this.index);

  @override
  _SwitcherPageState createState() => _SwitcherPageState();
}

class _SwitcherPageState extends State<SwitcherPage> {

  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex=widget.index;
  }

  final List<Widget> _children = [
    MarketDataPage(),
    Trades(),
    WalletPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap:onTabTapped,// this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.attach_money),
              title: new Text('Markets'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.show_chart),
              title: new Text('Trades'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.account_balance_wallet),
              title: new Text('Wallet'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onBackPressed()async{
    return showDialog(
      context: context,
      builder:(context)=>AlertDialog(
        title: Text("Do you really want to exit the app?"),
        actions: <Widget>[
          FlatButton(
              onPressed: ()=>Navigator.pop(context,false),
              child: Text("No")),
          FlatButton(
              onPressed: ()=>exit(0),
              child: Text("Yes"))
        ],
      ),
    );
  }
}


