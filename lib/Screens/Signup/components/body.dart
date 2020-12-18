import 'package:flutter/material.dart';
import 'package:notification_app/Screens/Login/login_screen.dart';
import 'package:notification_app/Screens/Signup/components/background.dart';
import 'package:notification_app/components/already_have_an_account_acheck.dart';
import 'package:notification_app/components/rounded_button.dart';
import 'package:notification_app/components/rounded_input_field.dart';
import 'package:notification_app/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notification_app/constants.dart';
import 'package:notification_app/notification_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {

  @override
  _signuppageState createState() => _signuppageState();
}


class _signuppageState extends State<Body> {

  String username,email,password;

  void _validateRegisterInput() async {
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

    try{
      await Firebase.initializeApp();
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      User user = result.user;
      await user.updateProfile(displayName: username);
      user.sendEmailVerification();
      print(user);
      Navigator.pop(dialogContext);
      if(user != null){
        showDialog(
            context: context,
            builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("Verify your Email by click on Link, that sent to your email",
                  style: TextStyle(color: kPrimaryColor),),
          actions: <Widget>[
            new FlatButton(
              color: kPrimaryColor,
              child: new Text("OK",style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                        transitionDuration: Duration(seconds: 2),
                        pageBuilder: (_, __, ___) => LoginScreen()
                    )
                );
              },
            ),
          ],
        );
            },
        );
      }
      else{
        Fluttertoast.showToast(
            msg: "Something wrrong in information...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    catch(error){
      Navigator.pop(dialogContext);
        Fluttertoast.showToast(
            msg: error.code,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
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
              "assets/icons/signup.png",
              height: size.height * 0.30,
            ),
            RoundedInputField(
              hintText: "Username",
              onChanged: (value) {
                username = value;
              },
            ),
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
              text: "SIGNUP",
              press: () {
                _validateRegisterInput();
              },
            ),
            SizedBox(height: size.height * 0.02),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
