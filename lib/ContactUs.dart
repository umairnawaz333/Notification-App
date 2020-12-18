import 'package:flutter/material.dart';
import 'package:notification_app/constants.dart';

class ContactUs extends StatefulWidget {

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 32.0),
                  Text(
                    "About Us",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: kPrimaryColor),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/icons/login.png",
                    height: 100
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "OUR TEAM MEMBERS PROFILES",
                    style: TextStyle(color: kPrimaryColor, fontSize: 20),
                  ),
                  SizedBox(height: 20.0),
                  Image(
                    image: AssetImage('assets/images/c.jpeg'),
                    height: 300,
                    width: 350,
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "www.learnhubstudio.com",
                    style: TextStyle(
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}