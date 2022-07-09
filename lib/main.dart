import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('MainScreen'),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('LoginScreen'),
    );
  }
}

Widget initialize_application() {
  // If user already logged in, then redirect to home page
  // Else, redirect to login page
  return MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: false ? const MainScreen() : const LoginScreen(),
  );
}

void main() {
  try {
    runApp(initialize_application());
  } catch (e) {

  }
}
