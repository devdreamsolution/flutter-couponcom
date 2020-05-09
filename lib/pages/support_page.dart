/* 
  Support Screen page
*/
import 'package:couponcom/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:couponcom/pages/support_form_page.dart';
import 'package:couponcom/themes/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SupportScreen extends StatefulWidget {
 
  @override
  SupportScreenState createState() {
    return new SupportScreenState();
  }
}

class SupportScreenState extends State<SupportScreen> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text("الدعم الفني",
              style: TextStyle(
                color: Colors.black,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: new PreferredSize(
              preferredSize: new Size(250.0, 60.0),
              child: new Container(
                width: 250.0,
                child: new TabBar(
                  indicatorColor: mainColor,
                  indicatorWeight: 4.0,
                  tabs: [
                    new Container(
                      child: new Tab(
                        child: Text("شكوى أو اقتراح",
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
          endDrawer: Container(
            width: ScreenUtil().setWidth(1080) * 0.7,
            child: Drawer(
              child: Menu(),
            ),
          ),
          body: TabBarView(
            children: [
              SupportFormScreen(),
            ],
          ),
        ),
      ),
    );

  }
}

