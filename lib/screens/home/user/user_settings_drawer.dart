import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/home/user/feedback.dart';
import 'package:Lifter/screens/home/user/log_bodyweight_form.dart';
import 'package:Lifter/screens/home/user/user_form.dart';
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
    if (widget.user != null) {
      return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail:
                  widget.user.email != null ? Text(widget.user.email) : null,
              accountName:
                  widget.user.name != null ? Text(widget.user.name) : null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: flamingoColor,
                child: Text(
                  widget.user.name.substring(0, 1),
                ),
              ),
              // onDetailsPressed: () {},// ),
            ),
            ListTile(
              title: Text('Edit profile'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => UserForm(user: widget.user));
              },
            ),
            ListTile(
              title: Text('Edit exercises'),
              leading: Icon(Icons.fitness_center),
              onTap: () {
                // TODO: edit exercises page
              },
            ),
            ListTile(
              title: Text('Log bodyweight'),
              leading: Icon(Icons.assessment),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BodyweightForm(user: widget.user));
              },
            ),
            ListTile(
              title: Text('Submit feedback'),
              leading: Icon(Icons.feedback),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => FeedbackForm(user: widget.user));
              },
            ),
            ListTile(
              title: Text('Sign out'),
              leading: Icon(Icons.exit_to_app),
              onTap: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Wrapper()),
                    (Route route) => false);
                await _auth.signOut();
              },
            ),
          ],
        ),
      );
    } else {
      return Text('NO USER');
    }
  }
}
