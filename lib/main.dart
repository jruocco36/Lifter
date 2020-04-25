import 'package:flutter/material.dart';
// import 'package:test_app1/newProgramButton.dart';

import './global.dart';
import './programList.dart';
import './startText.dart';
import './newProgramDialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Program creator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, String> _programNames = {};
  var _programIndex = 1;

  void _newProgram(String name, String type) {
    if (_programNames.length > 0)
      _programIndex = _programNames.keys.last + 1;
    else
      _programIndex = 1;
    setState(() {
      _programNames[_programIndex] = name;
    });
  }

  void _deleteProgram(int key) {
    setState(() {
      _programNames.remove(key);
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
            _programNames.length > 0
                ? ProgramList(
                    programs: _programNames,
                    deleteProgram: _deleteProgram,
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
                  programNames: (_programNames.keys).map((program) {
                    return _programNames[program];
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
