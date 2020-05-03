import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final bool showBackground;

  Loading({this.showBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (showBackground != false) ? darkGreyColor : null,
      child: Center(
        child: SpinKitChasingDots(
          color: flamingoColor,
          size: 50.0,
        ),
      ),
    );
  }
}
