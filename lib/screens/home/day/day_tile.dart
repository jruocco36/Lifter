import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/day.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/day/day_home.dart';
// import 'package:Lifter/screens/home/day/day_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
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
        color: lightGreyColor,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(day.dayName),
          subtitle: Text('${DateFormat('MM/dd/yyyy').format(day.date)}'),
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
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 60.0),
                          // child: DaySettingsForm(
                          //   cycle: day.cycle,
                          //   dayId: day.dayId,
                          // ),
                        ),
                      ),
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
                  DatabaseService(uid: day.week.cycle.program.uid).deleteDay(
                      day.week.cycle.program.programId,
                      day.week.cycle.cycleId,
                      day.week.weekId,
                      day.dayId);
                }
              }
            },
          ),
          onTap: () {
            // print(day.dayName);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DayHome(day: day),
              ),
            );
          },
        ),
      ),
    );
  }
}
