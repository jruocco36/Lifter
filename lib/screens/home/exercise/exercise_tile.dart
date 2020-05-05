import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:Lifter/shared/startText.dart';
import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  ExerciseTile({this.exercise});

  @override
  Widget build(BuildContext context) {
    return exercise.name != 'loading'
        ? Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: lightGreyColor,
                  width: double.infinity,
                  padding: const EdgeInsets.all(7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(exercise.name,
                              style: TextStyle(
                                fontSize: 18,
                                color: flamingoColor,
                              )),
                          if (exercise.exerciseBase.oneRepMax != null)
                            oneRepMax(),
                          if (exercise.trainingMax != null) trainingMax(),
                        ],
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.add,
                          size: 18,
                        ),
                        onTap: () {
                          print('add set');
                        },
                      ),
                    ],
                  ),
                ),
                if (exercise.sets != null)
                  ...exercise.sets.map((map) {
                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                            'Set: ${map.weight} - ${map.reps} - ${map.repRange} - ${map.percent}')
                      ],
                    );
                  }).toList(),
              ],
            ),
          )
        : Loading();
  }

  Widget oneRepMax() {
    return Row(
      children: <Widget>[
        Text(' | ', style: TextStyle(fontSize: 18)),
        Text('1RM: ' + exercise.exerciseBase.oneRepMax.toString(),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget trainingMax() {
    return Row(
      children: <Widget>[
        Text(' | ', style: TextStyle(fontSize: 18)),
        Text('Training Max: ' + exercise.trainingMax.toString(),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
