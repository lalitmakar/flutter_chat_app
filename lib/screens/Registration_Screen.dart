import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutterchatapplication/ReusableComponents/NavigationButton.dart';
import 'package:flutterchatapplication/constants.dart';
import 'package:flutterchatapplication/screens/Chat_Screen.dart';
import 'package:flutterchatapplication/screens/Login_Screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class RegistrationScreen extends StatefulWidget {
  static final String id = "Registration_Screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();
  bool spinner = false;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = new TextEditingController();
    TextEditingController _passwordController = new TextEditingController();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: "logo",
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  autofocus: true,
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter email id.";
                    }
                    final bool isValid = EmailValidator.validate(value);
                    if (isValid != true) {
                      return "Enter a valid email id.";
                    }
                    return null;
                  },
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: "Enter your email",
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (!(value.length >= 8 && value.length <= 15)) {
                      return "Password should contain 8-15 characters.";
                    }
                    return null;
                  },
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  },
                  decoration: kInputDecoration.copyWith(
                    hintText: "Enter your password",
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                NavigationButton(
                  colour: Colors.blueAccent,
                  title: "Register",
                  function: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        spinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);
                        if (newUser != null) {
                          _emailController.clear();
                          _passwordController.clear();
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          spinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          spinner = false;
                        });
                        String errormsg;
                        switch (e.code) {
                          case "ERROR_NETWORK_REQUEST_FAILED":
                            errormsg =
                                "Check Your Internet Connection and try again";
                            break;
                          case "ERROR_EMAIL_ALREADY_IN_USE":
                            errormsg =
                                "This email address is already registered, log in directly";
                            break;
                        }
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          elevation: 5.0,
                          duration: Duration(seconds: 5),
                          shape: RoundedRectangleBorder(),
                          action: errormsg ==
                                  'This email address is already registered, log in directly'
                              ? SnackBarAction(
                                  label: "log in ",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, LoginScreen.id);
                                  })
                              : null,
                          content: Text(
                            "$errormsg",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
