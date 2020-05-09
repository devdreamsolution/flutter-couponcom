import 'package:couponcom/pages/main_page.dart';
import 'package:couponcom/pages/contactus_page.dart';
import 'package:couponcom/pages/favorites_page.dart';
import 'package:couponcom/pages/support_page.dart';
import 'package:couponcom/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:couponcom/themes/theme.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Image.asset("assets/icon/Logo.png"),
          ),
          InkWell(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new MainPage(),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "الصفحة الرئيسية",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.home,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new Favorites(),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "المفضلة",
                  style: TextStyle(fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.favorite, 
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              setState(
                () {
                  LaunchReview.launch(
                      androidAppId: "",
                      iOSAppId: "");
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "قيمنا",
                  style: TextStyle(fontWeight: FontWeight.bold, 
                    color: mainColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.star, 
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new AuthScreen(),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "تسجيل الدخول",
                  style: TextStyle(fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.person,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              setState(
                () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new SupportScreen(),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                 ' الدعم الفني',
                  style: TextStyle(fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.question_answer,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
