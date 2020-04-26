import 'package:flutter/material.dart';

import './global.dart';
import './startText.dart';
import './cycleList.dart';
import './newCycleDialog.dart';

// TODO: store start date and TM percent

class ProgramHome extends StatefulWidget {
  final String programName;
  List<Cycle> cycles;

  ProgramHome({
    @required this.programName,
  });

  @override
  _ProgramHomeState createState() => _ProgramHomeState();
}

class _ProgramHomeState extends State<ProgramHome> {
  Map<int, String> _cycleNames = {};
  var _cycleIndex = 1;

  void _newCycle(String name, String type) {
    if (_cycleNames.length > 0)
      _cycleIndex = _cycleNames.keys.last + 1;
    else
      _cycleIndex = 1;
    setState(() {
      _cycleNames[_cycleIndex] = name;
    });
  }

  void _deleteCycle(int key) {
    setState(() {
      _cycleNames.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programName),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _cycleNames.length > 0
              ? CycleList(
                  cycles: _cycleNames,
                  deleteCycle: _deleteCycle,
                )
              : StartText(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return NewCycleDialog(
                  newCycle: _newCycle,
                  cycleNames: (_cycleNames.keys).map((program) {
                    return _cycleNames[program];
                  }).toList(),
                );
              });
        },
        child: Icon(Icons.add),
        elevation: 0,
        backgroundColor: flamingoColor,
      ),
    );
  }
}

class Cycle {
  String name;
  DateTime startDate;
  int trainingMaxPercent;
}