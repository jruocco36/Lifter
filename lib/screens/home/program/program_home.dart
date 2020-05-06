import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/screens/home/cycle/cycle_list.dart';
import 'package:Lifter/screens/home/cycle/cycle_settings_form.dart';
import 'package:Lifter/screens/home/program/program_settings_form.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgramHome extends StatelessWidget {
  final Program program;

  ProgramHome({this.program});

  @override
  Widget build(BuildContext context) {
    void _editProgramPanel() {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
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
                child: CycleSettingsForm(program: program),
              ),
            ),
          );
        },
      );
    }

    // listen for any changes to 'cycles' collection stored DatabaseService
    return StreamBuilder<Program>(
        stream:
            DatabaseService(uid: program.uid).getProgramData(program.programId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          Program programUpdates;
          snapshot.hasData
              ? programUpdates = snapshot.data
              : programUpdates = program;
          return StreamProvider<List<Cycle>>.value(
            // initialData: [
            //   Cycle(
            //       cycleId: 'loading',
            //       program: null,
            //       name: null,
            //       startDate: null,
            //       trainingMaxPercent: null)
            // ],
            value: DatabaseService(uid: program.uid).getCycles(program),
            child: Scaffold(
              appBar: AppBar(
                title: Text('${programUpdates.name}'),
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
        });
  }
}
