import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_trading_app_ui/tabs/switcher.dart';
import 'package:flutter_trading_app_ui/trades/tabs/buy_page.dart';
import 'package:flutter_trading_app_ui/trades/tabs/completed_page.dart';
import 'package:flutter_trading_app_ui/trades/tabs/sell_page.dart';

class Trades extends StatefulWidget {
  @override
  _TradesState createState() => _TradesState();
}

class _TradesState extends State<Trades> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState(){
    controller=new TabController( vsync: this,length: 4);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("Trades",style: TextStyle(color: Colors.white)),
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(text: 'BUY'),
            new Tab(text: 'SELL'),
            new Tab(text: 'COMPLETED'),
          ],
          labelColor: Colors.white,
        ),
      ),
      body: new TabBarView(
          controller: controller,
          children: <Widget>[
            BuyPage(),
            SellPage(),
            CompletedPage(),
          ]),

    );
  }

//  Future<bool> _onBackPressed()async{
//    Navigator.push(context, MaterialPageRoute(builder: (context)=>SwitcherPage()));
//    return false;
//  }
}
