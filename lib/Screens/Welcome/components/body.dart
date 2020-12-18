import 'package:flutter/material.dart';
import 'package:notification_app/Screens/Login/login_screen.dart';
import 'package:notification_app/Screens/Signup/signup_screen.dart';
import 'package:notification_app/Screens/Welcome/components/background.dart';
import 'package:notification_app/components/rounded_button.dart';
import 'package:notification_app/constants.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to Notifi App",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23.0),
            ),
            SizedBox(height: size.height * 0.15),
            Image.asset(
              "assets/icons/chat.png",
              height: size.height * 0.45,
            ),
          ],
        ),
      ),
    );
  }
}
