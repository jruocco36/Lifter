import 'package:Lifter/models/day.dart';
import 'package:Lifter/screens/home/day/day_tile.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:Lifter/shared/startText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayList extends StatefulWidget {
  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  @override
  Widget build(BuildContext context) {
    // grab current list of days from DatabaseService through provider
    // provider is StreamProvider from the parent 'Home' widget that is
    // listening to changes to the DatabaseService 'days' collection stream
    final days = Provider.of<List<Day>>(context) ?? [];

    // iterates through our list and creates an array of widgets with
    // one widget for each item
    // if (days.length > 0 && days[0].dayId == 'loading') return Loading();
    return days.length < 1
        ? StartText()
        : ListView.builder(
            itemCount: days.length,
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            padding: EdgeInsets.only(top: 10.0, bottom: 100),
            itemBuilder: (context, index) {
              return DayTile(day: days[index]);
            },
          );
  }
}
