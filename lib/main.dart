import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'SharedPref.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  String _message = '';
  SharedPref sharedPref = SharedPref();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<String> loaddata = [];
  List<String> reverselist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSharedPrefs();
    getMessage();
  }

  loadSharedPrefs() async {
    try {
      List<String> mydata = await sharedPref.read("user");
      setState(() {
        loaddata = mydata;
        reverselist = loaddata.reversed.toList();
      });
    } catch (Excepetion) {
      print("jbsvuosdin  nc error...");
    }
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() {
        loaddata.add(message["data"]["mytext"]);
        reverselist = loaddata.reversed.toList();
        sharedPref.save("user", loaddata);
      });
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() {
        _firebaseMessaging.onTokenRefresh;
        loaddata.add(message["data"]["mytext"]);
        reverselist = loaddata.reversed.toList();
        sharedPref.save("user", loaddata);
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() {
        _firebaseMessaging.onTokenRefresh;
        loaddata.add(message["data"]["mytext"]);
        reverselist = loaddata.reversed.toList();
        sharedPref.save("user", loaddata);
      });
    });
  }

  send_notfication() async {
    final String serverToken = 'AIzaSyC57VRYCA5kjUiv4MKYr03CJGDiMfBEpvk';
      await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'this is a body',
              'title': 'this is a title'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'mytext': '1'
            },
            'to': await _firebaseMessaging.getToken(),
          },
        ),
      );

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: (reverselist.length > 0)
          ? ListView.builder(
            itemCount: reverselist.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${reverselist[index]}'),
                // subtitle: Text(DateFormat('yyyy-MM-dd \n kk:mm:ss').format(DateTime.now()).toString()),
              );
            },
          )
          :
            Container(child: Text('No Notification'),),
        ),
      ),
    );
  }
}
