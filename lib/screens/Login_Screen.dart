import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutterchatapplication/ReusableComponents/NavigationButton.dart';
import 'package:flutterchatapplication/constants.dart';
import 'package:flutterchatapplication/screens/Chat_Screen.dart';
import 'package:flutterchatapplication/screens/Registration_Screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class LoginScreen extends StatefulWidget {
  static final String id = "Login_Screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool spinner = false;

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
                  decoration:
                      kInputDecoration.copyWith(hintText: "Enter your email"),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Enter password";
                    }
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
                      hintText: "Enter your password"),
                ),
                SizedBox(
                  height: 24.0,
                ),
                NavigationButton(
                  colour: Colors.lightBlueAccent,
                  title: "Log In",
                  function: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        spinner = true;
                      });
                      try {
                        final login = await _auth.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        if (login != null) {
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
                          case "ERROR_USER_NOT_FOUND":
                            errormsg = "User not found, Register first";
                            break;
                          case "ERROR_WRONG_PASSWORD":
                            errormsg = "Password is incorrect, try again.";
                            break;
                          case "ERROR_NETWORK_REQUEST_FAILED":
                            errormsg =
                                "Check Your Internet Connection and try again";
                            break;
                        }
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          elevation: 5.0,
                          duration: Duration(seconds: 5),
                          action: errormsg == "User not found, Register first"
                              ? SnackBarAction(
                                  label: "Register",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                        context, RegistrationScreen.id);
                                  })
                              : null,
                          shape: RoundedRectangleBorder(),
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
