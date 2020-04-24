import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  Color _c = Colors.redAccent;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        color: _c,
        height: 20.0,
        width: 20.0,
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Switch'),
            onPressed: () => setState(() {
                  _c == Colors.redAccent
                      ? _c = Colors.blueAccent
                      : _c = Colors.redAccent;
                }))
      ],
    );
  }
}