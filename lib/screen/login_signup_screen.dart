import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../models/http_exception.dart';

import 'dart:math';

import './../providers/auth.dart';

enum FilterStatus {
  login,
  signup,
}

class LoginAndSignupScreen extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    final deviceInfo = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
              Color.fromRGBO(255, 118, 117, 1).withOpacity(0.9)
            ])),
            child: Column(
              children: [
                SizedBox(
                  height: deviceInfo.size.height * 0.14,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  margin: EdgeInsets.all(4),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade900,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  //color: Colors.brown,
                  child: Text(
                    "MyShop",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontFamily: 'Anton',
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: deviceInfo.size.height * 0.04),
                InputForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool _isLoading = false;
  FilterStatus status = FilterStatus.login;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, Object> _userDetail = {
    'email': '',
    'password': '',
  };
  void _showErrorDialogue(errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("An error occourd"),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text("Okey"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (status == FilterStatus.signup) {
        await Provider.of<Auth>(
          context,
          listen: false,
        ).signUp(
          _userDetail['email'],
          _userDetail['password'],
        );
      } else {
        await Provider.of<Auth>(
          context,
          listen: false,
        ).logIn(
          _userDetail['email'],
          _userDetail['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains("EMAIL_EXIST")) {
        errorMessage = 'email already exist';
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = 'this is not a valid email';
      } else if (error.toString().contains("WEEK_PASSWORD")) {
        errorMessage = 'password is too week';
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = 'invalid password';
      }
      _showErrorDialogue(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not authenticate you!!Please try again later';
      _showErrorDialogue(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: FilterStatus.login == status ? 260 : 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  _userDetail['email'] = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Enter Email';
                  }
                  if (!value.contains("@")) {
                    return 'Incorrect email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
              ),
              TextFormField(
                obscureText: true,
                onSaved: (value) {
                  _userDetail['password'] = value;
                },
                controller: _passwordController,
                validator: (value) {
                  if (value == null) {
                    return "Enter password";
                  }
                  if (value.length < 6) {
                    return 'Password too short';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
              if (FilterStatus.signup == status)
                TextFormField(
                  obscureText: true,
                  onSaved: (value) {},
                  validator: (value) {
                    if (value == null) {
                      return 'Enter password';
                    }
                    if (value != _passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),
              FlatButton(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          FilterStatus.login == status ? "LOGIN" : "SIGNUP",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                ),
                onPressed: () {
                  _submitData();
                },
              ),
              FlatButton(
                textColor: Colors.purple,
                child: Text(
                  FilterStatus.login == status
                      ? "SIGNUP INSTEED"
                      : "LOGIN INSTEED",
                ),
                onPressed: () {
                  if (status == FilterStatus.login) {
                    setState(() {
                      status = FilterStatus.signup;
                    });
                  } else {
                    setState(() {
                      status = FilterStatus.login;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
