import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: darkGreyColor,
      margin: EdgeInsets.all(10),
      child: Center(
        child: SpinKitChasingDots(
          color: flamingoColor,
          size: 50.0,
        ),
      ),
    );
  }
}
