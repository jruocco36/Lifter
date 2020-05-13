import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/home/day/day_settings_form.dart';
import 'package:Lifter/screens/home/exercise/exercise_list.dart';
import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/screens/user_settings_drawer.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DayHome extends StatelessWidget {
  final Day day;

  DayHome({this.day});

  @override
  Widget build(BuildContext context) {
    void _editDayPanel() {
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
      Exercise exercise = Exercise(
        day: day,
        exerciseBase: null,
        exerciseId: null,
      );

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
                child: ExerciseSettingsForm(exercise: exercise),
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
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Loading();
        // }

        Day dayUpdates;
        snapshot.hasData ? dayUpdates = snapshot.data : dayUpdates = day;

        return StreamBuilder<List<ExerciseBase>>(
          stream: DatabaseService(uid: day.week.cycle.program.uid)
              .getExerciseBases(),
          builder: (context, snap) {
            // if (snap.connectionState == ConnectionState.waiting) {
            //   return Loading();
            // }

            List<ExerciseBase> bases = [];
            if (snap.hasData) {
              bases = snap.data;
            }

            return StreamProvider<List<Exercise>>.value(
              initialData: [
                Exercise(
                  exerciseId: 'loading',
                  day: null,
                  exerciseBase: null,
                )
              ],
              value: DatabaseService(uid: day.week.cycle.program.uid)
                  .getExercises(day, bases),
              child: Scaffold(
                appBar: AppBar(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('${dayUpdates.dayName}'),
                      Text(
                        '${DateFormat('EEE - MM/dd/yyyy').format(dayUpdates.date)}',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  elevation: 0.0,
                  actions: <Widget>[
                    Builder(
                      builder: (context) => PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        color: darkGreyColor,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'Edit',
                            child: new Text('Edit day'),
                          ),
                          PopupMenuItem(
                            value: 'Settings',
                            child: new Text('Settings'),
                          ),
                        ],
                        onSelected: (val) async {
                          if (val == 'Edit') {
                            _editDayPanel();
                          } else if (val == 'Settings') {
                            Scaffold.of(context).openDrawer();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                body: ExerciseList(),
                floatingActionButton: FloatingActionButton(
                  elevation: 0,
                  child: Icon(Icons.add),
                  onPressed: () => _newExercisePanel(),
                ),
                drawer: UserSettingsDrawer(
                  user: Provider.of<User>(context),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
