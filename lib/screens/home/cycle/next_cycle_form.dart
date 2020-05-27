import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/next_cycle_exercises.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NextCycleForm extends StatefulWidget {
  final Cycle oldCycle;
  final List<Week> weekList;
  final List<Day> dayList;
  final List<Exercise> exerciseList;

  NextCycleForm({
    @required this.oldCycle,
    @required this.weekList,
    @required this.dayList,
    @required this.exerciseList,
  });

  @override
  _NextCycleFormState createState() => _NextCycleFormState();
}

class _NextCycleFormState extends State<NextCycleForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _cycleName;
  DateTime _startDate;
  String _trainingMaxPercent;
  TextEditingController _startDateController = TextEditingController();
  bool includeDelays = false;

  bool newCycleWait = false;

  @override
  Widget build(BuildContext context) {
    return newCycleWait
        ? Loading()
        : Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // cycle name
                TextFormField(
                  autofocus: true,
                  // initialValue:
                  //     _cycleName ?? (cycle != null ? cycle.name : ''),
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Cycle name'),
                  validator: (val) {
                    if (val == widget.oldCycle.name) {
                      return 'Cannot be same as previous cycle';
                    } else if (val.isEmpty) {
                      return 'Enter cycle name';
                    } else
                      return null;
                  },
                  onChanged: (val) => setState(() => _cycleName = val),
                ),
                SizedBox(height: 20.0),

                // Start Date Input
                TextFormField(
                  // cursorColor: whiteTextColor,
                  // decoration: const InputDecoration(labelText: 'Start date'),
                  // initialValue: _startDate ??
                  // (cycle != null ? cycle.startDate.toString() : ''),
                  controller: _startDateController,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Start date',
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      size: 20,
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (val) {
                    if (val.isEmpty) return 'Enter start date';
                    try {
                      DateFormat.yMd().parseStrict(val);
                      return null;
                    } on FormatException {
                      return 'Not a valid date';
                    }
                  },
                  onSaved: (val) =>
                      setState(() => _startDate = DateFormat.yMd().parse(val)),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    DateTime selectedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.dayList.last.date.add(
                        Duration(days: 8 - widget.dayList.last.date.weekday),
                      ),
                      // firstDate: widget.dayList.last.date.add(
                      //   Duration(days: 1),
                      // ),
                      // allow any date within last 10 years so future planned cycles can be copied
                      // or you can backlog previous cycles
                      firstDate: DateTime(
                          widget.oldCycle.startDate.year - 10,
                          widget.oldCycle.startDate.month,
                          widget.oldCycle.startDate.day),
                      lastDate: DateTime(
                          widget.oldCycle.startDate.year + 5,
                          widget.oldCycle.startDate.month,
                          widget.oldCycle.startDate.day),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        _startDateController.text =
                            DateFormat('MM/dd/yyyy').format(selectedDate);
                      });
                      _formKey.currentState.save();
                    }
                  },
                ),
                SizedBox(height: 20.0),

                // Training max percent
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(
                      RegExp(r'^\d*\.{0,1}\d*$'),
                    ),
                  ],
                  initialValue: _trainingMaxPercent ??
                      (widget.oldCycle.trainingMaxPercent * 100).toString(),
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Training Max Percent', suffix: Text('%')),
                  validator: (val) =>
                      val.isEmpty ? 'Enter training max percent' : null,
                  onChanged: (val) => setState(() => _trainingMaxPercent = val),
                ),
                SizedBox(height: 20.0),

                DropdownButtonFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Include delays?'),
                  isDense: true,
                  value: 'No',
                  items: ['No', 'Yes'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      if (val == 'Yes')
                        includeDelays = true;
                      else
                        includeDelays = false;
                    });
                  },
                ),
                SizedBox(height: 20.0),

                RaisedButton(
                  color: flamingoColor,
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Cycle newCycle = Cycle(
                        cycleId: null,
                        name: _cycleName,
                        program: widget.oldCycle.program,
                        startDate: _startDate,
                        trainingMaxPercent: _trainingMaxPercent != null
                            ? double.parse(_trainingMaxPercent) / 100
                            : widget.oldCycle.trainingMaxPercent,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextCycleExercises(
                            oldCycle: widget.oldCycle,
                            newCycle: newCycle,
                            weekList: widget.weekList,
                            dayList: widget.dayList,
                            exerciseList: widget.exerciseList,
                            includeDelays: includeDelays,
                          ),
                        ),
                      );

                      // setState(() {
                      //   newCycleWait = true;
                      // });

                      // await createNewCycle(
                      //   cycleName: _cycleName,
                      //   program: widget.oldCycle.program,
                      //   startDate: _startDate,
                      //   trainingMaxPercent: _trainingMaxPercent != null
                      //       ? double.parse(_trainingMaxPercent) / 100
                      //       : widget.oldCycle.trainingMaxPercent,
                      //   weekList: widget.weekList,
                      //   dayList: widget.dayList,
                      //   exerciseList: widget.exerciseList,
                      // );

                      // Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
  }

  Future createNewCycle({
    @required String cycleName,
    @required Program program,
    @required DateTime startDate,
    @required double trainingMaxPercent,
    @required List<Week> weekList,
    @required List<Day> dayList,
    @required List<Exercise> exerciseList,
  }) async {
    // create next cycle
    Cycle newCycle = Cycle(
      cycleId: null,
      name: cycleName,
      program: program,
      startDate: startDate,
      trainingMaxPercent: trainingMaxPercent,
    );

    newCycle = await newCycle.updateCycle();

    int delayDays = 0; // days delayed to offset for new cycle
    // create weeks
    for (Week week in weekList) {
      Week newWeek = Week(
        cycle: newCycle,
        weekName: week.weekName,
        weekId: null,
        days: null,
        startDate: newCycle.startDate
            .add(week.startDate.difference(week.cycle.startDate)),
      );

      newWeek = await newWeek.updateWeek();

      // create days
      for (Day day in dayList) {
        if (day.week.weekId != week.weekId) continue;
        if (includeDelays == false && day.delayDays != null)
          delayDays += day.delayDays;
        Day newDay = Day(
          date: newCycle.startDate
              .subtract(Duration(days: delayDays))
              .add(day.date.difference(day.week.cycle.startDate)),
          delayDays: null,
          dayId: null,
          dayName: day.dayName,
          week: newWeek,
        );

        newDay = await newDay.updateDay();

        // create exercises
        for (Exercise exercise in exerciseList) {
          if (exercise.day.dayId != day.dayId) continue;
          Exercise newExercise = Exercise(
            day: newDay,
            exerciseBase: exercise.exerciseBase,
            exerciseId: null,
            sets: exercise.sets,
          );

          newExercise.startNew();
          if (newExercise.exerciseBase.exerciseName == 'Bench') {
            newExercise.updateTM(newExercise.trainingMax + 5.0);
          }
          if (newExercise.exerciseBase.exerciseName == 'Squat') {
            newExercise.updateTM(newExercise.trainingMax + 10.0);
          }
          newExercise.calculateAllSets();
          await newExercise.updateExercise();
        }
      }
    }

    return newCycle.cycleId;
  }
}
