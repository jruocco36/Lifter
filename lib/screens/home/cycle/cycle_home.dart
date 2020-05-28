import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/cycle.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/models/week.dart';
import 'package:Lifter/screens/home/cycle/cycle_settings_form.dart';
import 'package:Lifter/screens/home/week/week_list.dart';
import 'package:Lifter/screens/home/week/week_settings_form.dart';
import 'package:Lifter/screens/home/user/user_settings_drawer.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CycleHome extends StatelessWidget {
  final Cycle cycle;

  CycleHome({this.cycle});

  @override
  Widget build(BuildContext context) {
    void _editCyclePanel() {
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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 60.0),
                child: CycleSettingsForm(
                  program: cycle.program,
                  cycleId: cycle.cycleId,
                ),
              ),
            ),
          );
        },
      );
    }

    void _newWeekPanel(List<Week> weeks) {
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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 60.0),
                child: WeekSettingsForm(cycle: cycle, weeks: weeks),
              ),
            ),
          );
        },
      );
    }

    // listen for any changes to 'cycles' collection stored DatabaseService
    return StreamBuilder<Cycle>(
        stream: DatabaseService(uid: cycle.program.uid)
            .getCycleData(cycle.program, cycle.cycleId),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Loading();
          // }

          Cycle cycleUpdates;
          snapshot.hasData
              ? cycleUpdates = snapshot.data
              : cycleUpdates = cycle;
          return StreamProvider<List<Week>>.value(
            value: DatabaseService(uid: cycle.program.uid).getWeeks(cycle),
            child: Builder(
              builder: (context) {
                List<Week> weeks = Provider.of<List<Week>>(context);
                // print(weeks);
                return Scaffold(
                  appBar: AppBar(
                    title: Text('${cycleUpdates.name}'),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    elevation: 0.0,
                    actions: <Widget>[
                      Builder(
                        builder: (context) => PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          color: darkGreyColor,
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'Edit',
                              child: new Text('Edit cycle'),
                            ),
                            PopupMenuItem(
                              value: 'Settings',
                              child: new Text('Settings'),
                            ),
                          ],
                          onSelected: (val) async {
                            if (val == 'Edit') {
                              _editCyclePanel();
                            } else if (val == 'Settings') {
                              Scaffold.of(context).openDrawer();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  body: WeekList(weekDrawer: false),
                  floatingActionButton: FloatingActionButton(
                    elevation: 0,
                    child: Icon(Icons.add),
                    onPressed: () => _newWeekPanel(weeks),
                  ),
                  drawer: UserSettingsDrawer(
                    user: Provider.of<User>(context),
                  ),
                );
              },
            ),
          );
        });
  }
}
