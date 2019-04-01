import 'package:flutter/material.dart';
import 'package:flutter_graphql/flutter_graphql.dart';
import 'package:flutter_trading_app_ui/graph_page.dart';
import 'package:flutter_trading_app_ui/queries/jaaga_hasura.dart' as hasura;
import 'package:flutter/widgets.dart';

class USDTPage extends StatefulWidget {
  @override
  _USDTPageState createState() => _USDTPageState();
}

class _USDTPageState extends State<USDTPage> {
  List list = List();

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
          body: Query(
            options: QueryOptions(
              document: hasura.readhasuraUSDTData,
              // this is the query string you just created
              pollInterval: 4,
            ),
            builder: (QueryResult result) {
              if (result.errors != null) {
                print(">>>error in query" + result.toString());
                return Text(result.errors.toString());
              }

              if (result.loading) {
                return Center(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              list = result.data['miniTicker'] as List;

              return Stack(
                children: <Widget>[
                  new Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left:15.0,right: 15.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text('Pair/Vol',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Spacer(),
                        new Text('Last Price',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Spacer(),
                        new Text('24h Chg%',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    height: 1.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top:15.0),
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GraphPage(list[index]['symbol'].toString(),list[index]['close'].toString())));
                            },
                            title: new Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: new Column(
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(top: 5),
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.only(top: 5,bottom: 5),
                                        child:Text(list[index]['symbol'].toString()),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 100,
                                        margin: const EdgeInsets.only(top: 5),
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.all(5),
                                        child:Text(list[index]['close'].toString()),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        color: Colors.tealAccent,
                                        padding: const EdgeInsets.all(5.0),
                                        margin: const EdgeInsets.only(top: 5),
                                        child:Text(list[index]['low'].toString()),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Text("Vol "+list[index]['volume'].toString()),
                                    ],
                                  ),
                                  new Divider(height: 1.0),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
