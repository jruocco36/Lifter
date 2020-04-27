import 'package:flutter/material.dart';

import './global.dart';
import './programList.dart';
import './startText.dart';
import './newProgramDialog.dart';
import './programData.dart';

// TODO: cycles not being saved after leaving program home page
//  need to add data class to hold program and cycle info in Main.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifter',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: darkGreyColor,
        primaryColor: lightGreyColor,
        primaryColorLight: lightGreyColor,
        accentColor: flamingoColor,
        textTheme: TextTheme(
          display1: TextStyle(
            color: whiteTextColor,
          ),
          body1: TextStyle(
            color: whiteTextColor,
          ),
          body2: TextStyle(
            color: whiteTextColor,
          ),
          button: TextStyle(
            color: whiteTextColor,
          ),
        ),
      ),
      home: MyHomePage(title: 'Programs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, Program> _programs = {};
  var _programIndex = 1;

  void _newProgram(String name, String baseType, String progressType) {
    if (_programs.length > 0)
      _programIndex = _programs.keys.last + 1;
    else
      _programIndex = 1;
    setState(() {
      Program program = new Program(
          id: _programIndex,
          name: name,
          baseType: baseType,
          progressType: progressType);
      _programs[_programIndex] = program;
    });
  }

  void _deleteProgram(int key) {
    setState(() {
      _programs.remove(key);
    });
  }

  Program _getProgram(int key) {
    return _programs[key];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: lightGreyColor,
        primaryColorLight: lightGreyColor,
        primaryColorDark: primaryDarkColor,
        accentColor: flamingoColor,
        hintColor: greyTextColor,
        textTheme: TextTheme(
          body1: TextStyle(
            color: whiteTextColor,
          ),
          body2: TextStyle(
            color: whiteTextColor,
          ),
          button: TextStyle(
            color: whiteTextColor,
          ),
        ),
        canvasColor: darkGreyColor,
      ),
      // Scaffold() is helper widget to create base page design for app
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('Programs'),
        ),
        body: Column(
          children: [
            _programs.length > 0
                ? ProgramList(
                    programs: _programs.map((id, program) {
                      return MapEntry(id, program.name);
                    }),
                    deleteProgram: _deleteProgram,
                    getProgram: _getProgram,
                  )
                : StartText(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return NewProgramDialog(
                  newProgram: _newProgram,
                  programNames: (_programs.keys).map((program) {
                    return _programs[program].name;
                  }).toList(),
                );
              },
            );
          },
          child: Icon(Icons.add),
          elevation: 0,
          backgroundColor: flamingoColor,
        ),
      ),
    );
  }
}
