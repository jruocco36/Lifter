import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './global.dart';

// TODO: pass [_startDate] and [_trainingMaxPercent] to [newCycle()] to store

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  TextEditingController _startDateController = TextEditingController();
  DateTime _startDate;
  String _cycleName;
  int _trainingMaxPercent;
  String _cycleTypeDropdown;

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
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: _cycleForm(),
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
            // widget.newCycle(_cycleName, _cycleTypeDropdown);
            // clearDialog();
            // Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _cycleForm() {
    return ListBody(
      children: <Widget>[
        // Cycle Name Input
        TextFormField(
          autofocus: true,
          cursorColor: whiteTextColor,
          decoration: const InputDecoration(labelText: 'Cycle name'),
          keyboardType: TextInputType.text,
          validator: (String text) {
            return _validateCycleName(text);
          },
          onSaved: (String text) {
            _cycleName = text;
          },
        ),

        // Start Date Input
        TextFormField(
          cursorColor: whiteTextColor,
          decoration: const InputDecoration(labelText: 'Start date'),
          keyboardType: TextInputType.datetime,
          controller: _startDateController,
          validator: (String text) {
            return _validateStartDate(text);
          },
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
                _startDateController.text =
                    DateFormat('MM/dd/yyyy').format(selectedDate);
              });
            }
          },
          onSaved: (String text) {
            print(DateFormat.yMd().parse(text));
            _startDate = DateFormat.yMd().parse(text);
          },
        ),

        // Training Max Percentage Input
        TextFormField(
          cursorColor: whiteTextColor,
          decoration: const InputDecoration(
            labelText: 'Training Max Percentage',
            suffix: Text('%'),
          ),
          keyboardType: TextInputType.number,
          validator: (String text) {
            return _validateTmPercent(text);
          },
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onSaved: (String text) {
            _trainingMaxPercent = int.parse(text);
          },
        ),
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      widget.newCycle(_cycleName, _cycleTypeDropdown);
      Navigator.of(context).pop();
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String _validateCycleName(String name) {
    if (widget.cycleNames.contains(name)) {
      return 'Cycle name ' + name + ' already exists.';
    }
    if (name.length < 1) {
      return 'Must enter cycle name';
    } else
      return null;
  }

  String _validateStartDate(String date) {
    if (date.length < 1) {
      return 'Must enter start date';
    } else {
      try {
        DateFormat.yMd().parseStrict(date);
        return null;
      } on FormatException {
        return 'Not a valid start date';
      }
    }
  }

  String _validateTmPercent(String percent) {
    if (percent.length < 1) {
      return 'Must enter training max percentage';
    } else
      return null;
  }
}
