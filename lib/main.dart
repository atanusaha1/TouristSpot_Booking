import 'package:flutter/material.dart';
import 'package:new_flutter_project/welcomeScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    home: WelcomeScreen(),
  ));
}
