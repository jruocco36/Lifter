import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ExerciseSettingsForm extends StatefulWidget {
  final Exercise exercise;

  ExerciseSettingsForm({@required this.exercise});

  @override
  _ExerciseSettingsFormState createState() => _ExerciseSettingsFormState();
}

class _ExerciseSettingsFormState extends State<ExerciseSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController oneRepMaxController = TextEditingController();
  TextEditingController trainingMaxController = TextEditingController();
  List<ExerciseBase> exerciseBases = [];
  List<String> exerciseBaseStrings = [];
  String _exerciseName;
  ExerciseType _exerciseType;
  String _oneRepMax;
  String _trainingMax;

  @override
  void initState() {
    if (widget.exercise.exerciseId != null) {
      exerciseNameController.text = widget.exercise.name;
      oneRepMaxController.text = widget.exercise.exerciseBase.oneRepMax != null
          ? widget.exercise.exerciseBase.oneRepMax.toString()
          : null;
      trainingMaxController.text = widget.exercise.trainingMax != null
          ? widget.exercise.trainingMax.toString()
          : null;
    }
    super.initState();
  }

  @override
  void dispose() {
    exerciseNameController.dispose();
    oneRepMaxController.dispose();
    trainingMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExerciseBase>>(
      stream: DatabaseService(uid: widget.exercise.day.week.cycle.program.uid)
          .getExerciseBases(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && widget.exercise.exerciseId != null) {
          return Loading();
        } else if (snapshot.hasData) {
          List<String> exerciseStrings = [];
          exerciseBases = snapshot.data;
          exerciseBases.forEach((f) => exerciseStrings.add(f.exerciseName));
          exerciseBaseStrings = exerciseStrings;
        }

        return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                (widget.exercise.exerciseId != null)
                    ? 'Update exercise'
                    : 'Create exercise',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),

              // TODO: ability to switch exercise without losing sets
              // ie. accidently added deficit deadlift instead of deadlift, want
              // to switch to deadlift without having to re-enter sets
              // (maybe on long press?) would just have to update day.exercise name
              // and baseId
              // Exercise name
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  enabled: widget.exercise.exerciseId == null,
                  autofocus: true,
                  controller: exerciseNameController,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Exercise name'),
                  onChanged: (val) => setState(() {
                    _exerciseName = val;
                    if (exerciseBaseStrings.contains(_exerciseName)) {
                      widget.exercise.exerciseBase =
                          getExerciseBase(_exerciseName);
                      _exerciseType = null;
                      if (widget.exercise.exerciseBase.oneRepMax != null) {
                        oneRepMaxController.text =
                            widget.exercise.exerciseBase.oneRepMax.toString();
                      }
                    } else {
                      oneRepMaxController.text = '';
                    }
                  }),
                ),
                validator: (val) => val.isEmpty ? 'Enter exercise name' : null,
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _exerciseName = suggestion;
                    exerciseNameController.text = suggestion;
                    if (exerciseBaseStrings.contains(_exerciseName)) {
                      widget.exercise.exerciseBase =
                          getExerciseBase(_exerciseName);
                      _exerciseType = null;
                      if (widget.exercise.exerciseBase.oneRepMax != null) {
                        oneRepMaxController.text =
                            widget.exercise.exerciseBase.oneRepMax.toString();
                      }
                    }
                  });
                },
                suggestionsCallback: (pattern) {
                  return exerciseBaseStrings.where((base) {
                    RegExp test = RegExp(r'.*' + pattern.toUpperCase() + '.*');
                    return test.hasMatch(base.toUpperCase());
                  });
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
              ),
              SizedBox(height: 20.0),

              // Exercise type
              InputDecorator(
                decoration:
                    textInputDecoration.copyWith(labelText: 'Exercise type'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _exerciseType != null
                        ? exerciseTypeToString(_exerciseType)
                        : widget.exercise.exerciseBase != null
                            ? exerciseTypeToString(
                                widget.exercise.exerciseBase.exerciseType)
                            : 'Main',
                    items: exerciseTypesToStrings().map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text('$type'),
                      );
                    }).toList(),
                    isDense: true,
                    hint: Text('Exercise type'),
                    onChanged: (val) => setState(() {
                      _exerciseType = getExerciseTypeFromString(val);
                    }),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // 1RM
              TextFormField(
                controller: oneRepMaxController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration:
                    textInputDecoration.copyWith(labelText: 'One Rep Max'),
                validator: (val) {
                  if (val.isEmpty) return null;
                  try {
                    double weight = double.parse(val);
                    if (weight < 0)
                      return 'Not a valid one rep max';
                    else
                      return null;
                  } on FormatException {
                    return 'Not a valid one rep max';
                  }
                },
                onChanged: (val) => setState(() => _oneRepMax = val),
              ),
              SizedBox(height: 20.0),

              // TM
              TextFormField(
                controller: trainingMaxController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration:
                    textInputDecoration.copyWith(labelText: 'Training Max'),
                validator: (val) {
                  if (val.isEmpty) return null;
                  if (_oneRepMax == null &&
                      widget.exercise.exerciseBase.oneRepMax == null) {
                        return 'Can\'t set training max without one rep max';
                      }
                  try {
                    double weight = double.parse(val);
                    if (weight < 0)
                      return 'Not a valid training max';
                    else
                      return null;
                  } on FormatException {
                    return 'Not a valid training max';
                  }
                },
                onChanged: (val) => setState(() => _trainingMax = val),
              ),
              SizedBox(height: 20.0),

              RaisedButton(
                color: flamingoColor,
                child: Text(
                  widget.exercise.exerciseId != null ? 'Update' : 'Create',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context);
                    DatabaseService database = DatabaseService(
                        uid: widget.exercise.day.week.cycle.program.uid);

                    ExerciseBase exBase = ExerciseBase(
                      exerciseBaseId: widget.exercise.exerciseBase != null
                          ? widget.exercise.exerciseBase.exerciseBaseId
                          : null,
                      exerciseName: _exerciseName ??
                          widget.exercise.exerciseBase.exerciseName,
                      exerciseType: _exerciseType != null
                          ? _exerciseType
                          : widget.exercise.exerciseBase != null
                              ? widget.exercise.exerciseBase.exerciseType
                              : ExerciseType.Main,
                      oneRepMax: _oneRepMax != null
                          ? double.parse(_oneRepMax)
                          : widget.exercise.exerciseBase != null
                              ? widget.exercise.exerciseBase.oneRepMax
                              : null,
                      cycleTMs: widget.exercise.exerciseBase != null
                          ? widget.exercise.exerciseBase.cycleTMs ?? {}
                          : {},
                      prHistory: widget.exercise.exerciseBase != null
                          ? widget.exercise.exerciseBase.prHistory ?? []
                          : [],
                    );

                    Exercise ex = Exercise(
                      day: widget.exercise.day,
                      exerciseBase: exBase,
                      exerciseId: widget.exercise.exerciseId,
                    );

                    if (_trainingMax != null) {
                      if (_trainingMax == '') {
                        ex.updateTM(null);
                      } else {
                        ex.updateTM(double.parse(_trainingMax));
                      }
                    }

                    await database.updateExercise(exBase, ex);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ExerciseBase getExerciseBase(String name) {
    for (ExerciseBase base in exerciseBases) {
      if (base.exerciseName == name) {
        // exerciseBase = base;
        return base;
      }
    }

    return null;
  }
}
