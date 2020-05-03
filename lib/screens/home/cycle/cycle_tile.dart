import 'dart:math';

import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/cycle_home.dart';
import 'package:Lifter/screens/home/cycle/cycle_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/week/week_list.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: animate when clicking item from week drawer
// TODO: animation when deleting item
//       https://www.youtube.com/watch?v=ZtfItHwFlZ8

class CycleTile extends StatefulWidget {
  final Cycle cycle;
  final Function cycleHome;

  CycleTile({this.cycle, this.cycleHome});

  @override
  _CycleTileState createState() => _CycleTileState();
}

class _CycleTileState extends State<CycleTile> {
  bool showWeekDrawer = false;
  double maxHeight = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: showWeekDrawer ? 10 : 0,
            color: lightGreyColor,
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              title: Text(widget.cycle.name),
              subtitle: Text(
                  '${DateFormat('EEE - MM/dd/yyyy').format(widget.cycle.startDate)}'),
              // leading: ,
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                color: darkGreyColor,
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'Edit',
                    child: new Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 'Delete',
                    child: new Text('Delete'),
                  ),
                ],
                onSelected: (val) async {
                  if (val == 'Edit') {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 60.0),
                              child: CycleSettingsForm(
                                program: widget.cycle.program,
                                cycleId: widget.cycle.cycleId,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (val == 'Delete') {
                    final delete = await showDialog(
                        context: context,
                        builder: (_) {
                          return DeleteDialog(widget.cycle.name);
                        });
                    if (delete) {
                      DatabaseService(uid: widget.cycle.program.uid)
                          .deleteCycle(widget.cycle.program.programId,
                              widget.cycle.cycleId);
                    }
                  }
                },
              ),
              onTap: () {
                setState(() {
                  showWeekDrawer = !showWeekDrawer;
                  if (showWeekDrawer) {
                    maxHeight = MediaQuery.of(context).size.height * .55;
                  } else {
                    maxHeight = 0.0;
                  }
                });
              },
              onLongPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CycleHome(
                      cycle: widget.cycle,
                    ),
                  ),
                );
              },
            ),
          ),

          // Week drawer
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
            constraints: BoxConstraints(maxHeight: maxHeight),
            margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
            alignment: Alignment.center,
            // padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: showWeekDrawer
                ? StreamProvider<List<Week>>.value(
                    initialData: [
                      Week(
                        weekId: 'loading',
                        cycle: null,
                        startDate: null,
                        weekName: null,
                      )
                    ],
                    value: DatabaseService(uid: widget.cycle.program.uid)
                        .getWeeks(widget.cycle),
                    child: WeekList(weekDrawer: true),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
