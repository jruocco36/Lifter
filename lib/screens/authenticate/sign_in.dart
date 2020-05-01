import 'package:Lifter/Services/auth.dart';
import 'package:Lifter/shared/constants.dart';
import 'package:Lifter/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
              title: Text('Sign in to Lifter'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
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
                      child: Text('Sign in'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result.runtimeType == String &&
                              result.contains('ERROR')) {
                            switch (result) {
                              case 'ERROR_WRONG_PASSWORD':
                                {
                                  setState(() {
                                    error = 'Password is incorrect';
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
                              case 'ERROR_USER_NOT_FOUND':
                                {
                                  setState(() {
                                    error = 'No account for this email';
                                    loading = false;
                                  });
                                  break;
                                }
                              case 'ERROR_USER_DISABLED':
                                {
                                  setState(() {
                                    error = 'This account has been disabled';
                                    loading = false;
                                  });
                                  break;
                                }
                              case 'ERROR_TOO_MANY_REQUESTS':
                                {
                                  setState(() {
                                    error =
                                        'Too many sign in attempts, please try again later';
                                    loading = false;
                                  });
                                  break;
                                }
                              case 'ERROR_OPERATION_NOT_ALLOWED':
                                {
                                  setState(() {
                                    error = 'This type of sign in is not enabled';
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
                          // if sign in successful, StreamProvider will pick up our new
                          // user and our Wrapper widget will automatically switch to
                          // display our Home widget
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
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
