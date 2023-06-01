import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  static const routename = 'ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController name_editor = TextEditingController();
  TextEditingController email_editor = TextEditingController();
  TextEditingController phone_editor = TextEditingController();
  TextEditingController about_editor = TextEditingController();
  @override
  void initState() {
    super.initState();
    setTextFieldState();
  
  }//initState

  void setTextFieldState() async {
    final sp = await SharedPreferences.getInstance();
    name_editor.text = sp.getString('profile_name')?? '';
    email_editor.text = sp.getString('profile_email')?? '';
    phone_editor.text = sp.getString('profile_phone')?? '';
    about_editor.text = sp.getString('profile_about')?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.teal, // Set the background color to teal
        leading: TextButton(
          child: Text('Done',
            style: TextStyle(color: Colors.white),
          ), 
          onPressed: () async {
            final sp = await SharedPreferences.getInstance();
            sp.setString('profile_name', name_editor.text);
            sp.setString('profile_email', email_editor.text);
            sp.setString('profile_phone', phone_editor.text);
            sp.setString('profile_about', about_editor.text);
            // Navigate back to the homepage
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/cat.png'),
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      child: Text('Edit Profile'),
                      onPressed: () {
                        // Handle edit profile button press
                        // Add your logic here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Set the background color
                        onPrimary: Colors.white, // Set the text color
                        elevation: 4, // Set the elevation (shadow) of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set the border radius
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Share Profile'),
                      onPressed: () {
                        // Handle share profile button press
                        // Add your logic here
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Set the background color
                        onPrimary: Colors.white, // Set the text color
                        elevation: 4, // Set the elevation (shadow) of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set the border radius
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
              controller: name_editor,
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
              controller: email_editor,
            
            ),
            SizedBox(height: 20),
            Text(
              'Phone Number',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
              ),
              controller: phone_editor,
            ),
            SizedBox(height: 20),
            Text(
              'About You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tell us about yourself',
              ),
              controller: about_editor,
            ),
            // Add more widgets or features as desired
          ],
        ),
      ),
    );
  }
  
  } // LoginScreen