import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms/sms.dart';
import 'package:notification_app/constants.dart';

class massage extends StatefulWidget {
  final List<Contact> contact;

  massage({Key key, @required this.contact}) : super(key: key);

  @override
  _MessageState createState() => new _MessageState(contact);
}

class _MessageState extends State<massage> {
  List<String> recipients = [];
  List<Contact> contact;
  String m="";

  _MessageState(this.contact);

  @override
  void initState() {
    super.initState();
  }

  void _sendSMS() {
    for (var i = 0; i < contact.length; i++) {
      SmsSender sender = new SmsSender();
      String address = contact[i].phones.toList()[0].value;

      SmsMessage message = new SmsMessage(address, m);
      sender.sendSms(message);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent to " + contact[i].displayName + " !");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
        }
      });
    }
    Fluttertoast.showToast(
        msg: "Successfully Sent!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Send Message"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.0,),
            Container(
              padding: EdgeInsets.all(15.0),
                child: new TextField(minLines: 6,maxLines: 10,style: TextStyle(fontSize: 18.0),
              onChanged: (text) {
                m = text;
              },
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: kPrimaryColor,width: 1.0)),
                labelText: 'Message',
              ),
            )),
            SizedBox(height: 22.0,),
            SizedBox.fromSize(
              size: Size(56, 56), // button width and height
              child: ClipOval(
                child: Material(
                  color: kPrimaryColor, // button color
                  child: InkWell(
                    splashColor: NotificationColor, // splash color
                    onTap: () {
                      if(m != ""){
                        _sendSMS();
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
      ),
    );
  }
}
