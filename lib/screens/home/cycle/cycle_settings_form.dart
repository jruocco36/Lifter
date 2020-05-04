import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: date can't be same as other cycles
// check week settings form for how to do this
// will need to pull weeks for each cycle

class CycleSettingsForm extends StatefulWidget {
  final Program program;
  final String cycleId;

  CycleSettingsForm({
    @required this.program,
    this.cycleId,
  });

  @override
  _CycleSettingsFormState createState() => _CycleSettingsFormState();
}

class _CycleSettingsFormState extends State<CycleSettingsForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  String _cycleName;
  DateTime _startDate;
  String _trainingMaxPercent;
  TextEditingController _startDateController = TextEditingController();
  bool newStartDate = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Cycle>(
      stream: DatabaseService(uid: user.uid)
          .getCycleData(widget.program, widget.cycleId),
      builder: (context, snapshot) {
        if (snapshot.hasData || widget.cycleId == null) {
          Cycle cycle = snapshot.data;
          if (cycle != null && !newStartDate) {
            _startDateController.text =
                DateFormat('MM/dd/yyyy').format(cycle.startDate);
          }

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  cycle != null ? 'Update cycle' : 'Create cycle',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),

                // cycle name
                TextFormField(
                  autofocus: true,
                  initialValue: _cycleName ?? (cycle != null ? cycle.name : ''),
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Cycle name'),
                  validator: (val) => val.isEmpty ? 'Enter cycle name' : null,
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
                      initialDate: _startDate ??
                          (cycle != null ? cycle.startDate : DateTime.now()),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

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
                SizedBox(height: 20.0),

                // Training max percent
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  initialValue: _trainingMaxPercent ??
                      (cycle != null
                          ? cycle.trainingMaxPercent.toString()
                          : ''),
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Training Max Percent', suffix: Text('%')),
                  validator: (val) =>
                      val.isEmpty ? 'Enter training max percent' : null,
                  onChanged: (val) => setState(() => _trainingMaxPercent = val),
                ),

                RaisedButton(
                  color: flamingoColor,
                  child: Text(
                    cycle != null ? 'Update' : 'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    if (_formKey.currentState.validate()) {
                      if (_cycleName == null &&
                          _startDate == null &&
                          _trainingMaxPercent == null) return;

                      await DatabaseService(uid: user.uid).updateCycle(
                        widget.program.programId,
                        widget.cycleId,
                        _cycleName ?? cycle.name,
                        _startDate != null ? _startDate : cycle.startDate,
                        _trainingMaxPercent != null
                            ? int.parse(_trainingMaxPercent)
                            : cycle.trainingMaxPercent,
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
