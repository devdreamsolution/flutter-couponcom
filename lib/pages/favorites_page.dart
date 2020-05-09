import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:couponcom/models/coupons_model.dart';
import 'package:couponcom/animated_button.dart';
import 'package:couponcom/bloc/coupon_bloc.dart';
import 'package:couponcom/db.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:couponcom/widgets/menu.dart';
import 'package:url_launcher/url_launcher.dart';

class Favorites extends StatefulWidget {
  static String item;

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<String> favorites;
  List colors = [
    Color(0xFF00B4F6),
    Color(0xFFFB6D00),
    Color(0xFF02DE93),
  ];
  var defualtImage = new AssetImage('assets/blank.jpg');
  Color fontColor = Color.fromRGBO(83, 83, 83, 1);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    print('HERE');
    favorites = await DBProvider.db.getAllFavorites();
    setState(() {
      print('HERE 2');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Map userMap = jsonDecode(favorites[0]);
    //CouponModel user = CouponModel.fromJson(userMap);
    //print(user.code);
    return Material(
      color: Colors.blue,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'المفضلة',
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
          backgroundColor: Colors.grey.shade100,
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: ListView(
              children: listItems(),
            ),
          ),
        ),
      ),
    );
  }

  listItems() {
    List<Widget> list = new List();
    CouponModel filterList;
    if (favorites != null)
      for (int i = 0; i < favorites.length; i++) {
        filterList = new CouponModel();
        Map coupon = jsonDecode(favorites[i]);
        filterList = CouponModel.fromJson(coupon);
        list.add(
          Center(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                height: ScreenUtil().setHeight(550),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade300, blurRadius: 10),
                  ],
                ),
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
                                      _launchURL(filterList.storeLink);
                                    },
                                    icon: Icon(
                                      Icons.shopping_cart,
                                    ),
                                    color: Colors.black,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      Map decodeOptions = filterList.toJson();
                                      String favoriteCoupon = jsonEncode(
                                          CouponModel.fromJson(decodeOptions));
                                      await DBProvider.db
                                          .deleteEntry(favoriteCoupon);
                                      favorites.remove(favoriteCoupon);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                    ),
                                    color: Colors.redAccent,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Share.share(filterList.storeName +
                                          "\n" +
                                          filterList.description +
                                          "\nCode: " +
                                          filterList.code +
                                          "\n" +
                                          filterList.storeLink);
                                    },
                                    icon: Icon(
                                      Icons.share,
                                    ),
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DottedBorder(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.contain,
                                              imageUrl: filterList.storeImage,
                                              placeholder: (context, url) =>
                                                  Image(
                                                image: defualtImage,
                                                fit: BoxFit.contain,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image(
                                                image: defualtImage,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            dashPattern: [5, 7],
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
                                          filterList.description,
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
                                        child: Text(filterList.code,
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
                                                  color: colors[i % colors.length],
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
                                              color: colors[i % colors.length],
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
                            //       child: AnimatedButton(
                            //         maincolor: colors[i % colors.length],
                            //         onTap: () {
                            //           CouponBloc couponBloc = CouponBloc();
                            //           couponBloc.getId(filterList.id);
                            //           couponBloc
                            //               .getStoreId(filterList.storeId + 1);
                            //           couponBloc.updateData();
                            //           Clipboard.setData(new ClipboardData(
                            //               text: filterList.code));
                            //         },
                            //         animationDuration:
                            //             const Duration(milliseconds: 500),
                            //         initialText: filterList.code,
                            //         finalText: "تم النسخ",
                            //         iconData: Icons.assignment_turned_in,
                            //         iconSize: ScreenUtil().setHeight(32),
                            //         buttonStyle: ButtonStyle(
                            //           primaryColor: colors[i % colors.length],
                            //           secondaryColor: Colors.white,
                            //           elevation: 0.0,
                            //           initialTextStyle: TextStyle(
                            //             fontFamily: "Consolas",
                            //             fontSize: ScreenUtil().setSp(60),
                            //             fontWeight: FontWeight.bold,
                            //             color: colors[i % colors.length],
                            //           ),
                            //           finalTextStyle: TextStyle(
                            //             fontSize: ScreenUtil().setSp(30),
                            //             fontWeight: FontWeight.bold,
                            //             color: colors[i % colors.length],
                            //           ),
                            //         ),
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
                            color: colors[i % colors.length],
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
          ),
        );
      }
    return list;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
