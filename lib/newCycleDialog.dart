import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

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
  String _cycleTypeDropdown = '1 Rep Max';
  bool _dateError = false;
  bool _nameError = false;
  bool _tmError = false;
  String _dateErrorText;
  String _nameErrorText;
  String _tmErrorText;

  void clearDialog() {
    _cycleNameController.text = null;
    _cycleTypeDropdown = '1 Rep Max';
    _dateError = false;
    _nameError = false;
    _tmError = false;
    _dateErrorText = null;
    _nameErrorText = null;
    _tmErrorText = null;
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
        child: ListBody(
          children: <Widget>[
            // Start Date Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Start date:'),
                ),
                TextField(
                    autofocus: true,
                    cursorColor: Colors.white,
                    controller: _startDateController,
                    style: dialogTextStyle,
                    decoration: InputDecoration(
                      errorText: _dateError ? _dateErrorText : null,
                    ),
                    onChanged: (String text) {
                      setState(() {
                        _dateError = false;
                      });
                    },
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      DateTime selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      print(selectedDate);
                      if (selectedDate != null) {
                        setState(() {
                          _startDateController.text =
                              DateFormat('MM/dd/yyyy').format(selectedDate);
                          _dateError = false;
                        });
                      }

                      // selectedDate.whenComplete(() => {
                      //       if (selectedDate != null)
                      //         {
                      //           setState(() {
                      //             _startDateController.text = selectedDate.toString();
                      //           })
                      //         }
                      //     });

                      //     selectedDate.whenComplete(() => {
                      //   if (selectedDate != null) setState(() {
                      //     // _startDateController.text = selectedDate.toString();
                      //   }

                      //     },
                      // },
                    }),
              ],
            ),
            // Cycle Name Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                    errorText: _nameError ? _nameErrorText : null,
                  ),
                  onChanged: (String text) {
                    setState(() {
                      _nameError = false;
                    });
                  },
                ),
              ],
            ),
            // Training Max Percentage Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                    errorText: _tmError ? _tmErrorText : null,
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
              ],
            ),
            // Cycle Type Input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('Increase 1RM or TM?'),
                ),
                DropdownButton(
                  value: _cycleTypeDropdown,
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
                    setState(() => _cycleTypeDropdown = newValue);
                  },
                )
              ],
            ),
          ],
        ),
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
            if (_startDateController.text.length < 1) {
              setState(() {
                _dateError = true;
                _dateErrorText = 'Must enter start date';
              });
            }
            if (widget.cycleNames.contains(_cycleNameController.text)) {
              setState(() {
                _nameError = true;
                _nameErrorText = 'Cycle name ' +
                    _cycleNameController.text +
                    ' already exists.';
              });
            }
            if (_cycleNameController.text.length < 1) {
              setState(() {
                _nameError = true;
                _nameErrorText = 'Must enter cycle name';
              });
            }
            if (_tmPercentController.text.length < 1) {
              setState(() {
                _tmError = true;
                _tmErrorText = 'Must enter training max percentage';
              });
            }

            if (_dateError == false &&
                _nameError == false &&
                _tmError == false) {
              widget.newCycle(_cycleNameController.text, _cycleTypeDropdown);
              clearDialog();
              Navigator.of(context).pop();
            } else {
              return;
            }
          },
        ),
      ],
    );
  }
}
