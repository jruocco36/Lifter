import 'package:flutter/material.dart';

class NewProgramButton extends StatefulWidget {
  final Function newProgram;
  final List<String> programNames;

  NewProgramButton({this.newProgram, this.programNames});

  @override
  _NewProgramButtonState createState() => _NewProgramButtonState(
      newProgram: newProgram, programNames: programNames);
}

class _NewProgramButtonState extends State<NewProgramButton> {
  TextEditingController _textFieldController = TextEditingController();
  String _dropdownValue = 'Cycle based';
  final Function newProgram;
  List<String> programNames;
  String _errorText;

  _NewProgramButtonState({this.newProgram, this.programNames});

  _displayDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentTextStyle: TextStyle(color: Color(0xFF888888)),
            elevation: 0,
            title: Text(
              'Create program',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF484850),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
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
                      errorText: _errorText,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ),
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
              );
            }),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Color(0xFFD37C7C),
                child: Text('OK'),
                // TODO: validate input
                onPressed: () {
                  print(programNames.toString());
                  print(_textFieldController.text);
                  if (programNames.contains(_textFieldController.text)) {
                    _errorText = 'Program name ' +
                        _textFieldController.text +
                        ' already exists.';
                    return;
                  }
                  if (_textFieldController.text.length > 0)
                    newProgram(_textFieldController.text, _dropdownValue);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }).then((val) {
      _textFieldController.text = '';
      _dropdownValue = 'Cycle based';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _displayDialog(context),
      child: Icon(Icons.add),
      elevation: 0,
      // backgroundColor: Color(0xFFD37C7C),
    );
  }
}
