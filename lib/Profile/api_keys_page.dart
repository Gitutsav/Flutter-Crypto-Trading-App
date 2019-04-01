import 'package:flutter/material.dart';
class APIKeysPage extends StatefulWidget {
  @override
  _APIKeysPageState createState() => _APIKeysPageState();
}

class _APIKeysPageState extends State<APIKeysPage> {

  final _formKey = GlobalKey<FormState>();
  var _apiController = TextEditingController(),
      _secretController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double width = queryData.size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: new AppBar(title: Text('API Keys'),
          backgroundColor: Colors.black,
        ),

        body: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
              Container(
                width: width / 1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 30,
                  bottom: 15,
                ),
                padding: const EdgeInsets.only(
                    left: 5, right: 25, top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text('Enter your API And Secret Key', style: TextStyle(fontSize: 22,
                        color: Colors.black),)
                  ],
                ),
              ),
              Container(
                width: width / 1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 15,
                ),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black.withOpacity(0.08),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter API Key';
                    }
                  },
                  controller: _apiController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "API Key",
                  ),
                ),
              ),

              Container(
                width: width / 1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 15,
                ),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black.withOpacity(0.08),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Secret';
                    }
                  },
                  controller: _secretController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "SECRET",
                  ),
                ),
              ),

              Container(
                width: width / 1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 15,
                ),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
                child: RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'CONFIRM',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {}),
              ),

            ],
          ),
        ),
      ),);
  }
}
