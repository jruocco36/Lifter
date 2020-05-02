import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/week.dart';
// import 'package:Lifter/screens/home/week_home.dart';
// import 'package:Lifter/screens/home/week_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/week/week_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekTile extends StatelessWidget {
  final Week week;

  WeekTile({this.week});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        color: lightGreyColor,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(week.weekName),
          subtitle: Text('${DateFormat('MM/dd/yyyy').format(week.startDate)}'),
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
                  DatabaseService(uid: week.cycle.uid).deleteWeek(
                      week.cycle.programId, week.cycle.cycleId, week.weekId);
                }
              }
            },
          ),
          onTap: () {
            print(week.weekName);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => WeekHome(
            //       week: week,
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
