import 'package:flutter/material.dart';
import 'package:couponcom/pages/signin_page.dart';
import 'package:couponcom/pages/signup_page.dart';
import 'package:couponcom/themes/theme.dart';


class AuthScreen extends StatefulWidget {
 
  @override
  AuthScreenState createState() {
    return new AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: new PreferredSize(
              preferredSize: new Size(250.0, 100.0),
              child: new Container(
                width: 250.0,
                child: new TabBar(
                  indicatorColor: mainColor,
                  indicatorWeight: 4.0,
                  tabs: [
                    new Container(
                      child: new Tab(
                        child: Text("تسجيل جديد",
                          style: TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      child: new Tab(
                        child: Text("تسجيل الدخول",
                          style: TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SignupScreen(),
              SigninScreen(),
            ],
          ),
        ),
      ),
    );

  }
}

