import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_app/ContactUs.dart';
import 'package:notification_app/Screens/Login/login_screen.dart';
import 'package:notification_app/constants.dart';
import 'package:notification_app/notification_center.dart';
import 'package:notification_app/sms.dart';
import 'package:notification_app/user_manager.dart';
import 'SharedPref.dart';
import 'package:intl/intl.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:notification_app/PermissionService.dart';

class Notifi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotifiState();
  }
}

class _NotifiState extends State<Notifi> with SingleTickerProviderStateMixin{
  String username, type, email;
  SharedPref sharedPref = SharedPref();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<String> loaddata = [];
  List<String> reverselist = [];
  List<String> loaddate = [];
  List<String> reversedate = [];
  bool isadmin = false;

  bool dialVisible = true;

  @override
  void initState() {
    loadSharedPrefs();
    getMessage();
    super.initState();
    permissionAcessPhone();
  }

  loadSharedPrefs() async {
    try {
      username = await sharedPref.reademail("username");
      type = await sharedPref.reademail("type");
      email = await sharedPref.reademail("email");
      List<String> mydata = await sharedPref.read("user");
      List<String> mydate = await sharedPref.read("date");
      setState(() {
        loaddata = mydata;
        loaddate = mydate;
        reverselist = loaddata.reversed.toList();
        reversedate = loaddate.reversed.toList();
      });
    } catch (Excepetion) {
      print("Error to read data...");
    }

    if (type == "manager") {
      username +=" (Manager";
      isadmin = true;
      setState(() {});
    } else {
      username +=" (User";
      isadmin = false;
      setState(() {});
    }

    if(email == "umair.nawaz1997@gmail.com"){
      username += " - Admin)";
    }
    else{
      username += ")";
    }
    setState(() {

    });
  }

  Future permissionAcessPhone() {
    PermissionService().requestPermission(onPermissionDenied: () {
      print('Permission has been denied');
    });
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() {
        loaddata.add(message["data"]["mytext"]);
        loaddate.add(DateFormat('yyyy-MM-dd \t kk:mm:ss')
            .format(DateTime.now())
            .toString());
        reverselist = loaddata.reversed.toList();
        reversedate = loaddate.reversed.toList();
        sharedPref.save("user", loaddata);
        sharedPref.save("date", loaddate);
      });
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() {
        _firebaseMessaging.onTokenRefresh;
        loaddata.add(message["data"]["mytext"]);
        loaddate.add(DateFormat('yyyy-MM-dd \t kk:mm:ss')
            .format(DateTime.now())
            .toString());
        reverselist = loaddata.reversed.toList();
        reversedate = loaddate.reversed.toList();
        sharedPref.save("user", loaddata);
        sharedPref.save("date", loaddate);
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() {
        _firebaseMessaging.onTokenRefresh;
        loaddata.add(message["data"]["mytext"]);
        loaddate.add(DateFormat('yyyy-MM-dd \t kk:mm:ss')
            .format(DateTime.now())
            .toString());
        reverselist = loaddata.reversed.toList();
        reversedate = loaddate.reversed.toList();
        sharedPref.save("user", loaddata);
        sharedPref.save("date", loaddate);
      });
    });
  }

  Widget notificationbox(String text, String date) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        width: 2.0,
        color: kPrimaryColor,
      )),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              width: double.infinity,
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Row(
                children: [
                  Text(
                    "Notification: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                      child: Text(
                    date,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white),
                  )),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                ClipboardManager.copyToClipBoard(text);
                Fluttertoast.showToast(
                    msg: "Copied",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 10.0);
              },
              child: Text(
                text,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  username + ', Are you sure you want to exit?',
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                actions: <Widget>[
                  FlatButton(
                    color: kPrimaryColor,
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    color: kPrimaryColor,
                    child: Text('Yes, exit'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Notifi App'))
              ],
            ),
            backgroundColor: kPrimaryColor,
            actions: <Widget>[
              (email == "umair.nawaz1997@gmail.com")?
              IconButton(
                icon: Icon(
                  Icons.people_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => user_manager()));
                },
              )
              : Container(),

              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ContactUs()));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                              username + ', Are you sure you want to Logout?',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          actions: <Widget>[
                            FlatButton(
                              color: kPrimaryColor,
                              child: Text('No'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            FlatButton(
                              color: kPrimaryColor,
                              child: Text('Yes, Logout'),
                              onPressed: () {
                                sharedPref.remove("email");
                                sharedPref.remove("username");
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        );
                      });
                },
              )
            ],
          ),
          body: Center(
            child: (reverselist.length > 0)
                ? ListView.builder(
                    itemCount: reverselist.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: notificationbox(
                            '${reverselist[index]}', '${reversedate[index]}'),
                      );
                    },
                  )
                : Container(
                    child: Text('No Notification'),
                  ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _getFloatingbutton(),
        ),
      ),
    );
  }

  Widget _getFloatingbutton() {
    if (isadmin) {
      //Init Floating Action Bubble
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: dialVisible,
        curve: Curves.easeInCubic,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Options',
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
            // SpeedDialChild(
            //   child: Icon(Icons.people_rounded),
            //   backgroundColor: kPrimaryColor,
            //   label: 'Show Users',
            //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => sms())),
            // ),
          SpeedDialChild(
              child: Icon(Icons.send_rounded),
              backgroundColor: kPrimaryColor,
              label: 'Message',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => sms())),
          ),
          SpeedDialChild(
            child: Icon(Icons.notification_important_rounded),
            backgroundColor: kPrimaryColor,
            label: 'Notification',

            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => notification_center())),
          ),
        ],
      );
    }
  }
}
