import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:flutter_login/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  static const routename = 'Profile';



void _toHomePage(BuildContext context) async{
  Navigator.pop(context);

  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }//_toHomePage
}//Profile