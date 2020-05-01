import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Sign up for Lifter'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Sign in'),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      validator: (val) => val.isEmpty ? 'Enter email' : null,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      validator: (val) => val.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: flamingoColor,
                      child: Text(
                        'Register',
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .registerWithEmailPassword(email, password);
                          if (result.runtimeType == String &&
                              result.contains('ERROR')) {
                            switch (result) {
                              case 'ERROR_EMAIL_ALREADY_IN_USE':
                                {
                                  setState(() {
                                    error = 'Email already in use';
                                    loading = false;
                                  });
                                  break;
                                }
                              case 'ERROR_INVALID_EMAIL':
                                {
                                  setState(() {
                                    error = 'Not a valid email';
                                    loading = false;
                                  });
                                  break;
                                }
                              case 'ERROR_WEAK_PASSWORD':
                                {
                                  setState(() {
                                    error = 'Password is not strong enough';
                                    loading = false;
                                  });
                                  break;
                                }
                              default:
                                {
                                  setState(() {
                                    error = 'Not a valid email and password';
                                    loading = false;
                                  });
                                  break;
                                }
                            }
                          }
                          // if register successful, StreamProvider will pick up our new
                          // user and our Wrapper widget will automatically switch to
                          // display our Home widget
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
