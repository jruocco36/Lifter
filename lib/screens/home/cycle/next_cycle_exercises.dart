import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NextCycleExercises extends StatefulWidget {
  final Cycle oldCycle;
  final Cycle newCycle;
  final List<Week> weekList;
  final List<Day> dayList;
  final List<Exercise> exerciseList;
  final bool includeDelays;

  NextCycleExercises({
    @required this.oldCycle,
    @required this.newCycle,
    @required this.weekList,
    @required this.dayList,
    @required this.exerciseList,
    @required this.includeDelays,
  });

  @override
  _NextCycleExercisesState createState() => _NextCycleExercisesState();
}

class _NextCycleExercisesState extends State<NextCycleExercises> {
  final _formKey = GlobalKey<FormState>();

  bool includeDelays = false;
  bool newCycleWait = false;

  List<ExerciseBase> exerciseBaseList = [];

  /// Map<cycleId, bool>
  /// True if we are adding a percentage of TM, otherwise adding weight
  Map<String, bool> addPercent = {};

  /// Map<cycleId, weight>
  Map<String, double> addAmount = {};

  void initState() {
    for (Exercise ex in widget.exerciseList) {
      if (ex.exerciseBase.exerciseType == ExerciseType.Main) {
        if (!exerciseBaseList.contains(ex.exerciseBase)) {
          exerciseBaseList.add(ex.exerciseBase);
          addPercent[ex.exerciseBase.exerciseBaseId] = false;
          addAmount[ex.exerciseBase.exerciseBaseId] = 0.0;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Cycle'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: newCycleWait
          ? Loading()
          : SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListView.builder(
                        itemCount: exerciseBaseList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  exerciseBaseList[index].exerciseName,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 7),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true, signed: false),
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter(
                                            RegExp(r'^\d*\.{0,1}\d*$'),
                                          ),
                                        ],
                                        decoration:
                                            textInputDecoration.copyWith(
                                          hintText: 'Add to training max',
                                          isDense: true,
                                          hintStyle: TextStyle(fontSize: 14),
                                        ),
                                        validator: (val) {
                                          String type;
                                          if (addPercent[exerciseBaseList[index]
                                                  .exerciseBaseId] ==
                                              true) {
                                            type = 'percent';
                                          } else {
                                            type = 'weight';
                                          }

                                          if (val.isEmpty) {
                                            return 'Enter ' + type;
                                          } else {
                                            try {
                                              double.parse(val);
                                              return null;
                                            } catch (e) {
                                              return 'Not a valid ' + type;
                                            }
                                          }
                                        },
                                        onChanged: (val) {
                                          // adding percent
                                          if (addPercent[exerciseBaseList[index]
                                                  .exerciseBaseId] ==
                                              true) {
                                            setState(() {
                                              addAmount[exerciseBaseList[index]
                                                      .exerciseBaseId] =
                                                  1 + (double.parse(val) / 100);
                                            });
                                          }
                                          // adding weight
                                          else {
                                            setState(() {
                                              addAmount[exerciseBaseList[index]
                                                      .exerciseBaseId] =
                                                  double.parse(val);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 0),
                                        child: Text(
                                          'lbs',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: addPercent[
                                                    exerciseBaseList[index]
                                                        .exerciseBaseId]
                                                ? greyTextColor
                                                : whiteTextColor,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() => addPercent[
                                            exerciseBaseList[index]
                                                .exerciseBaseId] = false);
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: addPercent[
                                                    exerciseBaseList[index]
                                                        .exerciseBaseId]
                                                ? whiteTextColor
                                                : greyTextColor,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() => addPercent[
                                            exerciseBaseList[index]
                                                .exerciseBaseId] = true);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        color: flamingoColor,
                        child: Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              newCycleWait = true;
                            });

                            await newCycle(
                              newCycle: widget.newCycle,
                              weekList: widget.weekList,
                              dayList: widget.dayList,
                              exerciseList: widget.exerciseList,
                            );

                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future newCycle({
    @required Cycle newCycle,
    @required List<Week> weekList,
    @required List<Day> dayList,
    @required List<Exercise> exerciseList,
  }) async {
    newCycle = await newCycle.updateCycle();

    for (ExerciseBase base in exerciseBaseList) {
      double newTM;

      // add percent
      if (addPercent[base.exerciseBaseId]) {
        newTM = ((base.cycleTMs[widget.oldCycle.cycleId] *
                        addAmount[base.exerciseBaseId]) /
                    5)
                .roundToDouble() *
            5;
      }
      // add weight
      else {
        newTM = ((base.cycleTMs[widget.oldCycle.cycleId] +
                        addAmount[base.exerciseBaseId]) /
                    5)
                .roundToDouble() *
            5;
      }

      base.updateCycleTM(newCycle, newTM);
      DatabaseService(uid: newCycle.program.uid).updateExerciseBase(base);
    }

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
          newExercise.calculateAllSets();
          await newExercise.updateExercise();
        }
      }
    }

    return newCycle.cycleId;
  }
}
