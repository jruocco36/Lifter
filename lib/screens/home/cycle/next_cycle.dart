import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/next_cycle_form.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: pick exercises and weight to add for next cycle

class NextCycle extends StatefulWidget {
  final Cycle oldCycle;

  NextCycle({@required this.oldCycle});

  @override
  _NextCycleState createState() => _NextCycleState();
}

class _NextCycleState extends State<NextCycle> {
  // cycle data
  List<Cycle> cycleList;  // for new cycle name validation
  List<Week> weekList;
  List<Day> dayList;
  List<Exercise> exerciseList;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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
      body: FutureBuilder<List<Cycle>>(
          future: DatabaseService(uid: user.uid)
              .getCycleList(widget.oldCycle.program),
          builder: (context, snapshot) {
            cycleList = snapshot.data;

            return FutureBuilder<List<Week>>(
              future:
                  DatabaseService(uid: user.uid).getWeekList(widget.oldCycle),
              builder: (context, snapshot) {
                weekList = snapshot.data;

                return FutureBuilder<List<Day>>(
                  future: DatabaseService(uid: user.uid).getDayList(weekList),
                  builder: (context, snapshot) {
                    dayList = snapshot.data;

                    return FutureBuilder<List<Exercise>>(
                      future: DatabaseService(uid: user.uid)
                          .getExerciseList(dayList),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loading();
                        }

                        exerciseList = snapshot.data;
                        return SingleChildScrollView(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: NextCycleForm(
                                oldCycle: widget.oldCycle,
                                cycleList: cycleList,
                                weekList: weekList,
                                dayList: dayList,
                                exerciseList: exerciseList,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
