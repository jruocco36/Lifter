import 'package:flutter/material.dart';

import './programBox.dart';
import './programData.dart';

class ProgramList extends StatelessWidget {
  final Map<int, String> programs;
  final Function deleteProgram;
  final Function getProgram;

  ProgramList({
    @required this.programs,
    @required this.deleteProgram,
    @required this.getProgram,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          ...(programs.keys).map((program) {
            return ProgramBox(
              programName: programs[program],
              // programKey: program,
              deleteProgram: deleteProgram,
              getProgram: getProgram,
            );
          }).toList()
        ],
      ),
    );
  }
}
