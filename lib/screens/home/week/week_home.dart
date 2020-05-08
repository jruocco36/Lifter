import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/day/day_list.dart';
import 'package:Lifter/screens/home/day/day_settings_form.dart';
import 'package:Lifter/screens/home/week/week_settings_form.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekHome extends StatelessWidget {
  final Week week;

  WeekHome({this.week});

  @override
  Widget build(BuildContext context) {
    void _editWeekPanel() {
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
                child: WeekSettingsForm(
                  cycle: week.cycle,
                  weekId: week.weekId,
                ),
              ),
            ),
          );
        },
      );
    }

    void _newDayPanel() {
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
                child: DaySettingsForm(week: week),
              ),
            ),
          );
        },
      );
    }

    // listen for any changes to 'weeks' collection stored DatabaseService
    return StreamBuilder<Week>(
        stream: DatabaseService(uid: week.cycle.program.uid)
            .getWeekData(week.cycle, week.weekId),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Loading();
          // }

          Week weekUpdates;
          snapshot.hasData ? weekUpdates = snapshot.data : weekUpdates = week;
          return StreamProvider<List<Day>>.value(
            initialData: [
              Day(
                dayId: 'loading',
                date: null,
                dayName: null,
                week: null,
                bodyweight: null,
              )
            ],
            value: DatabaseService(uid: week.cycle.program.uid).getDays(week),
            child: Scaffold(
              appBar: AppBar(
                title: Text('${weekUpdates.weekName}'),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    tooltip: 'Edit week',
                    onPressed: () async {
                      _editWeekPanel();
                    },
                  ),
                ],
              ),
              body: DayList(),
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                child: Icon(Icons.add),
                onPressed: () => _newDayPanel(),
              ),
            ),
          );
        });
  }
}
