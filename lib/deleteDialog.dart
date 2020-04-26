import 'package:flutter/material.dart';

import './global.dart';

class DeleteDialog extends StatelessWidget {
  final String name;
  final Function deleteFunction;

  DeleteDialog({
    @required this.name,
    @required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      elevation: 0,
      title: Text(
        'Delete ' + name + '?',
        style: dialogTextStyle,
        // textAlign: TextAlign.center,
      ),
      backgroundColor: lightGreyColor,
      actions: <Widget>[
        FlatButton(
          child: Text(
            'CANCEL',
            style: dialogTextStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: flamingoColor,
          child: Text('OK'),
          onPressed: () {
            deleteFunction();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
