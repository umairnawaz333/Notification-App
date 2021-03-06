import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/Screens/Login/components/background.dart';
import 'package:notification_app/Screens/Signup/signup_screen.dart';
import 'package:notification_app/components/already_have_an_account_acheck.dart';
import 'package:notification_app/components/rounded_button.dart';
import 'package:notification_app/components/rounded_input_field.dart';
import 'package:notification_app/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notification_app/notification_page.dart';
import 'package:notification_app/constants.dart';
import 'package:notification_app/SharedPref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notification_app/user_manager.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email, password, token;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  SharedPref sharedPref = SharedPref();

  @override
  initState() {
    super.initState();
  }

  void signIn() async {
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
                SizedBox(
                  width: 25.0,
                ),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );

    UserCredential result;
    try {
      await Firebase.initializeApp();
      result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User user = result.user;
      if (user != null) {
        if (user.emailVerified) {
          print(user);

          _firebaseMessaging.getToken().then((t) {
            token = t;
            print(token);
            FirebaseFirestore _firestore = FirebaseFirestore.instance;
            DocumentReference ref =
            _firestore.collection('users').doc(user.email);
            ref.update({
              'token': token
            });
            Navigator.pop(dialogContext);
            sharedPref.save("email", user.email);
            sharedPref.save("username", user.displayName);
            // if(user.email == "umair.nawaz1997@gmail.com"){
            //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            //       user_manager()), (Route<dynamic> route) => false);
            // }
            // else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Notifi()),
                    (Route<dynamic> route) => false);
            // }
          });
        }
        else {
          Navigator.pop(dialogContext);
          Fluttertoast.showToast(
              msg: "Verified you email by click on Link... that sent to your email",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0);
        }
      }
    } catch (error) {
      Navigator.pop(dialogContext);
      Fluttertoast.showToast(
          msg: error.code,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/icons/login.png",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                signIn();
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SignUpScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
