import 'package:flutter/material.dart';

import './programList.dart';
import './startText.dart';

void main() => runApp(MyApp());

// StatelessWidget - doesn't change/not re-rendered on user input
// StatefulWidget - changes/re-rendered on user input
class MyApp extends StatefulWidget {
  // Link this StatefulWidget class to State class
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Map<int, String> _programs = {};
  var programIndex = 1;

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _newProgram() {
    // _showDialog();

    if (_programs.length > 0)
      programIndex = _programs.keys.last + 1;
    else
      programIndex = 1;
    setState(() {
      _programs[programIndex] = 'Program ' + (programIndex).toString();
    });
  }

  void _deleteProgram(int key) {
    setState(() {
      _programs.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Scaffold() is helper widget to create base page design for app
      home: Scaffold(
        backgroundColor: Color(0xFF212128),
        appBar: AppBar(
          backgroundColor: Color(0xFF484850),
          elevation: 0,
          centerTitle: true,
          title: Text('Programs'),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _programs.length > 0
                ? ProgramList(
                    programs: _programs,
                    deleteProgram: _deleteProgram,
                  )
                : StartText(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _newProgram,
          child: Icon(Icons.add),
          elevation: 0,
          backgroundColor: Color(0xFFD37C7C),
        ),
      ),
    );
  }
}
