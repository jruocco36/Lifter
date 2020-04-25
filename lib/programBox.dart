import 'package:flutter/material.dart';

import './programHome.dart';

class ProgramBox extends StatelessWidget {
  final String programName;
  final int programKey;
  final Function deleteProgram;

  ProgramBox(this.programName, this.programKey, this.deleteProgram);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => ProgramHome(programName: programName),
        onLongPress: () => deleteProgram(programKey),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Color(0xFF484850),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Text(
            this.programName,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// class ProgramData { 
  
// }