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

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email, password;

  SharedPref sharedPref = SharedPref();

  @override
  initState(){
    super.initState();
    // check_email();
  }

  void check_email() async{
    try{
      String e = await sharedPref.reademail("email");
      print(e);
      if(e != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Notifi()));
      }
    }
    catch(error){
      print(error);
    }
  }

  void signIn() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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

    UserCredential result;
    try{
      await Firebase.initializeApp();
      result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }
    catch(error){
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

    Navigator.of(context).pop();
    User user = result.user;
    if (user.emailVerified) {
      print(user);
      sharedPref.save("email", user.email);
      sharedPref.save("username", user.displayName);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Notifi()), (Route<dynamic> route) => false);

    }
    else{
      Fluttertoast.showToast(
          msg: "Verified you email by click on Link... that sent to your email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0
      );
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
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SignUpScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
