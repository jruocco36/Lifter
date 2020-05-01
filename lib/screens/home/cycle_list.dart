import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/screens/home/cycle_tile.dart';
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
    return ListView.builder(
      itemCount: cycles.length,
      padding: EdgeInsets.only(top: 10.0),
      itemBuilder: (context, index) {
        return CycleTile(cycle: cycles[index]);
      },
    );
  }
}
