import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeekSettingsForm extends StatefulWidget {
  final Cycle cycle;
  final String weekId;
  final List<Week> weeks;

  WeekSettingsForm({
    @required this.cycle,
    this.weeks,
    this.weekId,
  });

  @override
  _WeekSettingsFormState createState() => _WeekSettingsFormState();
}

class _WeekSettingsFormState extends State<WeekSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _weekName;
  DateTime _startDate;
  TextEditingController _startDateController = TextEditingController();
  bool newStartDate = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(widget.weeks);

    return StreamBuilder<Week>(
      stream: DatabaseService(uid: user.uid)
          .getWeekData(widget.cycle, widget.weekId),
      builder: (context, snapshot) {
        if (snapshot.hasData || widget.weekId == null) {
          Week week = snapshot.data;
          if (week != null && !newStartDate) {
            _startDateController.text =
                DateFormat('MM/dd/yyyy').format(week.startDate);
          }

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  week != null ? 'Update week' : 'Create week',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),

                // week name
                TextFormField(
                  autofocus: true,
                  initialValue:
                      _weekName ?? (week != null ? week.weekName : ''),
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Week name'),
                  validator: (val) => val.isEmpty ? 'Enter week name' : null,
                  onChanged: (val) => setState(() => _weekName = val),
                ),
                SizedBox(height: 20.0),

                // Start Date Input
                TextFormField(
                  // cursorColor: whiteTextColor,
                  // decoration: const InputDecoration(labelText: 'Start date'),
                  // initialValue: _startDate ??
                  // (week != null ? week.startDate.toString() : ''),
                  controller: _startDateController,
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Start date'),
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
                        initialDate: getWeekDate(),
                        firstDate: widget.cycle.startDate,
                        lastDate: DateTime.now().add(Duration(days: 365)),
                        selectableDayPredicate: (date) {
                          bool selectable = true;
                          widget.weeks.forEach((week) {
                            if ((date.isAfter(week.startDate) ||
                                    date.isAtSameMomentAs(week.startDate)) &&
                                (date.isBefore(week.startDate
                                        .add(Duration(days: 6))) ||
                                    date.isAtSameMomentAs(week.startDate
                                        .add(Duration(days: 6))))) {
                              selectable = false;
                            }
                          });
                          return selectable;
                        });

                    if (selectedDate != null) {
                      setState(() {
                        newStartDate = true;
                        _startDateController.text =
                            DateFormat('MM/dd/yyyy').format(selectedDate);
                      });
                      _formKey.currentState.save();
                    }
                  },
                ),

                RaisedButton(
                  color: flamingoColor,
                  child: Text(
                    week != null ? 'Update' : 'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Navigator.pop(context);
                      if (_weekName == null && _startDate == null) return;
                      await DatabaseService(uid: user.uid).updateWeek(
                        widget.cycle.program.programId,
                        widget.cycle.cycleId,
                        widget.weekId,
                        _weekName ?? week.weekName,
                        _startDate != null ? _startDate : week.startDate,
                        week != null ? week.days : null,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  DateTime getWeekDate() {
    DateTime date = widget.cycle.startDate;
    widget.weeks.forEach((week) {
      if ((date.isAfter(week.startDate) ||
              date.isAtSameMomentAs(week.startDate)) &&
          (date.isBefore(week.startDate.add(Duration(days: 6))) ||
              date.isAtSameMomentAs(week.startDate.add(Duration(days: 6))))) {
        date = week.startDate.add(Duration(days: 7));
      }
    });
    return date;
  }
}
