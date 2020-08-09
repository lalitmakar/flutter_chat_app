import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutterchatapplication/ReusableComponents/NavigationButton.dart';
import 'package:flutterchatapplication/screens/Login_Screen.dart';
import 'package:flutterchatapplication/screens/Registration_Screen.dart';

class WelcomeScreen extends StatefulWidget {
  static final String id = "Welcome_Screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.addListener(() {
      setState(() {});
      print(controller.value * 100);
    });
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: "logo",
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 80.0,
                    ),
                  ),
                  Text(
                    'My Chat',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  RotateAnimatedTextKit(
                    onTap: () {},
                    text: ["FUN", "SECURE", "AWESOME"],
                    textStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontFamily: "Horizon"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            NavigationButton(
              colour: Colors.lightBlueAccent,
              title: "Log In",
              function: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            NavigationButton(
              colour: Colors.blueAccent,
              title: "Register",
              function: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
