import 'package:flutter/material.dart';

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
    _textFieldController.text = '';
    _dropdownValue = 'Cycle based';
    // _errorText = null;
    _nameError = false;
  }

  // TODO: rounded corners on AlertDialog
  // might need custom AlertDialog

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentTextStyle: TextStyle(color: Color(0xFF888888)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      elevation: 0,
      title: Text(
        'Create program',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xFF484850),
      content:
          // StatefulBuilder(
          // builder: (BuildContext context, StateSetter setState) {
          SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Text('Program name:'),
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.white,
            controller: _textFieldController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              // hintText: 'Program name',
              errorText: _nameError ? _errorText : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFF888888),
                ),
              ),
            ),
            onChanged: (String text) {},
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('Type of program:'),
          ),
          DropdownButton(
            value: _dropdownValue,
            elevation: 0,
            isExpanded: true,
            style: TextStyle(
              color: Colors.white,
            ),
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
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            clearDialog();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: Color(0xFFD37C7C),
          child: Text('OK'),
          // TODO: validate input
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
