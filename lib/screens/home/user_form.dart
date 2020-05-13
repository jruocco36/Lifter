import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final User user;

  UserForm({@required this.user});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  String _name;

  @override
  Widget build(BuildContext context) {
    _name = widget.user.name;

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                autofocus: true,
                maxLines: null,
                decoration: textInputDecoration.copyWith(labelText: 'Name'),
                onChanged: (val) {
                  if (val == '') {
                    _name = null;
                  } else {
                    _name = val;
                  }
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: flamingoColor,
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  AuthService().updateName(_name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
