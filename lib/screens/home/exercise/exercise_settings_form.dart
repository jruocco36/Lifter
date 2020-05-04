import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

// TODO: Add exercise for day, not just base exercise. Display on screen
// TODO: suggestions should only show for exercises that are close
//       to [_exerciseName]

class ExerciseSettingsForm extends StatefulWidget {
  final Day day;
  final String exerciseId;

  ExerciseSettingsForm({
    @required this.day,
    this.exerciseId,
  });

  @override
  _ExerciseSettingsFormState createState() => _ExerciseSettingsFormState();
}

class _ExerciseSettingsFormState extends State<ExerciseSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  TextEditingController textEditingController = TextEditingController();
  List<ExerciseBase> exerciseBases = [];
  List<String> exerciseBaseStrings = [];
  String _exerciseName;
  ExerciseType _exerciseType;
  bool newExerciseBase = true;
  Exercise exercise;
  String exerciseBaseId;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Exercise>(
      stream: DatabaseService(uid: user.uid)
          .getExerciseData(widget.day, widget.exerciseId, exerciseBases),
      builder: (context, snapshot) {
        if (snapshot.hasData || widget.exerciseId == null) {
          exercise = snapshot.data;
          if (exercise != null) {
            textEditingController.text = exercise.name;
          }

          // Exercise name (exercise base)
          return StreamBuilder<List<ExerciseBase>>(
              stream: DatabaseService(uid: widget.day.week.cycle.program.uid)
                  .getExerciseBases(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> exerciseStrings = [];
                  exerciseBases = snapshot.data;
                  exerciseBases
                      .forEach((f) => exerciseStrings.add(f.exerciseName));
                  exerciseBaseStrings = exerciseStrings;
                }
                return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        (exercise != null || !newExerciseBase)
                            ? 'Update exercise'
                            : 'Create exercise',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20.0),

                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: textEditingController,
                          decoration: textInputDecoration.copyWith(
                              labelText: 'Exercise name'),
                          onChanged: (val) => setState(() {
                            _exerciseName = val;
                            if (exerciseBaseStrings.contains(_exerciseName)) {
                              exerciseType();
                              exerciseBaseId = getExerciseBaseId(_exerciseName);
                              newExerciseBase = false;
                            } else {
                              newExerciseBase = true;
                              exerciseBaseId = null;
                            }
                          }),
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter exercise name' : null,
                        onSaved: (val) => setState(() {
                          _exerciseName = val;
                          if (exerciseBaseStrings.contains(_exerciseName)) {
                            exerciseType();
                            exerciseBaseId = getExerciseBaseId(_exerciseName);
                            newExerciseBase = false;
                          } else {
                            newExerciseBase = true;
                            exerciseBaseId = null;
                          }
                        }),
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            _exerciseName = suggestion;
                            textEditingController.text = suggestion;
                            exerciseBaseId = getExerciseBaseId(_exerciseName);
                            newExerciseBase = false;
                          });
                          exerciseType();
                        },
                        suggestionsCallback: (pattern) {
                          return exerciseBaseStrings;
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                      ),
                      SizedBox(height: 20.0),

                      // exercise type
                      DropdownButtonFormField(
                        value: _exerciseType != null
                            ? exerciseTypeToString(_exerciseType)
                            : 'Main',
                        items: exercistTypesToStrings().map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text('$type'),
                          );
                        }).toList(),
                        isDense: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Exercise type'),
                        onChanged: (val) => setState(() {
                          _exerciseType = getExerciseTypeFromString(val);
                          newExerciseBase = true;
                        }),
                      ),
                      SizedBox(height: 20.0),

                      RaisedButton(
                        color: flamingoColor,
                        child: Text(
                          exercise != null ? 'Update' : 'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context);
                            _formKey.currentState.save();
                            // if (newExerciseBase) {
                            DatabaseService database = DatabaseService(
                                uid: widget.day.week.cycle.program.uid);
                            // await database.updateExerciseBase(
                            //     exerciseBaseId,
                            //     _exerciseName,
                            //     _exerciseType != null
                            //         ? exerciseTypeToString(_exerciseType)
                            //         : 'Main');
                            // }
                            await database.updateExercise(
                              exerciseBaseId,
                              _exerciseName,
                              _exerciseType != null
                                  ? exerciseTypeToString(_exerciseType)
                                  : 'Main',
                              widget.day,
                              widget.exerciseId,
                              exerciseBaseId,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              });
        } else {
          return Loading();
        }
      },
    );
  }

  String getExerciseBaseId(String exerciseName) {
    String id;
    exerciseBases.forEach((e) => {
          if (e.exerciseName == exerciseName) {id = e.exerciseBaseId}
        });
    return id;
  }

  void exerciseType() {
    if (_exerciseType != null) {
      setState(() => _exerciseType = _exerciseType);
    } else if (exercise != null) {
      setState(() => _exerciseType = exercise.exerciseBase.exerciseType);
    } else if (_exerciseName != null) {
      exerciseBases.forEach((e) {
        if (e.exerciseName == _exerciseName) {
          setState(() => _exerciseType = e.exerciseType);
        }
      });
    }
  }
}
