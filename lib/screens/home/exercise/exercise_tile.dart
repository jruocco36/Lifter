import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
// import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  ExerciseTile({this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        color: lightGreyColor,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(exercise.name),
          // subtitle: Text('${DateFormat('EEE - MM/dd/yyyy').format(exercise.date)}'),
          // leading: ,
          trailing: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            color: darkGreyColor,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'Edit',
                child: new Text('Edit'),
              ),
              PopupMenuItem(
                value: 'Delete',
                child: new Text('Delete'),
              ),
            ],
            onSelected: (val) async {
              if (val == 'Edit') {
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
                          child: ExerciseSettingsForm(
                            day: exercise.day,
                            exerciseId: exercise.exerciseId,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (val == 'Delete') {
                final delete = await showDialog(
                    context: context,
                    builder: (_) {
                      return DeleteDialog(exercise.name);
                    });
                if (delete) {
                  // DatabaseService(uid: exercise.day.week.cycle.program.uid)
                  //     .deleteExercise(exercise);
                }
              }
            },
          ),
          onTap: () {
            // print(exercise.exerciseName);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ExerciseHome(exercise: exercise),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
