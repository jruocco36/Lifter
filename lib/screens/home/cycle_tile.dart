import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/screens/home/cycle_settings_form.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CycleTile extends StatelessWidget {
  final Cycle cycle;
  final Function cycleHome;

  CycleTile({this.cycle, this.cycleHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        color: lightGreyColor,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(cycle.name),
          subtitle: Text('${DateFormat('MM/dd/yyyy').format(cycle.startDate)}'),
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
                          child: CycleSettingsForm(
                            programDocumentId: cycle.programId,
                            cycleDocumentId: cycle.cycleId,
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
                      return DeleteDialog(cycle.name);
                    });
                if (delete) {
                  DatabaseService(uid: cycle.uid)
                      .deleteCycle(cycle.programId, cycle.cycleId);
                }
              }
            },
          ),
          onTap: () {
            print(cycle.name);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CycleHome(
            //       cycle: cycle,
            //     ),
            //   ),
            // );
          },
        ),
      ),
    );
  }
}
