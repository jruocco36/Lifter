import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/exercise/exercise_tile.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:Lifter/shared/startText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: design exercise display
// Exercises should be displayed in Row() for each set
// with weight, reps, target rep range, notes, etc.s

class ExerciseList extends StatefulWidget {
  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    // grab current list of exercises from DatabaseService through provider
    // provider is StreamProvider from the parent 'Home' widget that is
    // listening to changes to the DatabaseService 'exercises' collection stream
    final exercises = Provider.of<List<Exercise>>(context) ?? [];

    // iterates through our list and creates an array of widgets with
    // one widget for each item
    if (exercises.length > 0 && exercises[0].exerciseId == 'loading') return Loading();
    return exercises.length < 1
        ? StartText()
        : ListView.builder(
            itemCount: exercises.length,
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            padding: EdgeInsets.only(top: 20.0, bottom: 100),
            itemBuilder: (context, index) {
              return ExerciseTile(exercise: exercises[index]);
            },
          );
  }
}
