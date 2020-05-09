import 'package:cached_network_image/cached_network_image.dart';
import 'package:couponcom/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:couponcom/models/coupons_model.dart';
import 'package:couponcom/animated_button.dart';
import 'package:couponcom/bloc/coupon_bloc.dart';

  List colors = [
    Colors.blue,
    Colors.orange,
    Colors.redAccent,
    Colors.green,
    Colors.deepPurpleAccent,
  ];
var defualtImage = new AssetImage('assets/blank.jpg');

class SearchPage extends SearchDelegate {
  final couponBloc = CouponBloc();

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
            child: Row(
              children: <Widget>[
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
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: RichText(
                          text: TextSpan(
                            text: 'DISCOUNT',
                            style: TextStyle(fontSize: 15, letterSpacing: 10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: filterList[index].storeImage,
                                  placeholder: (context, url) => Image(
                                    image: defualtImage,
                                    fit: BoxFit.contain,
                                  ),
                                  errorWidget: (context, url, error) => Image(
                                    image: defualtImage,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
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
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            filterList[index].description,
                            style: TextStyle(
                                color: fontColor,
                                fontSize: ScreenUtil().setSp(45),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: AnimatedButton(
                            maincolor: colors[index % colors.length],
                            onTap: () {
                              couponBloc.getId(filterList[index].id);
                              couponBloc
                                  .getStoreId(filterList[index].storeId + 1);
                              couponBloc.updateData();
                              Clipboard.setData(new ClipboardData(
                                  text: filterList[index].code));
                            },
                            animationDuration:
                                const Duration(milliseconds: 500),
                            initialText: filterList[index].code,
                            finalText: "تم النسخ",
                            iconData: Icons.assignment_turned_in,
                            iconSize: ScreenUtil().setHeight(32),
                            buttonStyle: ButtonStyle(
                              primaryColor: colors[index % colors.length],
                              secondaryColor: Colors.white,
                              elevation: 0.0,
                              initialTextStyle: TextStyle(
                                fontFamily: "Consolas",
                                fontSize: ScreenUtil().setSp(60),
                                fontWeight: FontWeight.bold,
                                color: colors[index % colors.length],
                              ),
                              finalTextStyle: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.bold,
                                color: colors[index % colors.length],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget carouselCoupond(filterList) {
    return Expanded(
      child: ListView.builder(
        itemCount: filterList.length,
        itemBuilder: (BuildContext context, int index) {
          return getStackData(index, filterList);
        },
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text('تعذر العثور'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return searchData(query);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget searchData(query) {
    return Container(
      child: StreamBuilder<List<CouponModel>>(
        stream: couponBloc.couponsListView,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            List<CouponModel> fakList = snapshot.data
                .where((u) => u.storeName.toString().contains(query))
                .toList();
            var filterList = fakList;
            return Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: -10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
                      child: Column(
                        children: <Widget>[
                          carouselCoupond(filterList),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: SpinKitRipple(
                  color: Colors.green.shade600,
                  size: 50.0,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class MyIcon extends StatelessWidget {
  Size size;
  String path;

  MyIcon({this.size, this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CachedNetworkImage(
          width: size.width,
          height: size.height,
          imageUrl: path,
          placeholder: (context, url) => Image(
            image: defualtImage,
            width: size.width,
            height: size.height,
          ),
          errorWidget: (context, url, error) => Image(
            image: defualtImage,
            width: size.width,
            height: size.height,
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Path getOuterPath(double w, double h) {
    Path path = Path();
    path
      ..lineTo(0, h * 0.4)
      ..arcToPoint(Offset(0, h * 0.6), radius: Radius.circular(w * 0.01))
      ..lineTo(0, h)
      ..lineTo(w, h)
      ..lineTo(w, 0)
      ..lineTo(-1, 0);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;
    final paintBorder = Paint()
      ..color = greyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005;
    canvas.drawPath(getOuterPath(w, h), paintBorder);

    var dashWidth = 4;
    var dashSpace = 3;
    double startY = h * 0.15;
    double startX = w * 0.09;
    var max = (h - (2 * startY));
    final paintLine = Paint()
      ..color = greyColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    while (max >= 0) {
      canvas.drawLine(Offset(startX, startY),
          Offset(startX, startY + dashWidth), paintLine);
      final space = (dashSpace + dashWidth);
      startY += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
