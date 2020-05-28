import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class BodyweightForm extends StatefulWidget {
  final User user;

  BodyweightForm({this.user});

  @override
  _BodyweightFormState createState() => _BodyweightFormState();
}

class _BodyweightFormState extends State<BodyweightForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _bodyweightController = TextEditingController();
  String _bodyweight;
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool _newDate = true;

  void initState() {
    _dateTextController.text = DateFormat('MM/dd/yyyy').format(_date);
    super.initState();
  }

  void dispose() {
    _dateTextController.dispose();
    _bodyweightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService(uid: widget.user.uid).getBodyweight(_date),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          if (snapshot.hasData) {
            // only pull in bodyweight if we have a new date
            // without this, old bodyweight fills in briefly after hitting
            // save, because validate() rebuilds the form
            if (_newDate) {
              if (snapshot.data > 0) {
                _bodyweightController.text = snapshot.data.toString();
                _bodyweight = snapshot.data.toString();
              } else {
                _bodyweight = null;
                _bodyweightController.text = '';
              }
            }
          }

          return SingleChildScrollView(
            child: Container(
              // so keyboard doesn't cover input
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 60.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // Date Input
                      TextFormField(
                        controller: _dateTextController,
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Date',
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            size: 20,
                          ),
                        ),
                        keyboardType: TextInputType.datetime,
                        enableInteractiveSelection: false,
                        validator: (val) {
                          if (_newDate) return null;
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
                            initialDate: _date,
                            firstDate: DateTime(DateTime.now().year - 10,
                                DateTime.now().month, DateTime.now().day),
                            lastDate: DateTime(DateTime.now().year + 5,
                                DateTime.now().month, DateTime.now().day),
                          );

                          if (selectedDate != null) {
                            setState(() {
                              _dateTextController.text =
                                  DateFormat('MM/dd/yyyy').format(selectedDate);
                              _newDate = true; // we have a new date, reset form
                              _formKey.currentState
                                  .validate(); // clear error messages
                            });
                            _formKey.currentState.save();
                          }
                        },
                      ),
                      SizedBox(height: 20.0),

                      TextFormField(
                        controller: _bodyweightController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: textInputDecoration.copyWith(
                            labelText: 'Bodyweight'),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(
                            RegExp(r'^\d*\.{0,1}\d*$'),
                          ),
                        ],
                        validator: (val) {
                          if (_newDate) return null;
                          if (val.isEmpty) {
                            return 'Enter bodyweight';
                          } else {
                            try {
                              double.parse(val);
                              return null;
                            } catch (e) {
                              return 'Not a valid bodyweight';
                            }
                          }
                        },
                        onChanged: (val) {
                          if (val == '') {
                            _bodyweight = null;
                          } else {
                            _bodyweight = val;
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
                          // don't pull in new bodyweight until a new date is selected
                          // validate() will rebuild form, we don't want to reset
                          // bodyweight to original value when that happens
                          _newDate = false;
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context);
                            widget.user.addBodyweight(
                                _date, double.parse(_bodyweight));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
