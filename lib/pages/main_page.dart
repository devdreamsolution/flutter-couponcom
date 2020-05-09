import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:couponcom/models/coupons_model.dart';
import 'package:couponcom/bloc/coupon_bloc.dart';
import 'package:couponcom/db.dart';
import 'package:couponcom/pages/search_page.dart';
import 'package:couponcom/themes/theme.dart';
import 'package:couponcom/widgets/menu.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

var defualtImage = new AssetImage('assets/blank.jpg');

class _MainPageState extends State<MainPage> {
  List colors = [
    Color(0xFF00B4F6),
    Color(0xFFFB6D00),
    Color(0xFF02DE93),
  ];
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: '_rateMyApp',
    minDays: 0,
    minLaunches: 3,
    remindDays: 0,
    remindLaunches: 3,
    googlePlayIdentifier: '',
    appStoreIdentifier: '',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final couponBloc = CouponBloc();
  List<CouponModel> fakList = List();
  List<CouponModel> filterList = List();
  List<CouponModel> searchListBloc = List();
  List<CouponModel> coupons = List();
  String query = "";

  final _controller = TextEditingController();
  int selected = 5000;

  @override
  void dispose() {
    _controller.dispose();
    couponBloc.ondispose();
    super.dispose();
  }

  @override
  void initState() {
    // _firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(sound: true, alert: true, badge: true),
    // );
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    super.initState();
    rateMyApp.init().then(
      (_) {
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showStarRateDialog(
            context,
            title: 'قيم تطبيق كوبون كوم',
            // The dialog title.
            message: 'هل أعجبك تطبيق كوبون كوم؟ قيمنا',
            // The dialog message.
            onRatingChanged: (stars) {
              // Triggered when the user updates the star rating.
              return [
                // Return a list of actions (that will be shown at the bottom of the dialog).
                FlatButton(
                  child: Text(
                    'حسناً',
                    style: TextStyle(fontFamily: "Roboto-Regular"),
                  ),
                  onPressed: () async {
                    if (stars != null) {
                      // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                      // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                      await rateMyApp
                          .callEvent(RateMyAppEventType.rateButtonPressed);
                      Navigator.pop<RateMyAppDialogButton>(
                          context, RateMyAppDialogButton.rate);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ];
            },
            ignoreIOS: false,
            // Set to false if you want to show the native Apple app rating dialog on iOS.
            dialogStyle: DialogStyle(
              // Custom dialog styles.
              titleAlign: TextAlign.center,
              titleStyle: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: ScreenUtil().setSp(55),
              ),
              messageAlign: TextAlign.center,
              messageStyle: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: ScreenUtil().setSp(40),
              ),
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: StarRatingOptions(
              starsSize: 35,
            ), // Custom star bar rating options.
          );
        }
      },
    );

    initDB();
  }

  initDB() async {
    await DBProvider.db.initDB();
  }

  Widget containerBox(
      String sname, int indexSelected, String image, folderList) {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            selected = indexSelected;
            query = sname;
          },
        );
      },
      child: FittedBox(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(
                  0.0,
                  1.0,
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(top: 10, bottom: 5, right: 15),
          child: Container(
            width: ScreenUtil().setWidth(130),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: (selected != null && selected == indexSelected)
                    ? greenColor
                    : Colors.grey.shade400,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Image(
                      image: defualtImage,
                      width: ScreenUtil().setWidth(130),
                    ),
                    errorWidget: (context, url, error) => Image(
                      image: defualtImage,
                      width: ScreenUtil().setWidth(130),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFolderView(filterList, fakList) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        StreamBuilder<List<CouponModel>>(
          stream: couponBloc.couponsListView,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              List<CouponModel> folderList = snapshot.data;
              Map<Object, CouponModel> mp = {};
              for (var item in folderList) {
                mp[item.storeName] = item;
              }
              List<CouponModel> filteredList = mp.values.toList();
              return Container(
                height: ScreenUtil().setHeight(200),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: ListView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 33.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      containerBox(
                          "",
                          5000,
                          "https://www.couponcom.xyz/assets/images/all.jpg",
                          filterList),
                      for (int i = 0; i < filteredList.length; i++)
                        containerBox(filteredList[i].storeName, i,
                            filteredList[i].storeImage, folderList),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SpinKitRipple(
                  color: Colors.green.shade600,
                  size: 50.0,
                ),
              );
            }
          },
        )
      ],
    );
  }

  Text buildRattingStars(int rating) {
    String stars = "";
    for (int i = 0; i < rating; i++) {
      stars += '⭐';
    }
    stars.trim();
    return Text(stars);
  }

  Widget carouselCoupond(filterList) {
    final _controller = ScrollController();

    return Expanded(
      child: Container(
        child: FadingEdgeScrollView.fromScrollView(
          gradientFractionOnStart: 0.03,
          gradientFractionOnEnd: 0,
          child: ListView.builder(
            controller: _controller,
            itemCount: filterList.length,
            itemBuilder: (BuildContext context, int index) {
              return getStackData(index, filterList);
            },
          ),
        ),
      ),
    );
  }

  Future<bool> showCoupons(context, String url, String image) {}

  Widget getStackData(index, filterList) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 10),
              ]),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            IconButton(
                              onPressed: () {
                                _launchURL(filterList[index].storeLink);
                              },
                              icon: Icon(
                                Icons.shopping_cart,
                              ),
                              color: Colors.black,
                            ),
                            Container(
                              child: FutureBuilder<bool>(
                                  future: checkIfFavorite(filterList[index]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.data == false) {
                                      return IconButton(
                                          onPressed: () {
                                            setFavorite(filterList[index]);
                                          },
                                          icon: Icon(Icons.favorite_border),
                                          color: Colors.black);
                                    } else {
                                      return IconButton(
                                        onPressed: () {
                                          setFavorite(filterList[index]);
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                        ),
                                        color: Colors.redAccent,
                                      );
                                    }
                                  }),
                            ),
                            IconButton(
                              onPressed: () {
                                Share.share(filterList[index].storeName +
                                    "\n" +
                                    filterList[index].description +
                                    "\nCode: " +
                                    filterList[index].code +
                                    "\n" +
                                    filterList[index].storeLink);
                              },
                              icon: Icon(
                                Icons.share,
                              ),
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: DottedBorder(
                                      color: colors[index % colors.length],
                                      child: CachedNetworkImage(
                                        fit: BoxFit.contain,
                                        imageUrl: filterList[index].storeImage,
                                        placeholder: (context, url) => Image(
                                          image: defualtImage,
                                          fit: BoxFit.contain,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image(
                                          image: defualtImage,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      dashPattern: [9, 7],
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    filterList[index].description,
                                    style: TextStyle(
                                        color: fontColor,
                                        fontSize: ScreenUtil().setSp(45),
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                  ' الإستخدام: يستخدم اكثر من مره',
                                    style: TextStyle(
                                        color: fontColor,
                                        fontSize: ScreenUtil().setSp(45),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ), 
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(30),
                          child: Container(
                            width: 220,
                            height: 30,
                            child: Stack(
                              children: <Widget>[
                                new Align(
                                  alignment: Alignment.center,
                                  child: Text(filterList[index].code,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                new Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 75,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("تم النسخ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Container(
                                          child: Icon(Icons.check,
                                            color: colors[index % colors.length],
                                            size: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(14),
                                            color: Colors.white,
                                          ),
                                          height: 14,
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: colors[index % colors.length],
                                        ),
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          dashPattern: [9, 7],
                          strokeWidth: 2,
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width * 0.35,
                      //     child: Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 5),
                      //       child: Material(
                      //         child: InkWell(
                      //             splashColor: Colors.lightGreen.shade100,
                      //             highlightColor: Colors.transparent,
                      //             onTap: () {
                      //               couponBloc.getId(filterList[index].id);
                      //               couponBloc.getStoreId(
                      //                   filterList[index].storeId + 1);
                      //               couponBloc.updateData();
                      //               Clipboard.setData(new ClipboardData(
                      //                   text: filterList[index].code));

                      //               showCoupons(
                      //                   context,
                      //                   filterList[index].storeLink,
                      //                   filterList[index].storeImage);
                      //               setState(() {
                      //                 filterList[index].code = "تم النسخ";
                      //               });
                      //             },
                      //             child: Stack(
                      //               children: <Widget>[
                      //                 Container(
                      //                   height: ScreenUtil().setHeight(1920) *
                      //                       0.025,
                      //                   child: Center(
                      //                     child: Text(
                      //                       "إضغط للنسخ",
                      //                       style: TextStyle(
                      //                           fontFamily: "Almarai",
                      //                           color: Colors.white,
                      //                           fontSize:
                      //                               ScreenUtil().setSp(28),
                      //                           fontWeight: FontWeight.bold),
                      //                     ),
                      //                   ),
                      //                   decoration: BoxDecoration(
                      //                       color:
                      //                           colors[index % colors.length],
                      //                       borderRadius: BorderRadius.only(
                      //                           topLeft: Radius.circular(10),
                      //                           topRight: Radius.circular(10))),
                      //                 ),
                      //                 Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(top: 0.025) *
                      //                           ScreenUtil().setHeight(1920),
                      //                   child: Container(
                      //                     decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.only(
                      //                           bottomLeft: Radius.circular(10),
                      //                           bottomRight:
                      //                               Radius.circular(10)),
                      //                       border: Border.all(
                      //                         color:
                      //                             colors[index % colors.length],
                      //                       ),
                      //                     ),
                      //                     child: Stack(
                      //                       children: <Widget>[
                      //                         Positioned.directional(
                      //                           textDirection:
                      //                               TextDirection.ltr,
                      //                           child: Container(
                      //                             height: double.infinity,
                      //                             width: double.infinity,
                      //                             child: Center(
                      //                               heightFactor: 1,
                      //                               child: Padding(
                      //                                 padding:
                      //                                     const EdgeInsets.all(
                      //                                         5.0),
                      //                                 child: FittedBox(
                      //                                   fit: BoxFit.contain,
                      //                                   child: Row(
                      //                                     mainAxisSize:
                      //                                         MainAxisSize.min,
                      //                                     children: <Widget>[
                      //                                       Padding(
                      //                                         padding:
                      //                                             const EdgeInsets
                      //                                                 .all(3.0),
                      //                                         child: Text(
                      //                                           filterList[
                      //                                                   index]
                      //                                               .code,
                      //                                           textAlign:
                      //                                               TextAlign
                      //                                                   .center,
                      //                                           style: TextStyle(
                      //                                               color: colors[
                      //                                                   index %
                      //                                                       colors
                      //                                                           .length],
                      //                                               fontFamily: filterList[index]
                      //                                                           .code ==
                      //                                                       "تم النسخ"
                      //                                                   ? "Almarai"
                      //                                                   : "Almarai",
                      //                                               fontWeight:
                      //                                                   FontWeight
                      //                                                       .bold,
                      //                                               fontSize: ScreenUtil()
                      //                                                   .setSp(
                      //                                                       50)),
                      //                                         ),
                      //                                       ),
                      //                                     ],
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             )),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: double.infinity,
                    width: 50,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildError(BuildContext context, FlutterErrorDetails error) {
    return Scaffold(
      body: Center(
        child: Text(
          "حدث خطأ",
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('كوبون كوم',
          style: TextStyle(
            fontSize: 21,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: Container(
        width: ScreenUtil().setWidth(1080) * 0.7,
        child: Drawer(
          child: Menu(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<List<CouponModel>>(
            stream: couponBloc.filterCouponsListView(query),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return buildError(context, errorDetails);
              };
              if (snapshot.data != null) {
                fakList = snapshot.data;
                filterList = fakList;
                return SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: ScreenUtil().setWidth(16),
                        top: ScreenUtil().setHeight(64),
                        right: ScreenUtil().setWidth(16),
                        child: Container(
                          height: ScreenUtil().setHeight(1080),
                          child: Column(
                            children: <Widget>[
                              // SizedBox(
                              //   height: ScreenUtil().setHeight(20),
                              // ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: ScreenUtil().setHeight(100),
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade300,
                                                    blurRadius: 10),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: TextField(
                                                controller: _controller,
                                                decoration: InputDecoration(
                                                    suffixIcon: Icon(Icons.search,
                                                      color: Colors.black,
                                                    ),
                                                    hintStyle: TextStyle(
                                                        color: Colors.black38,
                                                        fontSize: ScreenUtil()
                                                            .setSp(40),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    hintText: "البحث",
                                                    border: InputBorder.none),
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      showSearch(
                                                        context: context,
                                                        delegate: SearchPage(),
                                                      );
                                                    },
                                                  );
                                                },
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: ScreenUtil().setHeight(200),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              _buildFolderView(filterList, fakList),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        top: ScreenUtil().setHeight(400),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              NotificationListener<
                                  OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowGlow();
                                },
                                child: carouselCoupond(filterList),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }

              return Container(
                child: SpinKitRipple(
                  color: Colors.green.shade600,
                  size: 50.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> checkIfFavorite(CouponModel couponModel) async {
    Map decodeOptions = couponModel.toJson();
    String favoriteCoupon = jsonEncode(CouponModel.fromJson(decodeOptions));
    int flag = await DBProvider.db.check(favoriteCoupon);
    if (flag != 0)
      return true;
    else
      return false;
  }

  setFavorite(CouponModel couponModel) async {
    bool flag = await checkIfFavorite(couponModel);

    Map decodeOptions = couponModel.toJson();
    String favoriteCoupon = jsonEncode(CouponModel.fromJson(decodeOptions));
    if (!flag)
      await DBProvider.db.newEntry(favoriteCoupon);
    else
      await DBProvider.db.deleteEntry(favoriteCoupon);
    setState(() {});
  }
}
