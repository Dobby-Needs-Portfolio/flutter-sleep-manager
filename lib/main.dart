import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'backend/Util.dart';
import 'widget/login.dart';
import 'widget/mainscreen.dart';

Widget initialize_application() {
  // If user already logged in, then redirect to home page
  // Else, redirect to login page
  return GetMaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: false ? const MainScreen() : const LoginScreen(),
  );
}

void main() async {
  try {
    await Util.initialize();
    runApp(initialize_application());
  } catch (e) {

  }
}
