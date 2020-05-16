import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/home/log_bodyweight_form.dart';
import 'package:Lifter/screens/home/program/program_list.dart';
import 'package:Lifter/screens/home/program/program_settings_form.dart';
import 'package:Lifter/screens/home/user_settings_drawer.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _newProgramPanel() {
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
                child: ProgramSettingsForm(),
              ),
            ),
          );
        },
      );
    }

    Widget _settingsButton() {
      return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        color: darkGreyColor,
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'bodyweight',
            child: new Text('Log bodyweight'),
            textStyle: TextStyle(fontSize: 14),
          ),
          PopupMenuItem(
            value: 'logout',
            child: new Text('Sign out'),
            textStyle: TextStyle(fontSize: 14),
          ),
        ],
        onSelected: (val) async {
          if (val == 'bodyweight') {
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
                      child: BodyweightForm(),
                    ),
                  ),
                );
              },
            );
          } else if (val == 'logout') {
            await _auth.signOut();
          }
        },
      );
    }

    // listen for any changes to 'program' collection stored DatabaseService
    return StreamProvider<List<Program>>.value(
      initialData: [
        Program(
            programId: 'loading',
            createdDate: null,
            name: null,
            programType: null,
            progressType: null,
            uid: null)
      ],
      value: DatabaseService(uid: user.uid).programs,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Programs'),
          elevation: 0.0,
          // actions: <Widget>[
          //   _settingsButton(),
          // ],
        ),
        body: Container(
          child: ProgramList(),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.add),
          onPressed: () => _newProgramPanel(),
        ),
        drawer: UserSettingsDrawer(user: user),
      ),
    );
  }
}
