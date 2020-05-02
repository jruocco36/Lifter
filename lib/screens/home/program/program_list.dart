import 'package:Lifter/models/program.dart';
import 'package:Lifter/screens/home/program/program_tile.dart';
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
    return ListView.builder(
      itemCount: programs.length,
      padding: EdgeInsets.only(top: 10.0),
      itemBuilder: (context, index) {
        return ProgramTile(program: programs[index]);
      },
    );
  }
}
