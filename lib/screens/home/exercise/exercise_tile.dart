import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// TODO: edit/delete exercise base
//       (maybe one menu to do this that can be accessed anywhere)

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;

  ExerciseTile({this.exercise});

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
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
                          Icons.delete,
                          size: 18,
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
                      SizedBox(
                        width: 25,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.add,
                          size: 18,
                        ),
                        onTap: () {
                          setState(() {
                            if (widget.exercise.sets == null) {
                              widget.exercise.sets = [];
                            }
                            widget.exercise.sets.add(Set());
                            updateExercise();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.exercise.sets != null && widget.exercise.sets.length > 0)
              Container(
                // height: 50,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 7, 0, 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.exercise.sets.length,
                  itemBuilder: (context, index) {
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
                                  initialValue:
                                      widget.exercise.sets[index].weight != null
                                          ? widget.exercise.sets[index].weight
                                              .toInt()
                                              .toString()
                                          : null,
                                  // validator: (val) =>
                                  //     val.isEmpty ? 'Enter weight' : null,
                                  // TODO: may need to extend textinputformatter to avoid
                                  //       removing typed in value if bad character is
                                  //       input (regexp throws formatexception)
                                  inputFormatters: <TextInputFormatter>[
                                    WhitelistingTextInputFormatter(
                                      RegExp(r'^\d*\.{0,1}\d*$'),
                                    ),
                                  ],
                                  onChanged: (val) => setState(() => widget
                                      .exercise
                                      .sets[index]
                                      .weight = double.parse(val)),
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
                                  onChanged: (val) => setState(() => widget
                                      .exercise
                                      .sets[index]
                                      .reps = int.parse(val)),
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
                                  // validator: (val) =>
                                  //     val.isEmpty ? 'Enter weight' : null,
                                  onChanged: (val) => setState(() {
                                    widget.exercise.sets[index].repRange = val;
                                  }),
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    updateExercise();
                                  },
                                ),
                              ),
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
                                  // print('notes for ' +
                                  //     widget.exercise.sets[index].weight
                                  //         .toString());
                                  setNotes(index);
                                },
                              ),
                              // BUG: deleting set removes correct set from firebase, but widget displays
                              //       wrong (removed) set
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  widget.exercise.sets.removeAt(index);
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
  }

  void updateExercise() async {
    await DatabaseService(uid: widget.exercise.day.week.cycle.program.uid)
        .updateExercise(widget.exercise.exerciseBase, widget.exercise);
  }

  Widget oneRepMax() {
    return Row(
      children: <Widget>[
        Text(' | ', style: TextStyle(fontSize: 18, color: greyTextColor)),
        Text('1RM: ' + widget.exercise.exerciseBase.oneRepMax.toString(),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget trainingMax() {
    return Row(
      children: <Widget>[
        Text(' | ', style: TextStyle(fontSize: 18, color: greyTextColor)),
        Text('Training Max: ' + widget.exercise.trainingMax.toString(),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }

  void setNotes(int index) {
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
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    maxLines: null,
                    initialValue: widget.exercise.sets[index].notes != null
                        ? widget.exercise.sets[index].notes
                        : null,
                    decoration: InputDecoration(labelText: 'Notes'),
                    onChanged: (val) {
                      widget.exercise.sets[index].notes = val;
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
                      if (widget.exercise.sets[index].notes != null) {
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
}
