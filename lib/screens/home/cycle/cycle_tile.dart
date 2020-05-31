import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/cycle_home.dart';
import 'package:Lifter/screens/home/cycle/cycle_settings_form.dart';
import 'package:Lifter/screens/home/cycle/next_cycle.dart';
import 'package:Lifter/screens/home/delete_dialog.dart';
import 'package:Lifter/screens/home/week/week_list.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: animation when deleting item
//       https://www.youtube.com/watch?v=ZtfItHwFlZ8

class CycleTile extends StatefulWidget {
  final Cycle cycle;
  final Function cycleHome;

  CycleTile({this.cycle, this.cycleHome});

  @override
  _CycleTileState createState() => _CycleTileState();
}

class _CycleTileState extends State<CycleTile>
    with SingleTickerProviderStateMixin {
  // bool showWeekDrawer = false;
  // double maxHeight = 0.0;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Card(
            // elevation: showWeekDrawer ? 10 : 0,
            elevation: 0,
            // color: lightGreyColor,
            color: Colors.transparent,
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: OpenContainer(
                transitionType: ContainerTransitionType.fade,
                transitionDuration: Duration(milliseconds: 250),
                openBuilder: (BuildContext _, VoidCallback openContainer) {
                  return CycleHome(cycle: widget.cycle);
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
                        PopupMenuItem(
                          value: 'Next cycle',
                          child: new Text('Next cycle'),
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
                        } else if (val == 'Next cycle') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NextCycle(
                                oldCycle: widget.cycle,
                              ),
                            ),
                          );
                          // NextCycle();
                        }
                      },
                    ),
                    onTap: () {
                      if (_animationController.isAnimating ||
                          _animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                    },
                    onLongPress: () {
                      openContainer();
                    },
                  );
                }),
          ),

          // Week drawer
          AnimatedBuilder(
            animation: _animationController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .55,
                    minWidth: double.infinity,
                  ),
                  margin: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: StreamProvider<List<Week>>.value(
                    initialData: [
                      Week(
                        weekId: 'loading',
                        cycle: null,
                        startDate: null,
                        endDate: null,
                        weekName: null,
                      )
                    ],
                    value: DatabaseService(uid: widget.cycle.program.uid)
                        .getWeeks(widget.cycle),
                    child: WeekList(weekDrawer: true),
                    // visibility is causing bug
                    // after returning from week home, animation is still 'open'
                    // but visibility is off. this causes values for visibility
                    // to be reversed
                    // child: Visibility(
                    //   visible: _animationController.isDismissed,
                    //   child: WeekList(weekDrawer: true),
                    // ),
                  ),
                ),
              ],
            ),
            builder: (BuildContext context, Widget child) {
              return SizeTransition(
                  axis: Axis.vertical,
                  sizeFactor: CurvedAnimation(
                      curve: Curves.fastOutSlowIn,
                      parent: _animationController),
                  child: child);
            },
          )
        ],
      ),
    );
  }
}
