import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:notification_app/constants.dart';


class user_manager extends StatefulWidget {
  @override
  _usernamagerState createState() => _usernamagerState();

}


class _usernamagerState extends State<user_manager> {
  List userlist = [];
  List isChecked = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
  }

  // isCheckedvlaue(){
  //   for(int i=0;i<userlist.length;i++){
  //     isChecked.add(false);
  //   }
  // }

  getuser() async {

    try {
      await Firebase.initializeApp();
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference ref = _firestore.collection("users");
      QuerySnapshot userRef = await ref.get();
      userlist = userRef.docs.toList();
      print(userlist);
      // isCheckedvlaue();
      setState(() {

      });
    }
    catch (error) {
      Fluttertoast.showToast(
          msg: error.code,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0
      );
    }
  }

  updateusertype(int index,String type)async{
    var data = {
      "UID": userlist[index].get("UID"),
      "name": userlist[index].get("name"),
      "type" : type,
    };


    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Row(
              children: [
                new CircularProgressIndicator(),
                SizedBox(width: 25.0,),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );



    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference ref = _firestore.collection("users").doc(userlist[index].id);
    ref.set(data).then((v) {
      Navigator.pop(dialogContext);
      Fluttertoast.showToast(
          msg: "Update User Type",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_LEFT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });

    getuser();
  }

  Widget userdatabox(int index) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: kPrimaryColor,),
              borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                      width: double.infinity,
                      child: Text(userlist[index].get("name"), textAlign: TextAlign.left, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kPrimaryColor),)),
                  Container(
                      margin: EdgeInsets.only(left: 15.0),
                      width: double.infinity,
                      child: Text(userlist[index].id, textAlign: TextAlign.left, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                  child: Text(userlist[index].get("type"), textAlign: TextAlign.left, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // isChecked[index] = !isChecked[index];
                    // print(userlist[index].get("type"));
                    if(userlist[index].get("type") == "user"){
                        updateusertype(index, "manager");
                    }
                    else{
                      updateusertype(index, "user");
                    }
                  });
                  print(isChecked);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: CustomSwitchButton(
                      backgroundColor: Colors.blueGrey[200],
                      unCheckedColor: Colors.red,
                      animationDuration: Duration(milliseconds: 300),
                      checkedColor: Colors.green,
                      checked: (userlist[index].get("type") == "user") ? false : true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("All Users"),
        ),
        body: Center(
          child: (userlist.length > 0)
              ? ListView.builder(
            itemCount: userlist.length,
            itemBuilder: (context, index) {
              return userdatabox(
                  index
              );
            },
          )
              :
          Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

}