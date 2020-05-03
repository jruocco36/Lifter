import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/week/week_tile.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:Lifter/shared/startText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekList extends StatefulWidget {
  final bool weekDrawer;

  WeekList({@required this.weekDrawer});

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
    if (weeks.length > 0 && weeks[0].weekId == 'loading')
      return Loading(showBackground: !widget.weekDrawer);
    return weeks.length < 1
        ? (widget.weekDrawer
            ? Text(
                'No weeks for this cycle',
                style: TextStyle(
                  fontSize: 16,
                  color: greyTextColor,
                ),
              )
            : StartText())
        : ListView.builder(
            itemCount: weeks.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: widget.weekDrawer
                ? EdgeInsets.only(top: 5.0)
                : EdgeInsets.only(top: 10.0),
            itemBuilder: (context, index) {
              return WeekTile(
                  week: weeks[index], weekDrawer: widget.weekDrawer);
            },
          );
  }
}
