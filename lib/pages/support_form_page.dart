/* 
  Support form screen file
*/
import 'package:flutter/material.dart';
import 'package:couponcom/widgets/custom_flat_button.dart';
import 'package:couponcom/pages/main_page.dart';
import 'package:couponcom/themes/theme.dart';

class SupportFormScreen extends StatelessWidget {
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
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('اذا كان لديك اقتراح أو شكوى على كوبون لايعمل يرجى',
                  style: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text('إبلاغنا وسنعمل جاهدين على مساعدتك',
                  style: TextStyle(
                    color: Color(0xFF7D7D7D),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            ButtonTheme(
              minWidth: 260,
              child: CustomFlatButton(
                title: 'إرسال',
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
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}