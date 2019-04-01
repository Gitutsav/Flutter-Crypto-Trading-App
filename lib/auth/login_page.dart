import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/auth/signup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var _userNameController = TextEditingController(),
      _passwordController = TextEditingController();


  String email;
  bool checkValue = false;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    () async {
      email = await getEmail;
    }();
    getCredential();
  }


  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }

  Future<http.Response> loginUser(String email, String password) async {
    final response = await http.post("https://hasura-crypto.jaaga.in/auth/login" ,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email":"$email",
          "password":"$password",
        })
    ).catchError((e){
      print(e);
    });

    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      _onLogin(true,response);
      Navigator.pushNamed(context, '/switcher');
    }
    else{
      setState(() {
        email=_userNameController.text;
      });
      return showDialog(
        context: context,
        builder:(context)=>AlertDialog(
          title: Text("Invalid Username Or Password"),
          actions: <Widget>[
            FlatButton(
                onPressed: ()=>Navigator.pop(context),
                child: Text("OK",style: TextStyle(fontSize: 20),)
            ),
          ],
        ),
      );
//      Navigator.pushNamed(context, '/login');
    }
    return response;

  }


  @override
  Widget build(BuildContext context) {

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double width=queryData.size.width;

    return Form(
      key: _formKey,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width/1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 10,
                ),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black.withOpacity(0.08),
                ),
                child: TextFormField(
                  autofocus: true,
                  validator: _validateEmail,
                  controller: _userNameController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "EMAIL",
                  ),
                ),
              ),
              Container(
                width: width/1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 10,
                ),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black.withOpacity(0.08),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter password';
                    }
                  },

                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintText: "PASSWORD",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              Container(
                width: width/1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 15,
                ),
                padding: const EdgeInsets.only(
                    left: 25, right: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
                child: RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      //loginUser("naiduprakash9964@gmail.com","Chinna@2662");
                      setState(() {
                        email=_userNameController.text;
                      });
                      if (_formKey.currentState.validate()){
                        loginUser(email,_passwordController.text);
                      }
                      else{
                        //Do Something
                      }

                      //loginUser(_userNameController.toString(),_passwordController.toString());
                    }),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[

                  Container(
                      padding: const EdgeInsets.only(right: 10,top: 20),
                      child: Text( ' \Don\'t have an account?',style: TextStyle(fontSize: 18,color: Colors.black54),)),

                  GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.only(right: 10,top: 20),
                        child: Text('SIGN UP',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),)
                    ),
                    onTap: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );},
                  ),
                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  void getCredential() async{

    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          _userNameController.text = sharedPreferences.getString("username");
          _passwordController.text = sharedPreferences.getString("password");
        } else {
          _userNameController.clear();
          _passwordController.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }



  _onLogin(bool value, http.Response response) async {

    Map res=jsonDecode(response.body.toString());

    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setBool("check", checkValue);
      sharedPreferences.setString("username", _userNameController.text);
      sharedPreferences.setString("password", _passwordController.text);
      sharedPreferences.setInt("userId", res["id"]);
      sharedPreferences.commit();
      getCredential();
    });
  }
  Future get getEmail async{
    String name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name=prefs.get("username");
    setState(() {
      email=name;
    });
    return name;

  }

  Future<bool> _onBackPressed()async{
    return showDialog(
      context: context,
      builder:(context)=>AlertDialog(
        title: Text("Do you really want to exit the app?"),
        actions: <Widget>[
          FlatButton(
              onPressed: ()=>Navigator.pop(context,false),
              child: Text("No")),
          FlatButton(
              onPressed: ()=>exit(0),
              child: Text("Yes"))
        ],
      ),
    );
  }
}
