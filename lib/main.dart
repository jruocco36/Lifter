import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/wrapper.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Lifter',
        theme: ThemeData(
          brightness: Brightness.dark,
          canvasColor: darkGreyColor,
          primaryColor: lightGreyColor,
          primaryColorLight: lightGreyColor,
          accentColor: flamingoColor,
          textTheme: TextTheme(
            display1: TextStyle(
              color: whiteTextColor,
            ),
            body1: TextStyle(
              color: whiteTextColor,
            ),
            body2: TextStyle(
              color: whiteTextColor,
            ),
            button: TextStyle(
              color: whiteTextColor,
            ),
          ),
        ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        home: Wrapper(),
      ),
    );
  }
}
