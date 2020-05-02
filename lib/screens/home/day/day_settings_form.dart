import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DaySettingsForm extends StatefulWidget {
  final Week week;
  final String dayId;

  DaySettingsForm({
    @required this.week,
    this.dayId,
  });

  @override
  _DaySettingsFormState createState() => _DaySettingsFormState();
}

class _DaySettingsFormState extends State<DaySettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _dayName;
  DateTime _date;
  TextEditingController _dateTextController = TextEditingController();
  bool newDate = false;
  String _bodyweight;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Day>(
      stream:
          DatabaseService(uid: user.uid).getDayData(widget.week, widget.dayId),
      builder: (context, snapshot) {
        if (snapshot.hasData || widget.dayId == null) {
          Day day = snapshot.data;
          if (day != null && !newDate) {
            _dateTextController.text =
                DateFormat('MM/dd/yyyy').format(day.date);
          }

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  day != null ? 'Update day' : 'Create day',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),

                // day name
                TextFormField(
                  autofocus: true,
                  initialValue: _dayName ?? (day != null ? day.dayName : ''),
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Day name'),
                  validator: (val) => val.isEmpty ? 'Enter day name' : null,
                  onChanged: (val) => setState(() => _dayName = val),
                ),
                SizedBox(height: 20.0),

                // Date Input
                TextFormField(
                  // cursorColor: whiteTextColor,
                  // decoration: const InputDecoration(labelText: 'Start date'),
                  // initialValue: _date ??
                  // (day != null ? day.date.toString() : ''),
                  controller: _dateTextController,
                  decoration: textInputDecoration.copyWith(labelText: 'Date'),
                  keyboardType: TextInputType.datetime,
                  validator: (val) {
                    if (val.isEmpty) return 'Enter date';
                    try {
                      DateFormat.yMd().parseStrict(val);
                      return null;
                    } on FormatException {
                      return 'Not a valid date';
                    }
                  },
                  onSaved: (val) =>
                      setState(() => _date = DateFormat.yMd().parse(val)),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    DateTime selectedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          _date ?? (day != null ? day.date : DateTime.now()),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        newDate = true;
                        _dateTextController.text =
                            DateFormat('MM/dd/yyyy').format(selectedDate);
                      });
                      _formKey.currentState.save();
                    }
                  },
                ),
                SizedBox(height: 20.0),

                // bodyweight
                TextFormField(
                  initialValue:
                      _bodyweight ?? (day != null ? day.bodyWeight : ''),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Bodyweight'),
                  validator: (val) {
                    if (val.isEmpty) return 'Enter bodyweight';
                    try {
                      double weight = double.parse(val);
                      if (weight < 0)
                        return 'Not a valid bodyweight';
                      else
                        return null;
                    } on FormatException {
                      return 'Not a valid bodyweight';
                    }
                  },
                  onChanged: (val) => setState(() => _bodyweight = val),
                ),

                RaisedButton(
                  color: flamingoColor,
                  child: Text(
                    day != null ? 'Update' : 'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Navigator.pop(context);
                      if (_dayName == null && _date == null) return;
                      await DatabaseService(uid: user.uid).updateDay(
                        widget.week,
                        widget.dayId,
                        _date != null ? _date : day.date,
                        _bodyweight != null
                            ? double.parse(_bodyweight)
                            : day.bodyWeight,
                        _dayName ?? day.dayName,
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
}
