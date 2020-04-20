import 'package:flutter/material.dart';

class StartText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).copyWith().size.height / 3,
      alignment: Alignment.center,
      child: Text(
        'Tap \'+\' to get started.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF888888),
        ),
      ),
    );
  }
}
