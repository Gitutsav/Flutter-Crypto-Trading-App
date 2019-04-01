import 'package:flutter/material.dart';
class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Help",style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child:Column(
              children:<Widget>[
                FlatButton(
                  child:Container(
                    margin: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 20.0,right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.indeterminate_check_box),
                        ),
                        Container(
                          child: Text("FAQ",style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  onPressed:(){},
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
                          margin: const EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.assignment),
                        ),
                        Container(
                          child: Text("App Usage",style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  onPressed:(){},
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
                          margin: const EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.info_outline),
                        ),
                        Container(
                          child: Text("Support",style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  onPressed:(){},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
