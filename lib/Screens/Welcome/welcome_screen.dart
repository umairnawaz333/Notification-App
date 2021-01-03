import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/Screens/Welcome/components/body.dart';
import 'package:notification_app/Screens/Login/login_screen.dart';
import 'dart:async';
import 'package:notification_app/notification_page.dart';
import 'package:notification_app/SharedPref.dart';
import 'package:notification_app/user_manager.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  SharedPref sharedPref = SharedPref();
  String type;

  @override
  void initState(){
    super.initState();
    check_email();
  }

  void check_email() async{
    String e;
    try {
      e = await sharedPref.reademail("email");
      await Firebase.initializeApp();
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference ref = _firestore.collection("users").doc(e);
      DocumentSnapshot userRef = await ref.get();
      print("user type: "+userRef.get("type"));
      type = userRef.get("type");
      sharedPref.save("type", type);
    }
    catch(error){
      print(error);
    }

      print(e);
      if(e != null){
        Timer(Duration(seconds: 4), (){
          if(e == "umair.nawaz1997@gmail.com"){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                user_manager()), (Route<dynamic> route) => false);
          }
          else{
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                Notifi()), (Route<dynamic> route) => false);
          }
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Notifi()));
        });
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
