import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './firebase.dart';
import './global.dart';
import './newProgramDialog.dart';
import './programData.dart';
import './programBox.dart';

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
  final DataRepository repository = DataRepository();
  Map<DocumentReference, Program> _programs = {};

  void _newProgram(String name, String baseType, String progressType) {
    setState(() {
      Program program = Program(
          name: name,
          baseType: baseType,
          progressType: progressType);
      repository.addProgram(program);
    });
  }

  void _deleteProgram(DocumentReference reference) {
    setState(() {
      repository.deleteProgram(reference);
    });
  }

  List<String> _programNames() {
    List<String> names = [];
    _programs.entries.forEach((e) => names.add(e.value.name));
    return names;
  }

  Program _getProgram(DocumentReference key) {
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
        body: _buildBody(context),
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

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: repository.getStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final program = Program.fromSnapshot(data);
    _programs[program.reference] = program;

    return Column(
      children: [
        ProgramBox(
          programName: program.name,
          programKey: program.reference,
          getProgram: _getProgram,
          deleteProgram: _deleteProgram,
        ),
      ],
    );
  }
}
