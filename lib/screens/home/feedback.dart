import 'package:Lifter/Services/database.dart';
import 'package:Lifter/models/user.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackForm extends StatefulWidget {
  final User user;

  FeedbackForm({@required this.user});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  String feedback;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Feedback'),
                onChanged: (val) {
                  if (val == '') {
                    feedback = null;
                  } else {
                    feedback = val;
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
                  DatabaseService(uid: widget.user.uid).addFeedback(feedback);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
