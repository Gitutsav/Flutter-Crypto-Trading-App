import 'package:flutter/material.dart';
import 'package:flutter_graphql/flutter_graphql.dart';
import 'package:flutter_trading_app_ui/queries/jaaga_hasura.dart' as hasura;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedPage extends StatefulWidget {
  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class ItemData{
  String symbol;
  int tradeId;

  ItemData(this.symbol,this.tradeId);
}
class _CompletedPageState extends State<CompletedPage> {

  int userId;
  int tradeId;
  List list = List();

  double sellPercentage=0,
      requestedSellTrades,
      completedSellTrades,
      buyPercentage=0,
      requestedBuyTrades,
      completedBuyTrades,
      sellValue,
      buyValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      try{
        tradeId=this.tradeId;
        completedSellTrades=this.completedSellTrades;
        completedBuyTrades=this.completedBuyTrades;
            () async {
          userId = await getUserId;

        }();
      }catch(e){
        print(e);
      }
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
          body: Query(
            options: QueryOptions(
              document: hasura.getPercentage,
              variables: {
                'userId':userId,
                'tradeId': tradeId,
              },
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
              list = result.data['requestedTrades'] as List;
              return Stack(
                children: <Widget>[
                  result.loading?Container(
                    child: Center(
                      child: Text("You Don't Have Completed Trades Yet......"),
                    ),
                  ):Container(
                    margin: const EdgeInsets.only(top:15.0),
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          tradeId=list[index]['id'];
                          try{
                            completedSellTrades=0;
                            completedBuyTrades=0;
                            requestedSellTrades=double.parse(list[index]['sellQuantity'].toString());
                            requestedBuyTrades=double.parse(list[index]['buyQuantity'].toString());
                            List completedTradesList=list[index]['completedtradessBylinkedto'] as List;
                            for(int i=0;i<completedTradesList.length;i++){
                              if((completedTradesList[i]['buyQuantity']==null)&&(completedTradesList[i]['sellQuantity']==null)) {
                                buyValue = 0;
                                sellValue = 0;
                              }
                              else{
                                buyValue=double.parse(completedTradesList[i]['buyQuantity'].toString());
                                sellValue=double.parse(completedTradesList[i]['sellQuantity'].toString());
                              }
                              completedBuyTrades=completedBuyTrades+buyValue;
                              completedSellTrades=completedSellTrades+sellValue;
                            }
                            buyPercentage=(completedBuyTrades/requestedBuyTrades)*100;
                            sellPercentage=(completedSellTrades/requestedSellTrades)*100;
                          }catch(e){
                            print(e);
                          }
                          if((buyPercentage==100)&&(sellPercentage==100)){
                              return ListTile(
                                onTap: (){},
                                contentPadding: EdgeInsets.all(10.0),
                                title: new Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: new Column(
                                    children: <Widget>[
                                      Card(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin:const EdgeInsets.only(left: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Container(
                                                          margin:const EdgeInsets.only(top: 10),
                                                          child: Text(list[index]['symbol'].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
                                                      Container(
                                                          child: Text("Buy Qty: "+list[index]['buyQuantity'].toString())),
                                                      Container(
//                                                        margin:const EdgeInsets.only(left: 20,top: 10),
                                                          child: Text("BUY: "+completedBuyTrades.toString()+"/"+list[index]['buyQuantity'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))),
                                                      Container(
//                                                        margin:const EdgeInsets.only(left: 25),
                                                          child: Text("Buy Price: "+list[index]['buyPrice'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))),
                                                      Container(
//                                                        margin:const EdgeInsets.only(left: 25),
                                                          child: Text("SELL: "+completedSellTrades.toString()+"/"+list[index]['sellQuantity'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))),
                                                      Container(
//                                                        margin:const EdgeInsets.only(left: 25,bottom: 10),
                                                          child: Text("Sell Price: "+list[index]['sellPrice'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(right: 20),
                                                    child:CircularPercentIndicator(
                                                      radius: 60.0,
                                                      lineWidth: 5.0,
                                                      percent:sellPercentage/100.round(),
                                                      center: new Text(sellPercentage.round().toString()+"%"),
                                                      progressColor: Colors.blue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(left: 20,bottom: 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text("Created on: "+list[index]['timestamp'].toString().substring(0,10)+" At "+list[index]['timestamp'].toString().substring(11,16)),
                                                  ),
                                                  Container(
                                                    child: Text("Time Since Trade:"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                          }
                          else{
                            return Container();
                          }
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