import 'package:flutter/material.dart';

import './program.dart';

class ProgramList extends StatelessWidget {
  final Map<int, String> programs;
  final Function deleteProgram;

  ProgramList({
    @required this.programs,
    @required this.deleteProgram,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          ...(programs.keys).map((program) {
            return Program(programs[program], program, deleteProgram);
          }).toList()
        ],
      ),
    );
  }
}
