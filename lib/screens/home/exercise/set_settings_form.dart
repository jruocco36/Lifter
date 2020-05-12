import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetSettingsForm extends StatefulWidget {
  final Exercise exercise;
  final int setIndex;
  final Function updateExercise;

  SetSettingsForm({this.exercise, this.setIndex, this.updateExercise});

  @override
  _SetSettingsFormState createState() => _SetSettingsFormState();
}

class _SetSettingsFormState extends State<SetSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  Set set;
  TextEditingController percentController = TextEditingController();
  TextEditingController additionalWeightController = TextEditingController();

  @override
  void initState() {
    set =
        widget.setIndex != null ? widget.exercise.sets[widget.setIndex] : Set();
    if (widget.setIndex != null) {
      if (set.percent != null) {
        percentController.text = (set.percent * 100).toString();
      }
      if (set.additionalWeight != null) {
        additionalWeightController.text = set.additionalWeight.toString();
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    percentController.dispose();
    additionalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Set type dropdown
                DropdownButtonFormField(
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Set type'),
                  isDense: true,
                  value: widget.setIndex != null
                      ? set.setType != null
                          ? setTypeToString(set.setType)
                          : setTypesToStrings()[0]
                      : setTypesToStrings()[0],
                  items: setTypesToStrings().map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(setTypeFormatString(type)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
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
                      : set.setType == SetType.percentOfTMax ? true : false,
                  controller: percentController,
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Percent', suffix: Text('%')),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(
                      RegExp(r'^\d*\.{0,1}\d*$'),
                    ),
                  ],
                  onChanged: (val) =>
                      setState(() => set.percent = double.parse(val) / 100),
                  validator: (val) {
                    if (set.setType != SetType.weight && set.setType != null) {
                      try {
                        double.parse(val);
                        if (val.isEmpty) {
                          return 'Enter percent';
                        } else if (widget.exercise.exerciseBase.oneRepMax ==
                            null) {
                          return 'No one rep max found';
                        } else if (widget.exercise.trainingMax == null) {
                          return 'No training max found';
                        }
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
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Additional weight', suffix: Text('lbs')),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(
                      RegExp(r'^-?\d*\.{0,1}\d*$'),
                    ),
                  ],
                  onChanged: (val) => setState(() => set.additionalWeight =
                      val != '' ? double.parse(val) : null),
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
                      Navigator.pop(context);
                      if (widget.setIndex != null) {
                        widget.exercise.sets[widget.setIndex] = set;
                      } else {
                        widget.exercise.sets.add(set);
                      }
                      if (set.setType != SetType.weight) {
                        widget.exercise.calculateSets();
                      }
                      widget.updateExercise(widget.exercise);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget setSettingsForm(
//   Exercise exercise, int setIndex, Function updateExercise) {
//   final _formKey = GlobalKey<FormState>();
//   Set set = setIndex != null ? exercise.sets[setIndex] : Set();
//   TextEditingController percentController = TextEditingController();
//   TextEditingController additionalWeightController = TextEditingController();

//   return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setStateSheet) {
//     return SingleChildScrollView(
//       child: Container(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: <Widget>[
//                 // Set type dropdown
//                 DropdownButtonFormField(
//                   decoration:
//                       textInputDecoration.copyWith(labelText: 'Set type'),
//                   isDense: true,
//                   value: set.setType != null
//                       ? setTypeToString(set.setType)
//                       : setTypesToStrings()[0],
//                   items: setTypesToStrings().map((type) {
//                     return DropdownMenuItem(
//                       value: type,
//                       child: Text(setTypeFormatString(type)),
//                     );
//                   }).toList(),
//                   onChanged: (val) {
//                     setStateSheet(() {
//                       // setType = val;
//                       set.setType = getSetTypeFromString(val);
//                       if (set.setType == SetType.weight) {
//                         percentController.text = '';
//                         additionalWeightController.text = '';
//                         set.percent = null;
//                         set.additionalWeight = null;
//                       }
//                     });
//                   },
//                 ),
//                 SizedBox(height: 20.0),

//                 // Percent
//                 TextFormField(
//                   keyboardType: TextInputType.number,
//                   enabled: set.setType == SetType.percentOfMax
//                       ? true
//                       : set.setType == SetType.percentOfTMax ? true : false,
//                   controller: percentController,
//                   decoration: textInputDecoration.copyWith(
//                       labelText: 'Percent', suffix: Text('%')),
//                   inputFormatters: <TextInputFormatter>[
//                     WhitelistingTextInputFormatter(
//                       RegExp(r'^\d*\.{0,1}\d*$'),
//                     ),
//                   ],
//                   onChanged: (val) => setStateSheet(
//                       () => set.percent = double.parse(val) / 100),
//                   validator: (val) {
//                     if (set.setType != SetType.weight && set.setType != null) {
//                       try {
//                         double.parse(val);
//                         if (val.isEmpty) {
//                           return 'Enter percent';
//                         } else if (exercise.exerciseBase.oneRepMax == null) {
//                           return 'No one rep max found';
//                         } else if (exercise.trainingMax == null) {
//                           return 'No training max found';
//                         }
//                         return null;
//                       } catch (e) {
//                         return 'Enter percent';
//                       }
//                     } else if (set.setType != SetType.weight &&
//                         set.setType != null &&
//                         val.isNotEmpty) {
//                       return 'Cannot have percent with a set type of Weight';
//                     } else
//                       return null;
//                   },
//                 ),
//                 SizedBox(height: 20.0),

//                 // Additional weight
//                 TextFormField(
//                   keyboardType: TextInputType.number,
//                   controller: additionalWeightController,
//                   enabled: (set.setType == SetType.percentOfMax ||
//                       set.setType == SetType.percentOfTMax),
//                   decoration: textInputDecoration.copyWith(
//                       labelText: 'Additional weight', suffix: Text('lbs')),
//                   inputFormatters: <TextInputFormatter>[
//                     WhitelistingTextInputFormatter(
//                       RegExp(r'^-?\d*\.{0,1}\d*$'),
//                     ),
//                   ],
//                   onChanged: (val) => setStateSheet(() => set.additionalWeight =
//                       val != '' ? double.parse(val) : null),
//                   validator: (val) {
//                     if (val.isEmpty) return null;
//                     try {
//                       double.parse(val);
//                       if (val.isEmpty) {
//                         return 'Enter additional weight';
//                       } else
//                         return null;
//                     } catch (e) {
//                       return 'Enter additional weight';
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20.0),

//                 RaisedButton(
//                   color: flamingoColor,
//                   child: Text(
//                     'Save',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () async {
//                     if (_formKey.currentState.validate()) {
//                       Navigator.pop(context);
//                       if (setIndex != null) {
//                         exercise.sets[setIndex] = set;
//                       } else {
//                         exercise.sets.add(set);
//                       }
//                       if (set.setType != SetType.weight) {
//                         exercise.calculateSets();
//                       }
//                       updateExercise(exercise);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   });
// }
