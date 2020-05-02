import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/week/week_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekList extends StatefulWidget {
  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  @override
  Widget build(BuildContext context) {
    // grab current list of weeks from DatabaseService through provider
    // provider is StreamProvider from the parent 'Home' widget that is
    // listening to changes to the DatabaseService 'weeks' collection stream
    final weeks = Provider.of<List<Week>>(context) ?? [];

    // iterates through our list and creates an array of widgets with
    // one widget for each item
    return ListView.builder(
      itemCount: weeks.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10.0),
      itemBuilder: (context, index) {
        return WeekTile(week: weeks[index]);
      },
    );
  }
}
