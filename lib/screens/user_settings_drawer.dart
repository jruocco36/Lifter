import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/authenticate/authenticate.dart';
import 'package:Lifter/screens/wrapper.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';

class UserSettingsDrawer extends StatefulWidget {
  final User user;

  UserSettingsDrawer({@required this.user});

  @override
  _UserSettingsDrawerState createState() => _UserSettingsDrawerState();
}

class _UserSettingsDrawerState extends State<UserSettingsDrawer> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email),
            accountName: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: flamingoColor,
              child: Text(
                widget.user.email.substring(0, 1),
              ),
            ),
            // onDetailsPressed: () {},// ),
          ),
          ListTile(
            title: Text('Edit exercises'),
            leading: Icon(Icons.settings),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Submit feedback'),
            leading: Icon(Icons.feedback),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Sign out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Wrapper()),
                  (Route route) => false);
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
