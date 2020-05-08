import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/screens/home/cycle/cycle_tile.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:Lifter/shared/startText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CycleList extends StatefulWidget {
  @override
  _CycleListState createState() => _CycleListState();
}

class _CycleListState extends State<CycleList> {
  @override
  Widget build(BuildContext context) {
    // grab current list of cycles from DatabaseService through provider
    // provider is StreamProvider from the parent 'Home' widget that is
    // listening to changes to the DatabaseService 'cycles' collection stream
    final cycles = Provider.of<List<Cycle>>(context) ?? [];

    // iterates through our list and creates an array of widgets with
    // one widget for each item
    if (cycles.length > 0 && cycles[0].cycleId == 'loading') return Loading();
    return cycles.length < 1
        ? StartText()
        : ListView.builder(
            itemCount: cycles.length,
            padding: EdgeInsets.only(top: 10.0, bottom: 100),
            itemBuilder: (context, index) {
              return CycleTile(cycle: cycles[index]);
            },
          );
  }
}
