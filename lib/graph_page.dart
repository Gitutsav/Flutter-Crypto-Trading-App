import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_trading_app_ui/tabs/switcher.dart';
import 'package:flutter_graphql/flutter_graphql.dart';
import 'package:flutter_trading_app_ui/queries/jaaga_hasura.dart' as hasura;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class GraphPage extends StatefulWidget {
  String symbol, lastPrice;
  GraphPage(this.symbol, this.lastPrice);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  double buyCostOfTrade = 0.0;
  double sellCostOfTrade = 0.0;
  double costOfTrade = 0.0;

  int userId;
  bool buttonstate;
  bool buyAlertConfirm, sellAlertConfirm;
  List Graphlist=List();

  String Symbol,
      LastPrice,
      buyQuantity,
      buyPrice,
      sellQuantity,
      sellPrice,
      advanceStopLoss,
      advanceTrailingSell,
      advanceTrailingBuy;

  @override
  void initState() {
    super.initState();
    setState(() {
      buttonstate = false;
      buyAlertConfirm = false;
      sellAlertConfirm = false;
      Symbol = widget.symbol;
      LastPrice = widget.lastPrice;
      buyQuantity = _buyCoinController.text;
      _buyPriceController.text = LastPrice;
      buyPrice = _buyPriceController.text;
      sellQuantity = _sellCoinController.text;
      sellPrice = _sellPriceController.text;
      advanceStopLoss = _stopLossController.text;
      advanceTrailingSell = _trailingSellController.text;
      advanceTrailingBuy = _trailingBuyController.text;
      () async {
        userId = await getUserId;
      }();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> data =List();
//    = [
//      0.004136,
//      0.0041383,
//      0.004141,
//      0.0041313,
//      0.00413,
//      0.0041299,
//      0.00413,
//      0.00413,
//      0.0041254,
//      0.0041312,
//      0.0041307,
//      0.0041285,
//      0.0041264,
//      0.0041279,
//      0.004129,
//      0.004129,
//      0.004125,
//      0.0041246,
//      0.0041235,
//      0.0041252
//    ];

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double height = queryData.size.height;
    double width = queryData.size.width;

    _buyAlertDailoge() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Form(
              key: _formKey,
              child: AlertDialog(
                title:
                    Text("Total Cost of Trade :", textAlign: TextAlign.center),
                content: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                "COINS",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Text(" "),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "BUY PRICE",
                                  style: TextStyle(fontSize: 18),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _buyCoinController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Coins", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Coins can\'t be negative", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text("X")),
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _buyPriceController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Price", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Price can\'t be negative", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      buttonstate = false;
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    color: Colors.black,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        showToast("Done");
                        setState(() {
                          buyQuantity = _buyCoinController.text;
                          buyPrice = _buyPriceController.text;
                          userId = this.userId;
                          buyAlertConfirm = true;
                        });
                        setState(() {
                          buyCostOfTrade = double.parse(buyQuantity) *
                              double.parse(buyPrice);
                        });

                        Navigator.pop(context);
                      }
                    },
                    child: Text("OK",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    color: Colors.black,
                  ),
                ],
              ),
            );
          });
    }

    _sellAlertDailoge() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Form(
              key: _formKey,
              child: AlertDialog(
                title:
                    Text("Total Cost of Trade :", textAlign: TextAlign.center),
                content: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                "COINS",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Text(" "),
                            Container(
                                child: Text(
                              "SELL PRICE",
                              style: TextStyle(fontSize: 18),
                            )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _sellCoinController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Coins", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Coins can\'t be negative", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text("X")),
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _sellPriceController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Price", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Price can\'t be negative", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      buttonstate = false;
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    color: Colors.black,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        showToast("Done");
                        setState(() {
                          sellQuantity = _sellCoinController.text;
                          sellPrice = _sellPriceController.text;
                          userId = this.userId;
                          sellAlertConfirm = true;
                        });
                        setState(() {
                          sellCostOfTrade = double.parse(sellQuantity) *
                              double.parse(sellPrice);
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text("OK",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    color: Colors.black,
                  ),
                ],
              ),
            );
          });
    }

    _advanceAlertDailoge() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            MediaQueryData queryData;
            queryData = MediaQuery.of(context);

            double dialog_width = queryData.size.width;
            return AlertDialog(
              content: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: dialog_width / 3,
                              child: Text(
                                "STOP LOSS :",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _stopLossController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Percentile", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) > 100) {
                                      Toast.show(
                                          "Percentile can\'t be greater than 100",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Percentile can\'t be negative",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            ),
                            Text("%"),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: dialog_width / 3,
                              child: Text(
                                "TRAILING SELL :",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _trailingSellController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Percentile", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) > 100) {
                                      Toast.show(
                                          "Percentile can\'t be greater than 100",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Percentile can\'t be negative",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            ),
                            Text("%"),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: dialog_width / 3,
                              child: Text(
                                "TRAILING BUY :",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                  border: new Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _trailingBuyController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Toast.show("Enter Percentile", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) > 100) {
                                      Toast.show(
                                          "Percentile can\'t be greater than 100",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    } else if (double.parse(value) < 0) {
                                      Toast.show(
                                          "Percentile can\'t be negative",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.CENTER);
                                      return '*';
                                    }
                                  },
                                ),
                              ),
                            ),
                            Text("%"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("CANCEL",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  color: Colors.black,
                ),
                RaisedButton(
                  onPressed: () {
                    showToast("Done");
                    setState(() {
                      advanceStopLoss = _stopLossController.text;
                      advanceTrailingSell = _trailingSellController.text;
                      advanceTrailingBuy = _trailingBuyController.text;
                      userId = this.userId;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("OK",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  color: Colors.black,
                ),
              ],
            );
          });
    }

    _startTradeAlertDailoge() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            HttpLink link = HttpLink(
              uri: 'https://hasura-crypto.jaaga.in/v1alpha1/graphql',
              headers: <String, String>{
                'x-hasura-admin-secret': 'tradeplan',
              },
            );

            ValueNotifier<GraphQLClient> client = ValueNotifier(
              GraphQLClient(
                cache: InMemoryCache(),
                link: link,
              ),
            );
//            MediaQueryData queryData;
//            queryData = MediaQuery.of(context);
//
//            double dialog_height = queryData.size.height;

            return GraphQLProvider(
              client: client,
              child: CacheProvider(
                child: AlertDialog(
                  title: Text(Symbol, textAlign: TextAlign.center),
                  content: Container(
                    height: 50,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Cost Of Trade ",
                                style: TextStyle(fontSize: 20)),
                            Text("\$" + costOfTrade.toString(),
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),

//                        Container(
//                          margin: const EdgeInsets.only(top: 5, bottom: 5),
//                          color: Colors.grey,
//                          height: 1.0,
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text("Potential Gain ", style: TextStyle(fontSize: 20)),
//                            Text("\$ 2800", style: TextStyle(fontSize: 20)),
//                          ],
//                        ),
//                        Container(
//                          margin: const EdgeInsets.only(top: 5, bottom: 5),
//                          color: Colors.grey,
//                          height: 1.0,
//                        ),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text("Potential Loss ", style: TextStyle(fontSize: 20)),
//                            Text("\$ 2600", style: TextStyle(fontSize: 20)),
//                          ],
//                        ),
//
                        Container(
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          color: Colors.grey,
                          height: 1.0,
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Mutation(
                        options: MutationOptions(
                          document: hasura.insertStartTrades,
                        ),
                        builder: (RunMutation runMutation, QueryResult result) {
                          if (result.errors != null) {
                            return Text(result.errors.toString());
                          }

                          return RaisedButton(
                            color: Colors.black,
                            child: Text('Confirm',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                if (buyQuantity.isEmpty) {
                                  buyQuantity = 0.toString();
                                } else {
                                  buyQuantity = _buyCoinController.text;
                                }

                                //------
                                if (buyPrice.isEmpty) {
                                  buyPrice = 0.toString();
                                } else {
                                  buyPrice = _buyPriceController.text;
                                }

                                //-----
                                if (sellQuantity.isEmpty) {
                                  sellQuantity = 0.toString();
                                } else {
                                  sellQuantity = _sellCoinController.text;
                                }

                                //-----
                                if (sellPrice.isEmpty) {
                                  sellPrice = 0.toString();
                                } else {
                                  sellPrice = _sellPriceController.text;
                                }

                                //-----
                                if (advanceTrailingSell.isEmpty) {
                                  advanceTrailingSell = 0.toString();
                                } else {
                                  advanceTrailingSell =
                                      _trailingSellController.text;
                                }

                                //---
                                if (advanceTrailingBuy.isEmpty) {
                                  advanceTrailingBuy = 0.toString();
                                } else {
                                  advanceTrailingBuy =
                                      _trailingBuyController.text;
                                }

                                //-----
                                if (advanceStopLoss.isEmpty) {
                                  advanceStopLoss = 0.toString();
                                } else {
                                  advanceStopLoss = _stopLossController.text;
                                }
                              });

                              print('symbol:' +
                                  Symbol.toString() +
                                  'buyCoin:' +
                                  buyQuantity +
                                  'buyPrice:' +
                                  buyPrice +
                                  'sellCoin:' +
                                  sellQuantity +
                                  'sellPrice:' +
                                  sellPrice +
                                  'trailingSell:' +
                                  advanceTrailingSell +
                                  'trailingBuy:' +
                                  advanceTrailingBuy +
                                  'stopLoss:' +
                                  advanceStopLoss +
                                  'userid:' +
                                  this.userId.toString());
                              try {
                                runMutation({
                                  'symbol': Symbol.toString(),
                                  'buyCoin': buyQuantity,
                                  'buyPrice': buyPrice,
                                  'sellCoin': sellQuantity,
                                  'sellPrice': sellPrice,
                                  'trailingSell': advanceTrailingSell,
                                  'trailingBuy': advanceTrailingBuy,
                                  'stopLoss': advanceStopLoss,
                                  'userid': this.userId,
                                });
                              } catch (e) {
                                print(e);
                              }
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SwitcherPage(1)));
                            },
                          );
                        }),
                  ],
                ),
              ),
            );
          });
    }

    setState(() {
      costOfTrade = buyCostOfTrade + sellCostOfTrade;
    });

    HttpLink link = HttpLink(
      uri: 'https://hasura-crypto.jaaga.in/v1alpha1/graphql',
      headers: <String, String>{
        'x-hasura-admin-secret': 'tradeplan',
      },
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              Symbol,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('LAST'),
                  Text(widget.lastPrice.toString()),
                ],
              ),
            )
          ],
        ),
        body: Query(
          options: QueryOptions(
            document: hasura.getGraphData,
            variables: {'coin':widget.symbol}
          ),
          builder: (QueryResult result){

            if (result.errors != null) {
              return Text(result.errors.toString());
            }

            if (result.loading) {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            Graphlist= result.data['miniTicker'] as List;
            print(">>>>>>>"+Graphlist.toString());

            for(int i=0;i<Graphlist.length;i++){

              data.add(Graphlist[i]['close'] as double);
            }

            print(">>>>>>>"+data.toString());



            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
//                Container(
//                  alignment: Alignment(0.9, -0.98),
//                  child: Text(
//                    "Balance : \$ 5000",
//                    style: TextStyle(fontSize: 18),
//                    textAlign: TextAlign.end,
//                  ),o
//                ),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                        height: height / 2.4,
                        width: width,
                        child: Container(
                          child: Sparkline(
                            data: data,
                            lineWidth: 1.0,
                            lineColor: Colors.black,
                            pointsMode: PointsMode.all,
                            pointSize: 2.0,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                        const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, top: 15, bottom: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Cost Of Trade ",
                                    style: TextStyle(fontSize: 20)),
                                Text("\$" + costOfTrade.toString(),
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 50.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: _buyAlertDailoge,
                              child: Column(
                                children: <Widget>[
                                  Text('BUY', style: TextStyle(fontSize: 18)),
                                  Text(buyQuantity + " Coins",
                                      style: TextStyle(color: Colors.grey)),
                                  Text(buyPrice,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            RaisedButton(
                              onPressed: _sellAlertDailoge,
                              child: Column(
                                children: <Widget>[
                                  Text('SELL', style: TextStyle(fontSize: 18)),
                                  Text(sellQuantity + " Coins",
                                      style: TextStyle(color: Colors.grey)),
                                  Text(sellPrice,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                            RaisedButton(
                              onPressed: _advanceAlertDailoge,
                              child: Column(
                                children: <Widget>[
                                  Text('ADVANCED', style: TextStyle(fontSize: 14)),
                                  Text("Stop Loss: " + advanceStopLoss,
                                      style: TextStyle(color: Colors.grey)),
                                  Text("Trailing Sell: " + advanceTrailingSell,
                                      style: TextStyle(color: Colors.grey)),
                                  Text("Trailing Buy: " + advanceTrailingBuy,
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ],
                        ),
                      ),

                      (buyAlertConfirm || sellAlertConfirm)
                          ? RaisedButton(
                        child: Text("START TRADE",
                            style: TextStyle(color: Colors.white)),
                        onPressed: _startTradeAlertDailoge,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      )
                          : RaisedButton(
                        child: Text("START TRADE",
                            style: TextStyle(color: Colors.white)),
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  var _buyCoinController = TextEditingController(),
      _buyPriceController = TextEditingController(),
      _sellCoinController = TextEditingController(),
      _sellPriceController = TextEditingController(),
      _stopLossController = TextEditingController(),
      _trailingSellController = TextEditingController(),
      _trailingBuyController = TextEditingController();

  Future get getUserId async {
    int id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("userId");
    return id;
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  toInt() {}
}
