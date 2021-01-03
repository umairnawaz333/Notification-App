import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_app/constants.dart';


class notification_center extends StatefulWidget {
  @override
  _notification_centerState createState() => _notification_centerState();
}


class _notification_centerState extends State<notification_center> {

  List tokens = [];
  String title="",body="";
  String notification_server_key= 'key=AAAA_0pFSnU:APA91bG0HiDMP7HbHgIeWturZ8eEiB1H8sLSx6lBCaipfFs7jjNOuuzvzUL10rDtBufpZcaBxaz_fXyoyLNOhlmBjv5sB0kKqA-zZZAJAlprV3cYuf2UXG01uBBCDy8MZi4tmO1_ZwIQ';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettokens();
  }

  gettokens()async{
    await Firebase.initializeApp();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference ref = _firestore.collection("users");
    QuerySnapshot querySnapshot = await ref.get();
    querySnapshot.docs.forEach((document) {
      tokens.add(document.get('token'));
    });
    print("tokens: "+tokens.toString());
  }

  send_notification() async {
    var noti = {'title' :title , 'body': body};
    var data = {'click_action': "FLUTTER_NOTIFICATION_CLICK",'mytext': title+"\n"+body};
    var n = { "registration_ids": tokens, "priority":"high", "notification":noti, "data" : data };
    final http.Response response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String,String>{
        'Content-Type': "application/json",
        'Authorization': notification_server_key
      },
      body: jsonEncode(n),
    );
    if (response.statusCode == 200) {
      print(response);
      return response.body;
    } else {
      print("error response 400");
      throw Exception('Failed to call api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Notification Center"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(15.0),
                  child: new TextField(style: TextStyle(fontSize: 18.0),
                    onChanged: (text) {
                      title = text;
                    },
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: kPrimaryColor,width: 1.0)),
                      labelText: 'Title',
                    ),
                  )),
              SizedBox(height: 20.0,),
              Container(
                  padding: EdgeInsets.all(15.0),
                  child: new TextField(minLines: 6,maxLines: 10,style: TextStyle(fontSize: 18.0),
                    onChanged: (text) {
                      body = text;
                    },
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: kPrimaryColor,width: 1.0)),
                      labelText: 'Body',
                    ),
                  )),
              SizedBox(height: 25.0,),
              SizedBox.fromSize(
                size: Size(56, 56), // button width and height
                child: ClipOval(
                  child: Material(
                    color: kPrimaryColor, // button color
                    child: InkWell(
                      splashColor: NotificationColor, // splash color
                      onTap: () {
                        if(body != "" && title != ""){
                          send_notification();
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "Empty TextField!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.deepOrange,
                              textColor: Colors.white,
                              fontSize: 15.0);
                        }
                      }, // button pressed
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Icon(Icons.send_rounded,color: Colors.white,),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

}