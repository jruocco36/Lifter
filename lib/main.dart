import 'package:flutter/material.dart';
import 'package:test_app1/newProgramButton.dart';

import './programList.dart';
import './startText.dart';
import './newProgramButton.dart';

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
  var _programIndex = 1;
  TextEditingController _textFieldController = TextEditingController();
  String _dropdownValue = 'Cycle based';

  void _dropdownValueChanged(String newValue) {
    setState(() {
      _dropdownValue = newValue;
    });
  }

  void _newProgram() {
    //_showDialog();

    if (_programs.length > 0)
      _programIndex = _programs.keys.last + 1;
    else
      _programIndex = 1;
    setState(() {
      _programs[_programIndex] = _textFieldController.text;
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
      theme: ThemeData(
        primaryColor: Color(0xFF484850),
        primaryColorLight: Color(0xFF484850),
        primaryColorDark: Color(0xFF000000),
        accentColor: Color(0xFFd37c7c),
        // hintColor: Color(0xFF484850),
        textTheme: TextTheme(
          body1: TextStyle(
            color: Color(0xFFffffff),
          ),
          body2: TextStyle(
            color: Color(0xFFffffff),
          ),
          button: TextStyle(
            color: Color(0xFFffffff),
          ),
        ),
        // backgroundColor: Color(0xFF212128),
        canvasColor: Color(0xFF212128),
      ),
      // theme: ThemeData(),
      // Scaffold() is helper widget to create base page design for app
      home: Scaffold(
        // backgroundColor: Color(0xFF212128),
        appBar: AppBar(
          // backgroundColor: Color(0xFF484850),
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
        floatingActionButton: NewProgramButton(
          textFieldController: _textFieldController,
          dropdownValue: _dropdownValue,
          dropdownValueChanged: _dropdownValueChanged,
          newProgram: _newProgram,
          programNames: (_programs.keys).map((program) {
            return _programs[program];
          }).toList(),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _newProgram,
        //   child: Icon(Icons.add),
        //   elevation: 0,
        //   backgroundColor: Color(0xFFD37C7C),
        // ),
      ),
    );
  }
}
