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
  TextEditingController _textFieldController = TextEditingController();
  String _dropdownValue = 'Cycle based';
  String _errorText;
  bool _nameError = false;

  void clearDialog() {
    _textFieldController.text = null;
    _dropdownValue = 'Cycle based';
    _errorText = null;
    _nameError = false;
  }

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
        child: ListBody(children: <Widget>[
          Container(
            child: Text('Program name:'),
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.white,
            controller: _textFieldController,
            style: dialogTextStyle,
            decoration: InputDecoration(
              errorText: _nameError ? _errorText : null,
            ),
            onChanged: (String text) {
              setState(() {
                _nameError = false;
              });
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('Type of program:'),
          ),
          DropdownButton(
            value: _dropdownValue,
            elevation: 0,
            isExpanded: true,
            style: dialogTextStyle,
            items: <String>['Cycle based', 'Day based']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String newValue) {
              setState(() => _dropdownValue = newValue);
            },
          )
        ]),
      ),
      // }),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'CANCEL',
            style: dialogTextStyle,
          ),
          onPressed: () {
            clearDialog();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: flamingoColor,
          child: Text('OK'),
          onPressed: () {
            if (widget.programNames.contains(_textFieldController.text)) {
              setState(() {
                _nameError = true;
                _errorText = 'Program name ' +
                    _textFieldController.text +
                    ' already exists.';
                return;
              });
            } else if (_textFieldController.text.length < 1) {
              setState(() {
                _nameError = true;
                _errorText = 'Must enter program name';
                return;
              });
            } else {
              widget.newProgram(_textFieldController.text, _dropdownValue);
              clearDialog();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class ProgramNameField extends StatefulWidget {
  @override
  _NewProgramDialogState createState() => new _NewProgramDialogState();
}
