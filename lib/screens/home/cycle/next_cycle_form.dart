import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/exercise.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/next_cycle_exercises.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NextCycleForm extends StatefulWidget {
  final Cycle oldCycle;
  final List<Cycle> cycleList;
  final List<Week> weekList;
  final List<Day> dayList;
  final List<Exercise> exerciseList;

  NextCycleForm({
    @required this.oldCycle,
    @required this.cycleList,
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
  List<String> cycleNames = [];

  void initState() {
    widget.cycleList.forEach((cycle) {
      cycleNames.add(cycle.name);
    });
    super.initState();
  }

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
                    if (val.isEmpty) {
                      return 'Enter cycle name';
                    } else if (cycleNames.contains(val)) {
                      return 'Cycle name already exists';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) => setState(() => _cycleName = val),
                ),
                SizedBox(height: 20.0),

                // Start Date Input
                TextFormField(
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
                    }
                  },
                ),
              ],
            ),
          );
  }
}
