import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/week.dart';
// import 'package:Lifter/screens/home/week_home.dart';
// import 'package:Lifter/screens/home/week_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/week/week_home.dart';
import 'package:Lifter/screens/home/week/week_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TODO: display icon for each day in week

class WeekTile extends StatelessWidget {
  final Week week;
  final bool weekDrawer;

  WeekTile({this.week, this.weekDrawer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: weekDrawer ?
      EdgeInsets.only(top: 0.0) :
      EdgeInsets.only(top: 10.0),
      child: Card(
        color: lightGreyColor,
        margin: weekDrawer
            ? EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0)
            : EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(week.weekName, overflow: TextOverflow.ellipsis),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${DateFormat('EEE - MM/dd/yyyy').format(week.startDate)}'),
              if (week.days != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Monday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('M', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Tuesday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('T', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Wednesday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('W', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Thursday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('T', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Friday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('F', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Saturday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('S', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3, right: 3, top: 3),
                      width: 25,
                      height: 25,
                      decoration: week.days['Sunday']
                          ? BoxDecoration(
                              border:
                                  Border.all(width: 1, color: flamingoColor),
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('S', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
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
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 60.0),
                          child: WeekSettingsForm(
                            cycle: week.cycle,
                            weekId: week.weekId,
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
                      return DeleteDialog(week.weekName);
                    });
                if (delete) {
                  DatabaseService(uid: week.cycle.program.uid).deleteWeek(
                      week.cycle.program.programId,
                      week.cycle.cycleId,
                      week.weekId);
                }
              }
            },
          ),
          onTap: () {
            // print(week.weekName);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WeekHome(week: week),
              ),
            );
          },
        ),
      ),
    );
  }
}
