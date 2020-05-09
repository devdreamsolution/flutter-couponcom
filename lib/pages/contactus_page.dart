import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController titleTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController messageTEC = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'الدعم الفني',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(50),
              ),
            ),
            centerTitle: true,
          ),
          backgroundColor: Colors.grey.shade100,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  input(titleTEC, 'العنوان', Icons.person, 1),
                  input(emailTEC, 'الإيميل', Icons.person, 1),
                  input(messageTEC, 'رسالة', Icons.person, 5),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      final Email email = Email(
                        body: emailTEC.text + '\n\n' + messageTEC.text,
                        subject: titleTEC.text,
                        recipients: [''],
                        isHTML: false,
                      );
                      await FlutterEmailSender.send(email);
                    },
                    child: Text(
                      'أرسل الرسالة',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(40),
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  input(TextEditingController textEditingController, String hint,
      IconData iconData, int maxLines) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(iconData),
              ),
              Text(
                hint,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(40),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 10),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextField(
                maxLines: maxLines,
                controller: textEditingController,
                decoration: InputDecoration(
                    hintText: 'ادخل $hint', border: InputBorder.none),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
