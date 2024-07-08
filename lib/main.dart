import 'package:flutter/material.dart';
import 'package:TouristSpot_Booking_System/welcomeScreen.dart';

import 'home_page.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    home: WelcomeScreen(),
  ));
}
