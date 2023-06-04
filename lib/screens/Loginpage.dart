import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  }//initState

  void _checkLogin() async {
    //Get the SharedPreference instance and check if the value of the 'username' filed is set or not
    final sp = await SharedPreferences.getInstance();
    if(sp.getString('username') != null){
      //If 'username is set, push the HomePage
      _toHomePage(context);
    }//if
  }//_checkLogin

  Future<String> _loginUser(LoginData data) async {
    if(data.name == 'sofiapope.trogu@studenti.unipd.it' && data.password == '123456!'){

      final sp = await SharedPreferences.getInstance();
      sp.setString('username', data.name);

      return '';
    } else {
      return 'Wrong credentials';
    }
  } 
 // _loginUser
  Future<String> _signUpUser(SignupData data) async {
    return 'To be implemented';
  } 
 // _signUpUser
  Future<String> _recoverPassword(String email) async {
    return 'Recover password functionality needs to be implemented';
  } 
 // _recoverPassword
  @override
  Widget build(BuildContext context) {
    
    return FlutterLogin(
      title: 'Welcome',
      logo: AssetImage('assets/images/yalla.png'), //need to add Logo here
      onLogin: _loginUser,
      onSignup: _signUpUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async{
        _toHomePage(context);
      },
    );
  } // build
  void _toHomePage(BuildContext context) async{
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }//_toHomePage
  
  } // LoginScreen
