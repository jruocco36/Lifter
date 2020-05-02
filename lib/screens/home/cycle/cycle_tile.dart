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
import 'package:overlay_container/overlay_container.dart';
import 'package:provider/provider.dart';

// TODO: animate week drawer
// TODO: use overlay widget to display weeks over other cycles

class CycleTile extends StatefulWidget {
  final Cycle cycle;
  final Function cycleHome;

  CycleTile({this.cycle, this.cycleHome});

  @override
  _CycleTileState createState() => _CycleTileState();
}

class _CycleTileState extends State<CycleTile> {
  bool weekDrawer = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: weekDrawer ? 4 : 0,
            color: lightGreyColor,
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              title: Text(widget.cycle.name),
              subtitle: Text(
                  '${DateFormat('MM/dd/yyyy').format(widget.cycle.startDate)}'),
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
                                programId: widget.cycle.programId,
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
                      DatabaseService(uid: widget.cycle.uid).deleteCycle(
                          widget.cycle.programId, widget.cycle.cycleId);
                    }
                  }
                },
              ),
              onTap: () {
                setState(() => weekDrawer = !weekDrawer);

                // print(cycle.name);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => CycleHome(
                //         cycle: cycle,
                //       ),
                //     ),
                //   );
              },
              onLongPress: () {
                // print(cycle.name);
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
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: OverlayContainer(
              show: weekDrawer,
              asWideAsParent: true,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: greyTextColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: StreamProvider<List<Week>>.value(
                  value: DatabaseService(uid: widget.cycle.uid)
                      .getWeeks(widget.cycle),
                  child: WeekList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
