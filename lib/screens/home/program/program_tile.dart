import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/program/program_home.dart';
import 'package:Lifter/screens/home/program/program_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';

class ProgramTile extends StatelessWidget {
  final Program program;
  final Function programHome;

  ProgramTile({this.program, this.programHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Card(
        color: lightGreyColor,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(program.name),
          subtitle: Text('${program.programType}'),
          leading: Icon(program.programType == 'Cycle based'
              ? Icons.autorenew
              : Icons.calendar_today),
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
                          child: ProgramSettingsForm(
                              programId: program.programId),
                        ),
                      ),
                    );
                  },
                );
              } else if (val == 'Delete') {
                final delete = await showDialog(
                    context: context,
                    builder: (_) {
                      return DeleteDialog(program.name);
                    });
                if (delete) {
                  DatabaseService(uid: program.uid)
                      .deleteProgram(program.programId);
                }
              }
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProgramHome(
                  program: program,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
