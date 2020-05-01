import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    // can grab user id from StreamProvider of parent widgets
    // (main > Home > SettingsForm)
    final user = Provider.of<User>(context);

    // When you only need to listen to stream data in one widget, using
    // StreamBuilder is simpler than using StreamProvider. StreamProvider
    // is better for when you need to pass stream data to multiple widgets
    // by accessing Provider.of<DataType>(context)
    // return StreamBuilder<UserProgramData>(
    //   // set listening stream to user data stream from DatabaseService
    //   stream: DatabaseService(uid: user.uid).userData,
    //   builder: (context, snapshot) {
    //     // snapshot is the data coming in from the stream
    //     if (snapshot.hasData) {
    //       UserProgramData userData = snapshot.data;

    //       return Form(
    //         key: _formKey,
    //         child: Column(
    //           children: <Widget>[
    //             Text(
    //               'Update your brew settings',
    //               style: TextStyle(fontSize: 18.0),
    //             ),
    //             SizedBox(height: 20.0),
    //             TextFormField(
    //               initialValue: userData.name,
    //               decoration: textInputDecoration.copyWith(hintText: 'Name'),
    //               validator: (val) =>
    //                   val.isEmpty ? 'Please enter a name' : null,
    //               onChanged: (val) => setState(() => _currentName = val),
    //             ),
    //             SizedBox(height: 20.0),
    //             // dropdown
    //             DropdownButtonFormField(
    //               decoration: textInputDecoration,
    //               isDense: true,
    //               value: _currentSugars ?? userData.sugars,
    //               items: sugars.map((sugar) {
    //                 return DropdownMenuItem(
    //                   value: sugar,
    //                   child: Text('$sugar sugars'),
    //                 );
    //               }).toList(),
    //               onChanged: (val) => setState(() => _currentSugars = val),
    //             ),
    //             // slider
    //             Slider(
    //               value: (_currentStrength ?? userData.strength).toDouble(),
    //               min: 100.0,
    //               max: 900.0,
    //               divisions: 8, // (900-100/)100 = 8  -- increments of 100
    //               activeColor:
    //                   Colors.brown[_currentStrength ?? userData.strength],
    //               inactiveColor:
    //                   Colors.brown[_currentStrength ?? userData.strength],
    //               onChanged: (val) =>
    //                   setState(() => _currentStrength = val.round()),
    //             ),
    //             RaisedButton(
    //               color: Colors.pink[400],
    //               child: Text(
    //                 'Update',
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //               onPressed: () async {
    //                 if (_formKey.currentState.validate()) {
    //                   await DatabaseService(uid: user.uid).updateUserData(
    //                     _currentSugars ?? userData.sugars,
    //                     _currentName ?? userData.name,
    //                     _currentStrength ?? userData.strength,
    //                   );
    //                   Navigator.pop(context);
    //                 }
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     } else {
    //       return Loading();
    //     }
    //   },
    // );
  }
}
