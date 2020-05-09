/*
  Signup screen file
*/
import 'package:flutter/material.dart';
import 'package:couponcom/widgets/custom_flat_button.dart';
import 'package:couponcom/pages/main_page.dart';
import 'package:couponcom/themes/theme.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'البريد الإلكتروني',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            ButtonTheme(
              minWidth: 260,
              child: CustomFlatButton(
                title: "إنشاء الحساب",
                fontSize: 23,
                fontWeight: FontWeight.w700,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(
                      )),
                  ); 
                },
                splashColor: mainColor,
                borderColor: mainColor,
                borderWidth: 0,
                color: mainColor,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("هل نسيت كلمة المرور؟",
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            ButtonTheme(
              minWidth: 90,
              child: CustomFlatButton(
                title: "تخطي",
                fontSize: 15,
                fontWeight: FontWeight.w700,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(
                      )),
                  ); 
                },
                splashColor: mainColor,
                borderColor: mainColor,
                borderWidth: 0,
                color: mainColor,
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}