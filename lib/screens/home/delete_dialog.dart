import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String name;

  DeleteDialog(this.name);

  bool get result {

  }

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
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          color: flamingoColor,
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
