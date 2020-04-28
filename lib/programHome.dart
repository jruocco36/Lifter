import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './global.dart';
import './startText.dart';
import './cycleBox.dart';
import './cycleList.dart';
import './newCycleDialog.dart';
import './programData.dart';

// TODO: cyles not updating in set state
//     : cycle listed in reverse order

class ProgramHome extends StatefulWidget {
  final Program program;
  final String programName;

  ProgramHome({
    @required this.programName,
    @required this.program,
  });

  @override
  _ProgramHomeState createState() => _ProgramHomeState();
}

class _ProgramHomeState extends State<ProgramHome> {
  Map<DocumentReference, String> _cycleNames = {};

  void initState() {
    super.initState();
    getCycles();
    // widget.program
    //     .getCycles()
    //     .forEach((e) => _cycleNames[e.reference] = e.name);
  }

  Future getCycles() async {
    await widget.program
        .getCycles()
        .forEach((e) => _cycleNames[e.reference] = e.name);
  }

  void addCycle(String name, DateTime startDate, int tmPercent) {
    setState(() {
      widget.program.addCycle(name, startDate, tmPercent);
    });
  }

  void _deleteCycle(DocumentReference ref) {
    setState(() {
      widget.program.deleteCycle(ref);
      // _cycleNames.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programName),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: <Widget>[
          ...(widget.program.cycles.keys).map((cycle) {
            return CycleBox(
                widget.program.cycles[cycle].name, cycle, _deleteCycle);
          }).toList()
        ],
        // children: [
        //   _cycleNames.length > 0
        //       ? CycleList(
        //           cycles: _cycleNames,
        //           deleteCycle: _deleteCycle,
        //         )
        //       : StartText(),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return NewCycleDialog(
                  addCycle: addCycle,
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

  Widget _cycles(BuildContext context) {
    return CycleList(
      cycles: _cycleNames,
      deleteCycle: _deleteCycle,
    );
  }
}
