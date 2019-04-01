import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/tabs/bnb_page.dart';
import 'package:flutter_trading_app_ui/tabs/btc_page.dart';
import 'package:flutter_trading_app_ui/tabs/eth_page.dart';
import 'package:flutter_trading_app_ui/tabs/usdt_page.dart';

class MarketDataPage extends StatefulWidget {

  @override
  _MarketDataPageState createState() => _MarketDataPageState();
}

class _MarketDataPageState extends State<MarketDataPage> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState(){
    controller=new TabController( vsync: this,length: 4,);
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
        title: Text("Markets",style: TextStyle(color: Colors.white)),
          bottom: new TabBar(
            controller: controller,
            tabs: <Widget>[
              new Tab(text: 'BNB'),
              new Tab(text: 'BTC'),
              new Tab(text: 'ALTS'),
              new Tab(text: 'USDT'),
            ],
            labelColor: Colors.white,
          ),
    ),
      body: new TabBarView(
          controller: controller,
          children: <Widget>[
            BNBPage(),
            BTCPage(),
            ETHPage(),
            USDTPage(),
          ]),

    );
  }
}
