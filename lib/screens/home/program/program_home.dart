import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/screens/home/cycle/cycle_list.dart';
import 'package:Lifter/screens/home/cycle/cycle_settings_form.dart';
import 'package:Lifter/screens/home/program/program_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgramHome extends StatelessWidget {
  final Program program;

  ProgramHome({this.program});

  @override
  Widget build(BuildContext context) {
    void _editProgramPanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 60.0),
                child: ProgramSettingsForm(
                  programId: program.programId,
                ),
              ),
            ),
          );
        },
      );
    }

    void _newCyclePanel() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 60.0),
                child: CycleSettingsForm(programId: program.programId),
              ),
            ),
          );
        },
      );
    }

    // listen for any changes to 'cycles' collection stored DatabaseService
    return StreamProvider<List<Cycle>>.value(
      value: DatabaseService(uid: program.uid).getCycles(program.programId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${program.name}'),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Edit program',
              onPressed: () async {
                _editProgramPanel();
              },
            ),
          ],
        ),
        body: CycleList(),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.add),
          onPressed: () => _newCyclePanel(),
        ),
      ),
    );
  }
}
