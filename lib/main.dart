import 'package:flutter/material.dart';
import 'package:flutterchatapplication/screens/Chat_Screen.dart';
import 'package:flutterchatapplication/screens/Login_Screen.dart';
import 'package:flutterchatapplication/screens/Registration_Screen.dart';
import 'package:flutterchatapplication/screens/Welcome_Screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Chat",
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen()
      },
    );
  }
}
