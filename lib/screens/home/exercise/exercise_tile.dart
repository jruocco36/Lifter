import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// TODO: ability to switch exercise without losing sets
//       ie. accidently added deficit deadlift instead of deadlift, want
//       to switch to deadlift without having to re-enter sets (maybe on long press?)
//       would just have to update day.exercise name and baseId
// TODO: edit/delete exercise base
//       (maybe one menu to do this that can be accessed anywhere)

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

  @override
  Widget build(BuildContext context) {
    DatabaseService database =
        DatabaseService(uid: widget.exercise.day.week.cycle.program.uid);

    return SingleChildScrollView(
      child: Container(
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
                          // setState(() {
                          if (widget.exercise.sets == null) {
                            widget.exercise.sets = [];
                          }
                          _editSet();
                          // });
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
                    print(weightControllers.length);
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
                                        double.parse(val);
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    updateExercise();
                                  },
                                ),
                              ),
                              VerticalDivider(
                                endIndent: 5,
                                indent: 10,
                              ),
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
                                  }),
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    updateExercise();
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
                                  // keyboardType: TextInputType.,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Rep range',
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  initialValue:
                                      widget.exercise.sets[index].repRange !=
                                              null
                                          ? widget.exercise.sets[index].repRange
                                          : null,
                                  onChanged: (val) => setState(() {
                                    widget.exercise.sets[index].repRange = val;
                                  }),
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    updateExercise();
                                  },
                                ),
                              ),

                              // Set notes
                              IconButton(
                                icon: Icon(
                                  Icons.note,
                                  color: widget.exercise.sets[index].notes !=
                                              null &&
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
                                  // widget.exercise.sets.removeAt(index);
                                  // updateExercise();
                                },
                              ),
                              
                              // Delete set
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  widget.exercise.sets.removeAt(index);
                                  weightControllers.removeAt(index);
                                  updateExercise();
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
      ),
    );
  } // BUILD

  void updateExercise() async {
    await DatabaseService(uid: widget.exercise.day.week.cycle.program.uid)
        .updateExercise(widget.exercise.exerciseBase, widget.exercise);
  }

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
                        updateExercise();
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
              child: ExerciseSettingsForm(
                day: widget.exercise.day,
                exerciseId: widget.exercise.exerciseId,
              ),
            ),
          ),
        );
      },
    );
  }

  void _editSet([int index]) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController percentController = TextEditingController();
    TextEditingController additionalWeightController = TextEditingController();

    Set set = index != null ? widget.exercise.sets[index] : Set();
    String setType;
    double percent;
    double additionalWeight;

    if (index != null) {
      if (widget.exercise.sets[index].percent != null) {
        percentController.text =
            (widget.exercise.sets[index].percent * 100).toString();
      }
      if (widget.exercise.sets[index].additionalWeight != null) {
        additionalWeightController.text =
            widget.exercise.sets[index].additionalWeight.toString();
      }
    }

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
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateSheet) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 60.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Set type dropdown
                      DropdownButtonFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Set type'),
                        isDense: true,
                        value: set.setType != null
                            ? setTypeToString(set.setType)
                            : setTypesToStrings()[0],
                        items: setTypesToStrings().map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(setTypeFormatString(type)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setStateSheet(() {
                            // setType = val;
                            set.setType = getSetTypeFromString(val);
                            if (set.setType == SetType.weight) {
                              percentController.text = '';
                              additionalWeightController.text = '';
                              set.percent = null;
                              set.additionalWeight = null;
                            }
                          });
                        },
                      ),
                      SizedBox(height: 20.0),

                      // Percent
                      TextFormField(
                        keyboardType: TextInputType.number,
                        enabled: set.setType == SetType.percentOfMax
                            ? true
                            : set.setType == SetType.percentOfTMax
                                ? true
                                : false,
                        controller: percentController,
                        // initialValue: set.percent != null
                        //     ? (set.percent * 100).toString()
                        //     : null,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Percent', suffix: Text('%')),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                            RegExp(r'^\d*\.{0,1}\d*$'),
                          ),
                        ],
                        onChanged: (val) => setStateSheet(
                            () => set.percent = double.parse(val) / 100),
                        validator: (val) {
                          if (set.setType != SetType.weight &&
                              set.setType != null) {
                            try {
                              double.parse(val);
                              if (val.isEmpty) {
                                return 'Enter percent';
                              } else
                                return null;
                            } catch (e) {
                              return 'Enter percent';
                            }
                          } else if (set.setType != SetType.weight &&
                              set.setType != null &&
                              val.isNotEmpty) {
                            return 'Cannot have percent with a set type of Weight';
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: 20.0),

                      // Additional weight
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: additionalWeightController,
                        enabled: (set.setType == SetType.percentOfMax ||
                            set.setType == SetType.percentOfTMax),
                        // initialValue: set.additionalWeight != null
                        //     ? set.additionalWeight.toString()
                        //     : null,
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Additional weight', suffix: Text('lbs')),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                            RegExp(r'^-?\d*\.{0,1}\d*$'),
                          ),
                        ],
                        onChanged: (val) => setStateSheet(
                            () => set.additionalWeight = double.parse(val)),
                        validator: (val) {
                          if (val.isEmpty) return null;
                          try {
                            double.parse(val);
                            if (val.isEmpty) {
                              return 'Enter additional weight';
                            } else
                              return null;
                          } catch (e) {
                            return 'Enter additional weight';
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
                          if (_formKey.currentState.validate()) {
                            // set.setType = getSetTypeFromString(setType) ??
                            //     set.setType ??
                            //     SetType.weight;
                            // set.percent = percent ?? set.percent ?? null;
                            // set.additionalWeight =
                            //     additionalWeight ?? set.additionalWeight ?? null;
                            Navigator.pop(context);
                            if (index != null) {
                              widget.exercise.sets[index] = set;
                            } else {
                              widget.exercise.sets.add(set);
                            }
                            if (set.setType != SetType.weight) {
                              widget.exercise.calculateSets();
                            }
                            updateExercise();
                            // percentController.dispose();
                            // additionalWeightController.dispose();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
