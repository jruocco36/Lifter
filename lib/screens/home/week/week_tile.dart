import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/week.dart';
// import 'package:Lifter/screens/home/week_home.dart';
// import 'package:Lifter/screens/home/week_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/week/week_home.dart';
import 'package:Lifter/screens/home/week/week_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeekTile extends StatelessWidget {
  final Week week;
  final bool weekDrawer;

  WeekTile({this.week, this.weekDrawer});

  @override
  Widget build(BuildContext context) {
    final weeks = Provider.of<List<Week>>(context) ?? [];

    return Padding(
      padding: weekDrawer
          ? EdgeInsets.only(top: 0.0, bottom: 6.0)
          : EdgeInsets.only(top: 10.0),
      child: Tooltip(
        message: '${week.weekName}',
        child: Card(
          // color: lightGreyColor,
          color: Colors.transparent,
          margin: weekDrawer
              ? EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0)
              : EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          // BUG: contents are shifting to top of card during animation
          //      turning off three lines seems to fix
          child: OpenContainer(
              transitionType: ContainerTransitionType.fade,
              transitionDuration: Duration(milliseconds: 250),
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return WeekHome(week: week);
              },
              tappable: false,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              closedElevation: 0.0,
              closedColor: lightGreyColor,
              openColor: darkGreyColor,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return ListTile(
                  title: Text(week.weekName, overflow: TextOverflow.ellipsis),
                  isThreeLine: true,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          '${DateFormat('EEE - MM/dd/yyyy').format(week.startDate)}'),
                      if (week.days != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Monday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Tuesday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Wednesday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Thursday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Friday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Saturday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                              margin:
                                  EdgeInsets.only(left: 3, right: 3, top: 6),
                              width: 25,
                              height: 25,
                              decoration: week.days['Sunday'] != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: flamingoColor),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 60.0),
                                  child: WeekSettingsForm(
                                    cycle: week.cycle,
                                    weekId: week.weekId,
                                    weeks: weeks ?? [],
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
                          DatabaseService(uid: week.cycle.program.uid)
                              .deleteWeek(week.cycle.program.programId,
                                  week.cycle.cycleId, week.weekId);
                        }
                      }
                    },
                  ),
                  onTap: () {
                    openContainer();

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => WeekHome(week: week),
                    //   ),
                    // );
                  },
                );
              }),
        ),
      ),
    );
  }
}
