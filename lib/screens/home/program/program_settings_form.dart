import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgramSettingsForm extends StatefulWidget {
  final String programId;

  ProgramSettingsForm({this.programId});

  @override
  _ProgramSettingsFormState createState() => _ProgramSettingsFormState();
}

class _ProgramSettingsFormState extends State<ProgramSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> programTypes = ['Cycle based', 'Day based'];
  final List<String> progressTypes = ['1 Rep Max', 'Training Max'];

  // form values
  String _programName;
  String _programType; // cycle based or day based
  String _progressType; // 1RM based or Training Max based

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<Program>(
      stream: DatabaseService(uid: user.uid).getProgramData(widget.programId),
      builder: (context, snapshot) {
        if (snapshot.hasData || widget.programId == null) {
          Program program = snapshot.data;
          Timestamp _createdDate =
              program != null ? program.createdDate : Timestamp.now();

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  program != null ? 'Update program' : 'Create program',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),

                // program name
                TextFormField(
                  autofocus: true,
                  initialValue:
                      _programName ?? (program != null ? program.name : ''),
                  decoration:
                      textInputDecoration.copyWith(labelText: 'Program name'),
                  validator: (val) => val.isEmpty ? 'Enter program name' : null,
                  onChanged: (val) => setState(() => _programName = val),
                ),
                SizedBox(height: 20.0),

                // Program type dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  isDense: true,
                  value: _programType ??
                      (program != null ? program.programType : 'Cycle based'),
                  items: programTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text('$type'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _programType = val),
                ),
                SizedBox(height: 20.0),
                
                // Progress type dropdown
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  isDense: true,
                  value: _progressType ??
                      (program != null ? program.progressType : '1 Rep Max'),
                  items: progressTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text('$type'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _progressType = val),
                ),

                RaisedButton(
                  color: flamingoColor,
                  child: Text(
                    program != null ? 'Update' : 'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Navigator.pop(context);
                      if (_programName == null &&
                          _programType == null &&
                          _progressType == null) return;

                      await DatabaseService(uid: user.uid).updateProgram(
                          widget.programId,
                          _programName ?? program.name,
                          _programType ??
                              (program != null
                                  ? program.programType
                                  : 'Cycle based'),
                          _progressType ??
                              (program != null
                                  ? program.progressType
                                  : '1 Rep Max'),
                          _createdDate);
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
