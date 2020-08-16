import 'package:flutter/material.dart';
import 'package:flutterchatapplication/screens/Chat_Screen.dart';
import 'package:flutterchatapplication/screens/Login_Screen.dart';
import 'package:flutterchatapplication/screens/Registration_Screen.dart';
import 'package:flutterchatapplication/screens/Splash_Screen.dart';
import 'package:flutterchatapplication/screens/Welcome_Screen.dart';
import 'package:flutterchatapplication/screens/cameraScreen.dart';
import 'package:flutterchatapplication/screens/clickedImage.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Chat",
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ShowClickedPicture.id: (context) => ShowClickedPicture(),
        CameraWidgetLogic.id: (context) => CameraWidgetLogic(),
      },
    );
  }
}
