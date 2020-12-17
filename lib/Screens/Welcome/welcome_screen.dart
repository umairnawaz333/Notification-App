import 'package:flutter/material.dart';
import 'package:notification_app/Screens/Welcome/components/body.dart';
import 'package:notification_app/Screens/Login/login_screen.dart';
import 'dart:async';
import 'package:notification_app/notification_page.dart';
import 'package:notification_app/SharedPref.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  SharedPref sharedPref = SharedPref();

  @override
  void initState(){
    super.initState();
    check_email();
  }

  void check_email() async{
    String e;
    try {
      e = await sharedPref.reademail("email");
    }
    catch(error){
      print(error);
    }

      print(e);
      if(e != null){
        Timer(Duration(seconds: 4), (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Notifi(),
          ));
        });
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Notifi()));
      }
      else{
        Timer(Duration(seconds: 4), (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
