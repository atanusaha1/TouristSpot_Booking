import 'package:flutter/material.dart';
import 'package:TouristSpot_Booking_System/welcomeScreen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    home: WelcomeScreen(),
  ));
}
