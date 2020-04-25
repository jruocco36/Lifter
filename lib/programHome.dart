import 'package:flutter/material.dart';

class ProgramHome extends StatelessWidget {
  final String programName;

  ProgramHome({
    @required this.programName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(programName),
    );
  }
}
