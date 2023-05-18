import 'package:flutter/material.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:flutter_login/flutter_login.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yalla App',
      theme: ThemeData(
        primaryColor: Colors.teal,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(.1), // Sand color
          contentPadding: EdgeInsets.zero,
          errorStyle: TextStyle(
            backgroundColor: Colors.orange,
            color: Colors.white,
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}