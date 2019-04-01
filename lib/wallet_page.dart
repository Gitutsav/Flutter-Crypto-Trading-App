import 'package:flutter/material.dart';
import 'package:flutter_graphql/flutter_graphql.dart';
import 'package:flutter_trading_app_ui/queries/jaaga_hasura.dart' as hasura;
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List list = List();
  int userId;
  double usdtPrice,totalValue=0;
  String coin;
  List walletList=List();
  @override
  void initState() {

    super.initState();

    setState(() {
          () async {
        userId = await getUserId;
      }();
    });
  }
  @override
  Widget build(BuildContext context) {
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
      child: CacheProvider(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,
              title: Text("Wallet", style: TextStyle(color: Colors.white)),
            ),
            body: Query(
                options: QueryOptions(
                  document: hasura.wallet,
                  variables: {'userId':userId},
                  // this is the query string you just created
                ),
                builder: (QueryResult result) {
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

                  list = result.data['wallet'] as List;
                  return Stack(
                    children: <Widget>[
                      Container(
                        child: Text("ESTIMATED VALUE",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(" 0.13449396",
                                style: TextStyle(fontSize: 18)),
                            Text("869.62" + " USD",
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 50.0,left: 15.0,right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("COIN",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text("HOLDINGS",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text("PRICE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1.0,
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              coin=list[index]['coin'].toString()+"USDT";
                              print(coin);
                              return ListTile(
                                onTap: () {},
                                title: new Container(
                                  child: Query(

                                      options: QueryOptions(
                                        document: hasura.walletUSDTData,
                                        variables: {
                                          'coin':coin,
                                        },
                                        // this is the query string you just created
                                      ),

                                      builder: (QueryResult walletresult){


                                        if (walletresult.errors != null) {
                                          return Text("**");
                                        }
                                        if (walletresult.loading) {
                                          return Center(
                                            child: Container(
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        }

                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(list[index]['coin'].toString()),
                                            Spacer(),
                                            Text((list[index]['holding']*walletresult.data['miniTicker'][0]['close']).toString()),
                                            Spacer(),
                                            Text(walletresult.data['miniTicker'][0]['close'].toString()),

                                          ],
                                        );
                                      }
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }),
          )),
    );
  }
  Future get getUserId async{
    int id;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id=prefs.getInt("userId");
    setState(() {
      userId=id;
    });
    return id;

  }
}