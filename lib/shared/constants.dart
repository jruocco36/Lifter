import 'package:flutter/material.dart';

const Color darkGreyColor = Color(0xFF212125);
const Color lightGreyColor = Color(0xFF484850);
const Color primaryDarkColor = Color(0xFF000000);
const Color flamingoColor = Color(0xFFd37c7c);
const Color lightFlamingoColor = Color(0xFFffacab);
const Color darkFlamingoColor = Color(0xFF9f4e50);
const Color whiteTextColor = Color(0xFFffffff);
const Color blackTextColor = Color(0xFF000000);
const Color greyTextColor = Color(0xFF888888);

TextStyle programBoxTextStyle = new TextStyle(
    fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold);

TextStyle dialogHintStyle = new TextStyle(
  color: greyTextColor,
);

TextStyle dialogTextStyle = new TextStyle(
  color: whiteTextColor,
);

const textInputDecoration = InputDecoration(
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: greyTextColor,
      width: 2.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: flamingoColor,
      width: 2.0,
    ),
  ),
);

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}
