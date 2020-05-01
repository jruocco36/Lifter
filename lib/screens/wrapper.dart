import 'package:Lifter/models/user.dart';
import 'package:Lifter/screens/authenticate/authenticate.dart';
import 'package:Lifter/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return user == null ? Authenticate() : Home();
    if (user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }
  }
}
