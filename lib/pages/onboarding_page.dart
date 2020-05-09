import 'package:flutter/material.dart';
import 'package:couponcom/pages/auth_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:couponcom/themes/theme.dart';

class OnboardingScreen extends StatefulWidget {
  final String title;
  OnboardingScreen({this.title});
  @override
  OnboardingScreenState createState() {
    return new OnboardingScreenState();
  }
}

class OnboardingScreenState extends State<OnboardingScreen> {

  final _controller = PageController(viewportFraction: 0.8);
  String _btnTxt = "ستمر";
  int _onboardingIndex = 0;

  void slideOnboarding() {
    _controller.animateToPage(_onboardingIndex + 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.linear);
    setState(() {
      _onboardingIndex ++;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: _onboarding(_controller),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 53.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            switch (_onboardingIndex) {
              case 0:
                slideOnboarding();
                break;
              case 1:
                slideOnboarding();
                setState(() {
                  _btnTxt = 'بدء';
                });
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(
                    )),
                ); 
                break;
              default:
            }
          },
          label: new Text(_btnTxt,
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.0,
            ),
          ),
          backgroundColor: mainColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  }

  Widget _onboarding(PageController controller) {
    final List<String> images = [
      "assets/onboarding1.png",
      "assets/onboarding2.png",
      "assets/onboarding3.png",
    ];

    final List<String> text0 = [
      "!كوبونات",
      "توفير",
      "الإشعارات",
    ];

    final List<String> text1 = [
      "تعبت من الكوبونات المنتهيه معنا تجد اجدد الكوبونات الفعالة",
      "استخدم الكوبونات لتوفيرمبالغ ضخمة مع مرور الوقت",
      "فعل خاصية الإشعارات للحصول على اخر العروض",
    ];

    return ListView(
      children: <Widget>[
        SizedBox(
          height: 600,
          child: PageView(
            physics:new NeverScrollableScrollPhysics(),
            controller: controller,
            children: List.generate(
              3,
              (index) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Container(
                  height: 280,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          child: Container(
                            width: 230,
                            child: new Image.asset(
                              images[index],
                              fit: BoxFit.contain,
                            ),
                          ), 
                        ),
                        SizedBox(
                          height: 45.0,
                        ),
                        new Container(
                          child: new Text(
                            text0[index],
                            style: new TextStyle(
                                color: Color(0xFF4B4B4B),
                                fontSize: 48.0,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 45.0,
                        ),
                        new Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 0, right: 15.0, bottom: 0),
                            child: new Text(
                              text1[index],
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Color(0xFF7D7D7D),
                                  fontSize: 22.0,
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 55.0,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
        ),
        Center(
          child: SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect:  WormEffect(
              spacing:  8.0,
              radius:  12.0,
              dotWidth:  12.0,
              dotHeight:  12.0,
              paintStyle:  PaintingStyle.fill,
              strokeWidth:  1.5,
              dotColor:  Color(0xFFC6F0FF),
              activeDotColor:  mainColor,
            ),
          ),
        ),
      ],
    );
  }
}