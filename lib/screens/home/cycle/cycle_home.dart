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
                  programId: cycle.programId,
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
    return StreamProvider<List<Week>>.value(
      value: DatabaseService(uid: cycle.uid)
          .getWeeks(cycle),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${cycle.name}'),
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
        body: WeekList(),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.add),
          onPressed: () => _newWeekPanel(),
        ),
      ),
    );
  }
}
