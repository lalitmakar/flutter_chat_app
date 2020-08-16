import 'dart:async';
import 'package:flutter/material.dart';
import 'Welcome_Screen.dart';

class SplashScreen extends StatefulWidget {
  static final String id = "Splash_Screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pop(context);
      Navigator.pushNamed(context, WelcomeScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.asset(
                  "images/logo.png",
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "My Chat",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fun|Secure|Awesome",
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
