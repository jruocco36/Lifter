import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/program.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/home/program/program_list.dart';
import 'package:Lifter/screens/home/program/program_settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    void _newProgramPanel() {
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
                child: ProgramSettingsForm(),
              ),
            ),
          );
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
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Log out'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            // FlatButton.icon(
            //   icon: Icon(Icons.settings),
            //   label: Text('settings'),
            //   onPressed: () => _showSettingsPanel(),
            // ),
          ],
        ),
        body: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/coffee_bg.png'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: ProgramList(),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          child: Icon(Icons.add),
          onPressed: () => _newProgramPanel(),
        ),
      ),
    );
  }
}
