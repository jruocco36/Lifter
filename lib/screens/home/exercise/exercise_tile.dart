import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/screens/home/exercise/exercise_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// TODO: add sets
// TODO: delete sets + exercises
// TODO: edit exercise base (maybe one menu to do this that can be accessed anywhere)

class ExerciseTile extends StatefulWidget {
  final Exercise exercise;

  ExerciseTile({this.exercise});

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  int _sets = 0;
  // List<Set> sets = [];

  @override
  Widget build(BuildContext context) {
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
                      Text(widget.exercise.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: flamingoColor,
                          )),
                      if (widget.exercise.exerciseBase.oneRepMax != null)
                        oneRepMax(),
                      if (widget.exercise.trainingMax != null) trainingMax(),
                    ],
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.add,
                      size: 18,
                    ),
                    onTap: () {
                      print('add set');
                      setState(() {
                        _sets += 1;
                        widget.exercise.sets.add(Set());
                      });
                    },
                  ),
                ],
              ),
            ),
            if (widget.exercise.sets.length > 0)
              Container(
                // height: 50,
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(5, 7, 0, 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.exercise.sets.length,
                  itemBuilder: (context, index) {
                    return IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Text('new set'),
                              Flexible(
                                child: TextFormField(
                                  // autofocus: true,
                                  // initialValue:,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Weight',
                                    hintStyle: TextStyle(fontSize: 14),
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     color: greyTextColor,
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     color: flamingoColor,
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter weight' : null,
                                  onChanged: (val) => setState(() => widget
                                      .exercise
                                      .sets[index]
                                      .weight = double.parse(val)),
                                  onEditingComplete: () {
                                    print(widget.exercise.sets.toString());
                                  },
                                ),
                              ),
                              VerticalDivider(
                                endIndent: 5,
                                indent: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  // autofocus: true,
                                  // initialValue:,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Reps',
                                    hintStyle: TextStyle(fontSize: 14),
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     color: greyTextColor,
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     color: flamingoColor,
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter weight' : null,
                                  onChanged: (val) => setState(() => widget
                                      .exercise
                                      .sets[index]
                                      .reps = int.parse(val)),
                                  onEditingComplete: () {
                                    print(widget.exercise.sets.toString());
                                  },
                                ),
                              ),
                              VerticalDivider(
                                endIndent: 5,
                                indent: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  // autofocus: true,
                                  // initialValue:,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Rep range',
                                    hintStyle: TextStyle(fontSize: 14),
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     color: greyTextColor,
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     color: flamingoColor,
                                    //     width: 1.0,
                                    //   ),
                                    // ),
                                  ),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter weight' : null,
                                  // onChanged: (val) => setState(() => _dayName = val),
                                ),
                              ),
                              //  VerticalDivider(
                              //   endIndent: 5,
                              //   indent: 10,
                              // ),
                              // Flexible(
                              //   child: TextFormField(
                              //     // autofocus: true,
                              //     // initialValue:,
                              //     decoration: InputDecoration(
                              //       isDense: true,
                              //       hintText: 'Notes',
                              //       hintStyle: TextStyle(fontSize: 14),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: greyTextColor,
                              //           width: 1.0,
                              //         ),
                              //       ),
                              //       focusedBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(
                              //           color: flamingoColor,
                              //           width: 1.0,
                              //         ),
                              //       ),
                              //     ),
                              //     validator: (val) =>
                              //         val.isEmpty ? 'Enter weight' : null,
                              //     // onChanged: (val) => setState(() => _dayName = val),
                              //   ),
                              // ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  print('delete set ' + index.toString());
                                  setState(() {
                                    widget.exercise.sets.removeAt(index);
                                  });
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
            // if (widget.exercise.sets != null)
            //   ...widget.exercise.sets.map((map) {
            //     return Row(
            //       mainAxisSize: MainAxisSize.max,
            //       children: <Widget>[
            //         Text(
            //             'Set: ${map.weight} - ${map.reps} - ${map.repRange} - ${map.percent}')
            //       ],
            //     );
            //   }).toList(),
          ],
        ),
      ),
    );
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
}
