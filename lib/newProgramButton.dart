import 'package:flutter/material.dart';

class NewProgramButton extends StatelessWidget {
  TextEditingController textFieldController;
  String dropdownValue;
  Function dropdownValueChanged;
  Function newProgram;
  List<String> programNames;
  String errorText;

  NewProgramButton(
      {this.textFieldController,
      this.dropdownValue,
      this.dropdownValueChanged,
      this.newProgram,
      this.programNames});

  _displayDialog(BuildContext context) async {
    return showDialog(
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
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Text('Program name:'),
                ),
                TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  controller: textFieldController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    // hintText: 'Program name',
                    errorText: errorText,
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
                  value: dropdownValue,
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
                    dropdownValue = newValue;
                    dropdownValueChanged(dropdownValue);
                  },
                )
              ]),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  textFieldController.clear();
                  dropdownValue = 'Cycle based';
                  dropdownValueChanged(dropdownValue);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Color(0xFFD37C7C),
                onPressed: () {
                  if (programNames.contains(textFieldController.text)) {
                    errorText = 'Program name ' + textFieldController.text + ' already exists.';
                    dropdownValueChanged(dropdownValue);
                    return;
                  }
                  if (textFieldController.text.length > 0) newProgram();
                  textFieldController.clear();
                  dropdownValue = 'Cycle based';
                  dropdownValueChanged(dropdownValue);
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
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
