import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedButton extends StatefulWidget {
  Color greenColor = Color.fromRGBO(93, 181, 0, 1);
  final String initialText, finalText;
  final ButtonStyle buttonStyle;
  final IconData iconData;
  final double iconSize;
  final Duration animationDuration;
  final Function onTap;
  final Color maincolor;

  AnimatedButton(
      {this.maincolor,
      this.initialText,
      this.finalText,
      this.iconData,
      this.iconSize,
      this.animationDuration,
      this.buttonStyle,
      this.onTap});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController _controller;
  ButtonState _currentState;
  Duration _smallDuration;
  Animation<double> _scaleFinalTextAnimation;

  @override
  void initState() {
    super.initState();
    _currentState = ButtonState.SHOW_ONLY_TEXT;
    _smallDuration = Duration(
        milliseconds: (widget.animationDuration.inMilliseconds * 0.2).round());
    _controller =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _controller.addListener(() {
      double _controllerValue = _controller.value;
      if (_controllerValue < 0.2) {
        setState(() {
          _currentState = ButtonState.SHOW_ONLY_ICON;
        });
      } else if (_controllerValue > 0.8) {
        setState(() {
          _currentState = ButtonState.SHOW_TEXT_ICON;
        });
      }
    });

    _controller.addStatusListener((currentStatus) {
      if (currentStatus == AnimationStatus.completed) {
        return widget.onTap();
      }
    });

    _scaleFinalTextAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Material(
      elevation: widget.buttonStyle.elevation,
      child: InkWell(
          splashColor: Colors.lightGreen.shade100,
          highlightColor: Colors.transparent,
          onTap: () {
            _controller.forward();
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(1920) * 0.025,
                child: Center(
                  child: Text(
                    "إضغط للنسخ",
                    style: TextStyle(
                        fontFamily: "Almarai",
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                    color: widget.maincolor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
              ),
              buttonStack()
            ],
          )),
    );
  }

  Widget buttonStack() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.025) * ScreenUtil().setHeight(1920),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          border: Border.all(
            color: widget.maincolor,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned.directional(
              textDirection: TextDirection.ltr,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: AnimatedContainer(
                  duration: _smallDuration,
                  height: ScreenUtil().setHeight(100),
                  width: ScreenUtil().setWidth(230),
                  child: Center(
                    heightFactor: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: AnimatedSize(
                          vsync: this,
                          curve: Curves.easeIn,
                          duration: _smallDuration,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              (_currentState == ButtonState.SHOW_ONLY_ICON ||
                                      _currentState ==
                                          ButtonState.SHOW_TEXT_ICON)
                                  ? Icon(
                                      widget.iconData,
                                      size: widget.iconSize,
                                      color: widget.buttonStyle.primaryColor,
                                    )
                                  : Container(),
                              SizedBox(
                                width:
                                    _currentState == ButtonState.SHOW_TEXT_ICON
                                        ? ScreenUtil().setWidth(25)
                                        : ScreenUtil().setWidth(0),
                              ),
                              getTextWidget()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextWidget() {
    if (_currentState == ButtonState.SHOW_ONLY_TEXT) {
      return Text(
        widget.initialText,
        textAlign: TextAlign.center,
        style: widget.buttonStyle.initialTextStyle,
      );
    } else if (_currentState == ButtonState.SHOW_ONLY_ICON) {
      return Container();
    } else {
      return ScaleTransition(
        scale: _scaleFinalTextAnimation,
        child: Text(
          widget.finalText,
          style: widget.buttonStyle.finalTextStyle,
        ),
      );
    }
  }
}

class ButtonStyle {
  final TextStyle initialTextStyle, finalTextStyle;
  final Color primaryColor, secondaryColor;
  final double elevation, borderRadius;

  ButtonStyle(
      {this.primaryColor,
      this.secondaryColor,
      this.initialTextStyle,
      this.finalTextStyle,
      this.elevation,
      this.borderRadius});
}

enum ButtonState { SHOW_ONLY_TEXT, SHOW_ONLY_ICON, SHOW_TEXT_ICON }
