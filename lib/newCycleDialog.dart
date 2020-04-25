import 'package:flutter/material.dart';

import './global.dart';

class NewCycleDialog extends StatefulWidget {
  final Function newCycle;
  final List<String> cycleNames;

  NewCycleDialog({
    @required this.newCycle,
    @required this.cycleNames,
  });

  @override
  _NewCycleDialogState createState() => _NewCycleDialogState();
}

class _NewCycleDialogState extends State<NewCycleDialog> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _cycleNameController = TextEditingController();
  TextEditingController _tmPercentController = TextEditingController();
  String _dropdownValue = '1 Rep Max';
  String _errorText;
  bool _dateError = false;
  bool _nameError = false;
  bool _tmError = false;

  void clearDialog() {
    _cycleNameController.text = null;
    _dropdownValue = '1 Rep Max';
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
        'Create cycle',
        style: dialogTextStyle,
      ),
      content: SingleChildScrollView(
        child: ListBody(children: <Widget>[
          Container(
            child: Text('Start date:'),
          ),
          TextField(
              autofocus: true,
              cursorColor: Colors.white,
              controller: _startDateController,
              style: dialogTextStyle,
              decoration: InputDecoration(
                errorText: _dateError ? _errorText : null,
              ),
              onChanged: (String text) {
                setState(() {
                  _dateError = false;
                });
              },
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());

                Future<DateTime> selectedDate = showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                // TODO: figure out how to display date as string

                print(selectedDate.toString());

                selectedDate.whenComplete(() => {
                  if (selectedDate != null) {
                    setState(() {
                      _startDateController.text = selectedDate.toString();
                    })
                  }
                });

                //     selectedDate.whenComplete(() => {
                //   if (selectedDate != null) setState(() {
                //     // _startDateController.text = selectedDate.toString();
                //   }

                //     },
                // },
              }),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('Cycle name:'),
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.white,
            controller: _cycleNameController,
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
            child: Text('Training Max Percentage:'),
          ),
          TextField(
            autofocus: true,
            cursorColor: Colors.white,
            controller: _tmPercentController,
            style: dialogTextStyle,
            decoration: InputDecoration(
              errorText: _tmError ? _errorText : null,
              suffix: Text(
                '%',
                style: dialogTextStyle,
              ),
            ),
            onChanged: (String text) {
              setState(() {
                _tmError = false;
              });
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text('Increase 1RM or TM?'),
          ),
          DropdownButton(
            value: _dropdownValue,
            elevation: 0,
            isExpanded: true,
            style: dialogTextStyle,
            items: <String>['1 Rep Max', 'Training Max']
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
            if (widget.cycleNames.contains(_cycleNameController.text)) {
              setState(() {
                _nameError = true;
                _errorText = 'Program name ' +
                    _cycleNameController.text +
                    ' already exists.';
                return;
              });
            } else if (_cycleNameController.text.length < 1) {
              setState(() {
                _nameError = true;
                _errorText = 'Must enter program name';
                return;
              });
            } else {
              widget.newCycle(_cycleNameController.text, _dropdownValue);
              clearDialog();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
