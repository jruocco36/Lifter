import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';

class StartText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      alignment: Alignment.center,
      child: Text(
        'Tap + to get started.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: greyTextColor,
        ),
      ),
    );
  }
}
