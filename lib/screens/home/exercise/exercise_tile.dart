import 'dart:async';

import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/screens/home/exercise/set_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;

  ExerciseTile({this.exercise});

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  List<TextEditingController> weightControllers = [];

  void dispose() {
    weightControllers.forEach((c) {
      c.dispose();
    });

    super.dispose();
  }

  void startUpdateTimer() {
    Timer(Duration(seconds: 5), timerFire);
  }

  void timerFire() {
    widget.exercise.updateExercise();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService database =
        DatabaseService(uid: widget.exercise.day.week.cycle.program.uid);

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: lightGreyColor,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8.0, 5.0, 12.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      widget.exercise.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: flamingoColor,
                      ),
                    ),
                    if (widget.exercise.exerciseBase.oneRepMax != null)
                      oneRepMax(),
                    if (widget.exercise.trainingMax != null) trainingMax(),
                  ],
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onTap: () {
                        if (widget.exercise.sets == null) {
                          widget.exercise.sets = [];
                        }
                        _editSet();
                      },
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                      child: Icon(
                        Icons.settings,
                        size: 20,
                      ),
                      onTap: () {
                        _editExercisePanel();
                      },
                    ),
                    SizedBox(width: 25),
                    GestureDetector(
                      child: Icon(
                        Icons.delete,
                        size: 20,
                      ),
                      onTap: () async {
                        final delete = await showDialog(
                            context: context,
                            builder: (_) {
                              return DeleteDialog(widget.exercise.name);
                            });
                        if (delete) {
                          database.deleteExercise(widget.exercise);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Set List
          if (widget.exercise.sets != null && widget.exercise.sets.length > 0)
            Container(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(10, 7, 0, 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.exercise.sets.length,
                itemBuilder: (context, index) {
                  if (widget.exercise.sets[index].date == null) {
                    widget.exercise.sets[index].date = widget.exercise.day.date;
                  }
                  if (weightControllers.length < index + 1) {
                    weightControllers.add(TextEditingController());
                  }
                  if (widget.exercise.sets[index].weight != null) {
                    weightControllers[index].text =
                        widget.exercise.sets[index].weight.toInt().toString();
                  }

                  return IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Weight
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Weight',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                controller: weightControllers[index],
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter(
                                    RegExp(r'^\d*\.{0,1}\d*$'),
                                  ),
                                ],
                                onChanged: (val) {
                                  widget.exercise.sets[index].weight =
                                      val != '' ? double.parse(val) : null;
                                  startUpdateTimer();
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  if (widget.exercise.sets[index].reps !=
                                          null &&
                                      widget.exercise.sets[index].weight !=
                                          null) {
                                    widget.exercise.exerciseBase.pr =
                                        widget.exercise.sets[index];
                                  }
                                  widget.exercise.updateExercise();
                                },
                              ),
                            ),
                            VerticalDivider(
                              endIndent: 5,
                              indent: 10,
                            ),

                            // Reps
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Reps',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                initialValue:
                                    widget.exercise.sets[index].reps != null
                                        ? widget.exercise.sets[index].reps
                                            .toString()
                                        : null,
                                // validator: (val) =>
                                //     val.isEmpty ? 'Enter reps' : null,
                                onChanged: (val) => setState(() {
                                  widget.exercise.sets[index].reps =
                                      val != '' ? int.parse(val) : null;
                                  startUpdateTimer();
                                }),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  if (widget.exercise.sets[index].reps !=
                                          null &&
                                      widget.exercise.sets[index].weight !=
                                          null) {
                                    widget.exercise.exerciseBase.pr =
                                        widget.exercise.sets[index];
                                  }
                                  widget.exercise.updateExercise();
                                },
                              ),
                            ),
                            VerticalDivider(
                              endIndent: 5,
                              indent: 10,
                            ),

                            // Rep range
                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Rep range',
                                  hintStyle: TextStyle(fontSize: 14),
                                ),
                                initialValue:
                                    widget.exercise.sets[index].repRange != null
                                        ? widget.exercise.sets[index].repRange
                                        : null,
                                onChanged: (val) => setState(() {
                                  widget.exercise.sets[index].repRange =
                                      val != '' ? val : null;
                                  startUpdateTimer();
                                }),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  widget.exercise.updateExercise();
                                },
                              ),
                            ),

                            // Set notes
                            IconButton(
                              icon: Icon(
                                Icons.note,
                                color:
                                    widget.exercise.sets[index].notes != null &&
                                            widget.exercise.sets[index].notes
                                                    .length >
                                                1
                                        ? Colors.white
                                        : greyTextColor,
                              ),
                              onPressed: () {
                                setNotes(index);
                              },
                            ),

                            // Set settings
                            IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: () {
                                _editSet(index);
                              },
                            ),

                            // Delete set
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                final delete = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return DeleteDialog('set');
                                    });
                                if (delete) {
                                  widget.exercise.exerciseBase
                                      .removePr(widget.exercise.sets[index]);
                                  widget.exercise.sets.removeAt(index);
                                  weightControllers.removeAt(index);
                                  widget.exercise.updateExercise();
                                }
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  } // BUILD

  Widget oneRepMax() {
    return Row(
      children: <Widget>[
        Text(' | ', style: TextStyle(fontSize: 18, color: greyTextColor)),
        Text(
            '1RM: ' + widget.exercise.exerciseBase.oneRepMax.toInt().toString(),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget trainingMax() {
    return Row(
      children: <Widget>[
        Text(' | ', style: TextStyle(fontSize: 18, color: greyTextColor)),
        Text('TM: ' + widget.exercise.trainingMax.toInt().toString(),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }

  void setNotes(int index) {
    // compare new to old, don't send update if no changes
    // this is to prevent un-needed writes to firebase (each set()/update() cost $)
    String oldNotes;

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
        oldNotes = widget.exercise.sets[index].notes;

        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    // autofocus: true,
                    maxLines: null,
                    initialValue: widget.exercise.sets[index].notes ?? null,
                    decoration: InputDecoration(labelText: 'Notes'),
                    onChanged: (val) {
                      if (val == '') {
                        widget.exercise.sets[index].notes = null;
                      } else {
                        widget.exercise.sets[index].notes = val;
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  RaisedButton(
                    color: flamingoColor,
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (widget.exercise.sets[index].notes != oldNotes) {
                        widget.exercise.updateExercise();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _editExercisePanel() {
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
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: ExerciseSettingsForm(exercise: widget.exercise),
            ),
          ),
        );
      },
    );
  }

  void _editSet([int index]) {
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
        // Because this is not in the stateful Build() method, it needs to be
        // wrapped in StatefulBuilder to be able to call it's own setState() function
        return SetSettingsForm(
            exercise: widget.exercise,
            setIndex: index,
            updateExercise: widget.exercise.updateExercise);
      },
    );
  }
}
