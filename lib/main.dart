import 'package:flutter/material.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:project_app/database/db.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final StepDatabase database =
      await $FloorStepDatabase.databaseBuilder('database.db').build();

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