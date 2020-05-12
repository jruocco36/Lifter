import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/screens/home/day/day_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/day/day_home.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayTile extends StatelessWidget {
  final Day day;

  DayTile({this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        // color: lightGreyColor,
        color: Colors.transparent,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            transitionDuration: Duration(milliseconds: 250),
            openBuilder: (BuildContext _, VoidCallback openContainer) {
              return DayHome(day: day);
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
                title: Text(day.dayName),
                subtitle: Text(
                  '${DateFormat('EEE - MM/dd/yyyy').format(day.date)}',
                  style:
                      DateTime(day.date.year, day.date.month, day.date.day) ==
                              DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day)
                          ? TextStyle(color: Colors.green[300])
                          : null,
                ),
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
                      value: 'Delay',
                      child: new Text('Delay'),
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 60.0),
                                child: DaySettingsForm(
                                  week: day.week,
                                  dayId: day.dayId,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (val == 'Delay') {
                      int duration = 0;
                      showDialog(
                        context: context,
                        builder: (_) {
                          // TODO: only accept positive/negative integers
                          return AlertDialog(
                            backgroundColor: darkGreyColor,
                            content: TextFormField(
                              autofocus: true,
                              decoration:
                                  InputDecoration(hintText: 'Number of days'),
                              onChanged: (val) {
                                duration = int.parse(val);
                              },
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text('Submit'),
                                color: flamingoColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (duration != 0) {
                                    DatabaseService(
                                            uid: day.week.cycle.program.uid)
                                        .delayProgram(day, duration);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if (val == 'Delete') {
                      final delete = await showDialog(
                          context: context,
                          builder: (_) {
                            return DeleteDialog(day.dayName);
                          });
                      if (delete) {
                        DatabaseService(uid: day.week.cycle.program.uid)
                            .deleteDay(day);
                      }
                    }
                  },
                ),
                onTap: () {
                  openContainer();

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DayHome(day: day),
                  //   ),
                  // );
                },
              );
            }),
      ),
    );
  }
}
