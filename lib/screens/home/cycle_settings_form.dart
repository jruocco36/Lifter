import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CycleSettingsForm extends StatefulWidget {
  final String programDocumentId;
  final String cycleDocumentId;

  CycleSettingsForm({
    @required this.programDocumentId,
    this.cycleDocumentId,
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
  TextEditingController _textEditingController = TextEditingController();
  bool newStartDate = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Cycle>(
      stream: DatabaseService(uid: user.uid)
          .getCycleData(widget.programDocumentId, widget.cycleDocumentId),
      builder: (context, snapshot) {
        if (snapshot.hasData || widget.cycleDocumentId == null) {
          Cycle cycle = snapshot.data;
          if (cycle != null && !newStartDate) {
            _textEditingController.text =
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
                      textInputDecoration.copyWith(hintText: 'Cycle name'),
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
                  controller: _textEditingController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Start date'),
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
                  // onChanged: (val) => setState(
                  //     () => _startDate = DateFormat.yMd().parseStrict(val)),
                  onSaved: (val) =>
                      setState(() => _startDate = DateFormat.yMd().parse(val)),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());

                    DateTime selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 365)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        newStartDate = true;
                        _textEditingController.text =
                            DateFormat('MM/dd/yyyy').format(selectedDate);
                      });
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
                      hintText: 'Training Max Percent', suffix: Text('%')),
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
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.pop(context);
                      await DatabaseService(uid: user.uid).updateCycle(
                        widget.programDocumentId,
                        widget.cycleDocumentId,
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
