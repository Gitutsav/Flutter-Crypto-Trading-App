import 'package:flutter/material.dart';
import 'package:flutter_graphql/flutter_graphql.dart';
import 'package:flutter_trading_app_ui/edit_graph_page.dart';
import 'package:flutter_trading_app_ui/graph_page.dart';
import 'package:flutter_trading_app_ui/queries/jaaga_hasura.dart' as hasura;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {

  int userId;
  int tradeId;
  List list = List();
  List completedTradesList=List();

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
      tradeId=this.tradeId;
      completedSellTrades=this.completedSellTrades;
      completedBuyTrades=this.completedBuyTrades;
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
                  Container(
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
                            completedTradesList=list[index]['completedtradessBylinkedto'] as List;
                            for(int i=0;i<completedTradesList.length;i++){
                              if((completedTradesList[i]['buyQuantity']==null)&&(completedTradesList[i]['sellQuantity']==null)) {
                                buyValue = 0;
                                sellValue = 0;
                              }
                              else{
                                buyValue=double.parse(completedTradesList[i]['buyQuantity'].toString());
                                sellValue=double.parse(completedTradesList[i]['sellQuantity'].toString());
                              }
                              print(index.toString()+"th index "+"\n"+completedBuyTrades.toString());
                              completedBuyTrades=completedBuyTrades+buyValue;
                              completedSellTrades=completedSellTrades+sellValue;
                            }
                            buyPercentage=(completedBuyTrades/requestedBuyTrades)*100;
                            sellPercentage=(completedSellTrades/requestedSellTrades)*100;
                          }catch(e){
                            print(e);
                          }
                          if(buyPercentage==100){
                            if(sellPercentage!=100){

                              var item = list[index];

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
                                                          child: Text(item['symbol'].toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
                                                      Container(
//                                                        margin:const EdgeInsets.only(left: 20,top: 10),
                                                          child: Text("SELL: "+completedSellTrades.toString()+"/"+item['sellQuantity'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))),
                                                      Container(
//                                                        margin:const EdgeInsets.only(left: 20,bottom: 10),
                                                          child: Text("Sell Price: "+item['sellPrice'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green))),
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
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin:const EdgeInsets.only(left: 20),
                                                  child: RaisedButton(
                                                    color: Colors.black,
                                                    child: Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context)=>EditGraphPage(
                                                                  item['id'].toString(),
                                                                  item['symbol'].toString(),
                                                                  item['buyQuantity'].toString(),
                                                                  item['buyPrice'].toString(),
                                                                  item['sellQuantity'].toString(),
                                                                  item['sellPrice'].toString(),
                                                                  item['stopLoss'].toString(),
                                                                  item['buyTrailing'].toString(),
                                                                  item['sellTrailing'].toString()
                                                              )));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin:const EdgeInsets.only(left: 20,bottom: 10),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text("Created on: "+item['timestamp'].toString().substring(0,10)+" At "+item['timestamp'].toString().substring(11,16)),
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