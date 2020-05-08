import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/program/program_home.dart';
import 'package:Lifter/screens/home/program/program_settings_form.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ProgramTile extends StatelessWidget {
  final Program program;
  final Function programHome;

  ProgramTile({this.program, this.programHome});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Tooltip(
        message: '${program.name}',
        child: Card(
          color: lightGreyColor,
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: OpenContainer(
              transitionType: ContainerTransitionType.fade,
              transitionDuration: Duration(milliseconds: 250),
              openBuilder: (BuildContext _, VoidCallback openContainer) {
                return ProgramHome(program: program);
              },
              tappable: false,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              closedElevation: 0.0,
              closedColor: lightGreyColor,
              openColor: darkGreyColor,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return ListTile(
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
                    openContainer();
                  },
                );
              }),
        ),
      ),
    );
  }
}
