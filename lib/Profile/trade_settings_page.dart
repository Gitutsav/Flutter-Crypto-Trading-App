import 'package:flutter/material.dart';
import 'package:flutter_graphql/flutter_graphql.dart';
import 'package:flutter_trading_app_ui/queries/jaaga_hasura.dart' as hasura;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class TradeSettingsPage extends StatefulWidget {
  @override
  _TradeSettingsPageState createState() => _TradeSettingsPageState();
}

class _TradeSettingsPageState extends State<TradeSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  var _defaultProfitController = TextEditingController(),
      _defaultStopLossController = TextEditingController(),
      _defaultTrailingBuyController = TextEditingController(),
      _defaultTrailingSellController = TextEditingController();

  var _defaultProfitSwitchValue = false,
      _defaultStopLossSwitchValue = false,
      _defaultTrailingBuySwitchValue = false,
      _defaultTrailingSellSwitchValue = false;

  int userId;
  bool buttonstate;

  String profit, stopLoss, trailingBuy, trailingSell;

  @override
  void initState() {
    super.initState();
    setState(() {
      buttonstate = false;
      profit = _defaultProfitController.text;
      stopLoss = _defaultStopLossController.text;
      trailingBuy = _defaultTrailingBuyController.text;
      trailingSell = _defaultTrailingSellController.text;
      () async {
        userId = await getUserId;
      }();
    });
  }

  @override
  Widget build(BuildContext context) {
    (() async {
      int id;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      id = preferences.getInt("userId");
      userId = id;
    })();

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
    return Form(
      key: _formKey,
      child: GraphQLProvider(
        client: client,
        child: CacheProvider(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              title:
                  Text("Trade Settings", style: TextStyle(color: Colors.white)),
            ),
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text("Default Profit",
                                style: TextStyle(fontSize: 20)),
                          ),
                          Switch(
                            value: _defaultProfitSwitchValue,
                            onChanged: (bool value) {
                              setState(() {
                                _defaultProfitSwitchValue = value;
                              });
                            },
                          )
                        ])),
                _defaultProfitSwitchValue
                    ? new Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                                border: new Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: TextFormField(
                                autofocus: true,
                                controller: _defaultProfitController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Toast.show("Enter Percentile", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  } else if (double.parse(value) == 0) {
                                    Toast.show(
                                        "Percentile can\'t be zero", context,
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
                                    Toast.show("Percentile can\'t be negative",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  }
                                },
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('%',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))),
                            Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Mutation(
                                  options: MutationOptions(
                                    document: hasura.updateDefaultProfit,
                                    // this is the query string you just created
                                  ),
                                  builder: (RunMutation runMutation,
                                      QueryResult result) {
                                    if (result.errors != null) {
                                      return Text(result.errors.toString());
                                    }

                                    return GestureDetector(
                                      child: RaisedButton(
                                        color: Colors.black,
                                        child: Text(
                                          'Set',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              profit =
                                                  _defaultProfitController.text;
                                              userId = this.userId;
                                            });
                                            try {
                                              runMutation({
                                                'value': profit,
                                                'userid': userId,
                                              });
                                              if (result.errors == null) {
                                                showToast(
                                                    "Default Profit Updated");
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                          }
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("Default Stop Loss",
                            style: TextStyle(fontSize: 20)),
                      ),
                      Switch(
                        value: _defaultStopLossSwitchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _defaultStopLossSwitchValue = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                _defaultStopLossSwitchValue
                    ? new Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                                border: new Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: TextFormField(
                                autofocus: true,
                                controller: _defaultStopLossController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Toast.show("Enter Percentile", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  } else if (double.parse(value) == 0) {
                                    Toast.show(
                                        "Percentile can\'t be zero", context,
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
                                    Toast.show("Percentile can\'t be negative",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  }
                                },
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('%',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))),
                            Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Mutation(
                                  options: MutationOptions(
                                    document: hasura.updateDefaultStopLoss,
                                    // this is the query string you just created
                                  ),
                                  builder: (RunMutation runMutation,
                                      QueryResult result) {
                                    if (result.errors != null) {
                                      return Text(result.errors.toString());
                                    }

                                    return GestureDetector(
                                      child: RaisedButton(
                                          color: Colors.black,
                                          child: Text(
                                            'Set',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                stopLoss =
                                                    _defaultStopLossController
                                                        .text;
                                                userId = this.userId;
                                              });
                                              try {
                                                runMutation({
                                                  'value': stopLoss,
                                                  'userid': userId,
                                                });
                                                if (result.errors == null) {
                                                  showToast(
                                                      "Stop Loss is Updated");
                                                }
                                              } catch (e) {
                                                print(e);
                                              }
                                            }
                                          }),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 20.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("Default Trailing Buy",
                            style: TextStyle(fontSize: 20)),
                      ),
                      Switch(
                        value: _defaultTrailingBuySwitchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _defaultTrailingBuySwitchValue = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                _defaultTrailingBuySwitchValue
                    ? new Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                                border: new Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: TextFormField(
                                autofocus: true,
                                controller: _defaultTrailingBuyController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Toast.show("Enter Percentile", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  } else if (double.parse(value) == 0) {
                                    Toast.show(
                                        "Percentile can\'t be zero", context,
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
                                    Toast.show("Percentile can\'t be negative",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  }
                                },
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('%',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))),
                            Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Mutation(
                                  options: MutationOptions(
                                    document: hasura.updateDefaultTrailingBuy,
                                    // this is the query string you just created
                                  ),
                                  builder: (RunMutation runMutation,
                                      QueryResult result) {
                                    if (result.errors != null) {
                                      return Text(result.errors.toString());
                                    }

                                    return GestureDetector(
                                      child: RaisedButton(
                                          color: Colors.black,
                                          child: Text(
                                            'Set',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                trailingBuy =
                                                    _defaultTrailingBuyController
                                                        .text;
                                                userId = this.userId;
                                              });
                                              try {
                                                runMutation({
                                                  'value': trailingBuy,
                                                  'userid': userId,
                                                });
                                                if (result.errors == null) {
                                                  showToast(
                                                      "Trailing Buy is Updated");
                                                }
                                              } catch (e) {
                                                print(e);
                                              }
                                            }
                                          }),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 20.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Text("Default Trailing Sell",
                            style: TextStyle(fontSize: 20)),
                      ),
                      Switch(
                        value: _defaultTrailingSellSwitchValue,
                        onChanged: (bool value) {
                          setState(() {
                            _defaultTrailingSellSwitchValue = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                _defaultTrailingSellSwitchValue
                    ? new Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                                border: new Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: TextFormField(
                                autofocus: true,
                                controller: _defaultTrailingSellController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    Toast.show("Enter Percentile", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  } else if (double.parse(value) == 0) {
                                    Toast.show(
                                        "Percentile can\'t be zero", context,
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
                                    Toast.show("Percentile can\'t be negative",
                                        context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.CENTER);
                                    return '*';
                                  }
                                },
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text('%',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))),
                            Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Mutation(
                                  options: MutationOptions(
                                    document: hasura.updateDefaultTrailingSell,
                                    // this is the query string you just created
                                  ),
                                  builder: (RunMutation runMutation,
                                      QueryResult result) {
                                    if (result.errors != null) {
                                      return Text(result.errors.toString());
                                    }

                                    return GestureDetector(
                                      child: RaisedButton(
                                          color: Colors.black,
                                          child: Text(
                                            'Set',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                trailingSell =
                                                    _defaultTrailingSellController
                                                        .text;
                                                userId = this.userId;
                                              });
                                              try {
                                                runMutation({
                                                  'value': trailingSell,
                                                  'userid': userId,
                                                });
                                                if (result.errors == null) {
                                                  showToast(
                                                      "Trailing Sell is Updated");
                                                }
                                              } catch (e) {
                                                print(e);
                                              }
                                            }
                                          }),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  Future get getUserId async {
    int id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt("userId");
    return id;
  }
}
