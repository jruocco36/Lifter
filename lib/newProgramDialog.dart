import 'package:flutter/material.dart';

import './global.dart';

class NewProgramDialog extends StatefulWidget {
  final Function newProgram;
  final List<String> programNames;

  NewProgramDialog({this.newProgram, this.programNames});

  @override
  _NewProgramDialogState createState() => _NewProgramDialogState();
}

class _NewProgramDialogState extends State<NewProgramDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _programBaseType;
  String _programProgressType;
  String _programName;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: dialogHintStyle,
      backgroundColor: lightGreyColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      title: Text(
        'Create program',
        style: dialogTextStyle,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: _programForm(),
          autovalidate: _autoValidate,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'CANCEL',
            style: dialogTextStyle,
          ),
          onPressed: () {
            // clearDialog();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: flamingoColor,
          child: Text('OK'),
          onPressed: () {
            _validateInputs();
          },
        ),
      ],
    );
  }

  Widget _programForm() {
    return ListBody(
      children: <Widget>[
        TextFormField(
          autofocus: true,
          cursorColor: Colors.white,
          keyboardType: TextInputType.text,
          style: dialogTextStyle,
          decoration: const InputDecoration(
            labelText: 'Program name',
          ),
          validator: (String text) {
            return _validateProgramName(text);
          },
          onSaved: (String text) {
            _programName = text;
          },
        ),
        DropdownButtonFormField(
          value: _programBaseType,
          isDense: true,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Type of program',
          ),
          items: <String>['Cycle based', 'Day based']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (String text) {
            return _validateProgramType(text);
          },
          onChanged: (String text) {
            setState(() => _programBaseType = text);
          },
          onSaved: (String text) {
            _programBaseType = text;
          },
        ),
        DropdownButtonFormField(
          value: _programProgressType,
          isDense: true,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Progress 1RM or TM?',
          ),
          items: <String>['1 Rep Max', 'Training Max']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          validator: (String text) {
            return _validateProgramType(text);
          },
          onChanged: (String text) {
            setState(() => _programProgressType = text);
          },
          onSaved: (String text) {
            _programProgressType = text;
          },
        ),
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      widget.newProgram(_programName, _programBaseType, _programProgressType);
      Navigator.of(context).pop();
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String _validateProgramName(String name) {
    if (widget.programNames.contains(name)) {
      return 'Program name ' + name + ' already exists.';
    } else if (name.length < 1) {
      return 'Must enter program name';
    } else
      return null;
  }

  String _validateProgramType(String type) {
    if (type == null) {
      return 'Must choose';
    } else
      return null;
  }
}
