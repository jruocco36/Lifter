import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/cycle_settings_form.dart';
import 'package:Lifter/screens/home/week/week_list.dart';
import 'package:Lifter/screens/home/week/week_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CycleHome extends StatelessWidget {
  final Cycle cycle;

  CycleHome({this.cycle});

  @override
  Widget build(BuildContext context) {
    void _editCyclePanel() {
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
                child: CycleSettingsForm(
                  program: cycle.program,
                  cycleId: cycle.cycleId,
                ),
              ),
            ),
          );
        },
      );
    }

    void _newWeekPanel() {
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
                child: WeekSettingsForm(cycle: cycle),
              ),
            ),
          );
        },
      );
    }

    // listen for any changes to 'cycles' collection stored DatabaseService
    return StreamBuilder<Cycle>(
        stream: DatabaseService(uid: cycle.program.uid)
            .getCycleData(cycle.program, cycle.cycleId),
        builder: (context, snapshot) {
          Cycle cycleUpdates;
          snapshot.hasData
              ? cycleUpdates = snapshot.data
              : cycleUpdates = cycle;
          return StreamProvider<List<Week>>.value(
            value: DatabaseService(uid: cycle.program.uid).getWeeks(cycle),
            child: Scaffold(
              appBar: AppBar(
                title: Text('${cycleUpdates.name}'),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    tooltip: 'Edit cycle',
                    onPressed: () async {
                      _editCyclePanel();
                    },
                  ),
                ],
              ),
              body: WeekList(weekDrawer: false),
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                child: Icon(Icons.add),
                onPressed: () => _newWeekPanel(),
              ),
            ),
          );
        });
  }
}
