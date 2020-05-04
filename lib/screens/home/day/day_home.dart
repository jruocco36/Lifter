import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/day/day_list.dart';
import 'package:Lifter/screens/home/day/day_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayHome extends StatelessWidget {
  final Day day;

  DayHome({this.day});

  @override
  Widget build(BuildContext context) {
    void _editDayPanel() {
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
                child: DaySettingsForm(
                  week: day.week,
                  dayId: day.dayId,
                ),
              ),
            ),
          );
        },
      );
    }

    void _newExercisePanel() {
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
                child: DaySettingsForm(week: day.week),
              ),
            ),
          );
        },
      );
    }

    // listen for any changes to 'days' collection stored DatabaseService
    return StreamBuilder<Day>(
        stream: DatabaseService(uid: day.week.cycle.program.uid)
            .getDayData(day.week, day.dayId),
        builder: (context, snapshot) {
          Day dayUpdates;
          snapshot.hasData ? dayUpdates = snapshot.data : dayUpdates = day;
          return StreamProvider<List<Exercise>>.value(
            initialData: [
              Exercise(
                  exerciseId: 'loading',
                  day: null,
                  exerciseBase: null,
                  name: null,
                  sets: null)
            ],
            value: DatabaseService(uid: day.week.cycle.program.uid)
                .getExercises(day),
            child: Scaffold(
              appBar: AppBar(
                title: Text('${dayUpdates.dayName}'),
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings),
                    tooltip: 'Edit day',
                    onPressed: () async {
                      _editDayPanel();
                    },
                  ),
                ],
              ),
              // body: ExerciseList(),
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                child: Icon(Icons.add),
                onPressed: () => _newExercisePanel(),
              ),
            ),
          );
        });
  }
}
