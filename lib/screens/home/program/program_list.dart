import 'package:Lifter/models/program.dart';
import 'package:Lifter/screens/home/program/program_tile.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:Lifter/shared/startText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgramList extends StatefulWidget {
  @override
  _ProgramListState createState() => _ProgramListState();
}

class _ProgramListState extends State<ProgramList> {
  @override
  Widget build(BuildContext context) {
    // grab current list of programs from DatabaseService through provider
    // provider is StreamProvider from the parent 'Home' widget that is
    // listening to changes to the DatabaseService 'programs' collection stream
    final programs = Provider.of<List<Program>>(context) ?? [];

    // iterates through our list and creates an array of widgets with
    // one widget for each item
    if (programs.length > 0 && programs[0].programId == 'loading')
      return Loading();
    return programs.length < 1
        ? StartText()
        : ListView.builder(
            itemCount: programs.length,
            padding: EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) {
              return ProgramTile(program: programs[index]);
            },
          );
  }
}
