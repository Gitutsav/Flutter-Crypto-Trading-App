import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_trading_app_ui/auth/login_page.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();

  var _fullNameController=TextEditingController(),
      _emailController = TextEditingController(),
      _passwordController = TextEditingController(),
      _repeatPasswordController = TextEditingController();

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


  Future<http.Response> signupUser(/*String fullname,*/String email, String password,String confirmPassword) async {
    print("inside login user");
    final response = await http.post("https://hasura-crypto.jaaga.in/auth/signup" ,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          //"fullname":"$fullname",
          "email":"$email",
          "password":"$password",
          "confirmPassword": "$confirmPassword"
        })
    ).catchError((e){
      print(e);
    });

    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
    else{

      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
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
      child: Scaffold(
        appBar: new AppBar(title: Text('Sign up'),),

        body: SingleChildScrollView(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[

              Container(
                width: width/1.2,
                margin: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 30,
                  bottom: 15,
                ),
                padding: const EdgeInsets.only(
                    left:5,right: 25, top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[

                    Text('Enter your details',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),)
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
                      return 'Please enter username';
                    }
                  },
                  controller: _fullNameController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "FULL NAME",
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
                    left: 25, right: 25, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black.withOpacity(0.08),
                ),
                child: TextFormField(
                  validator: _validateEmail,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "EMAIL ID",
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
                    left: 25, right: 25, top: 15, bottom: 15),
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
                  style: TextStyle(fontSize: 20, color: Colors.black),
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
                    left: 25, right: 25, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black.withOpacity(0.08),
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please reenter password';
                    }
                  },
                  controller: _repeatPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintText: "CONFIRM PASSWORD",
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
                    left: 25, right: 25,top: 5,bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
                child: RaisedButton(
                    color: Colors.black,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()){
                        signupUser(/*_fullNameController.text,*/_emailController.text,_passwordController.text,_passwordController.text);
                      }
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
