import 'package:flutter/material.dart';

import './global.dart';
import './deleteDialog.dart';
import './programHome.dart';

class ProgramBox extends StatelessWidget {
  final String programName;
  final int programKey;
  final Function deleteProgram;

  ProgramBox(this.programName, this.programKey, this.deleteProgram);

  void _delete() {
    deleteProgram(programKey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProgramHome(
                programName: programName,
              ),
            ),
          );
        },
        onLongPress: () => showDialog(
            context: context,
            builder: (_) {
              return DeleteDialog(
                name: programName,
                deleteFunction: _delete,
              );
            }),
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
            style: programBoxTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// class ProgramData {

// }
