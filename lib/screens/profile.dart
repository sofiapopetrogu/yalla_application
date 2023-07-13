import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routename = 'ProfilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();

}

// Initialize controllers for editing text input in profile page
class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameEditor = TextEditingController();
  TextEditingController emailEditor = TextEditingController();
  TextEditingController phoneEditor = TextEditingController();
  TextEditingController aboutEditor = TextEditingController();
  @override
  void initState() {
    super.initState();
    setTextFieldState();
  
  }//initState

  //set default parameters for profile text
  void setTextFieldState() async {
    final sp = await SharedPreferences.getInstance();
    nameEditor.text = sp.getString('profile_name')?? '';
    emailEditor.text = sp.getString('profile_email')?? '';
    phoneEditor.text = sp.getString('profile_phone')?? '';
    aboutEditor.text = sp.getString('profile_about')?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.teal, // Set the background color to teal
        leading: TextButton(
          child: const Text('Done',
            style: TextStyle(color: Colors.white),
          ), 
          // save profile text to shared preferences
          onPressed: () async {
            final sp = await SharedPreferences.getInstance();
            sp.setString('profile_name', nameEditor.text);
            sp.setString('profile_email', emailEditor.text);
            sp.setString('profile_phone', phoneEditor.text);
            sp.setString('profile_about', aboutEditor.text);
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
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/cat.png'),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Set the background color
                        onPrimary: Colors.white, // Set the text color
                        elevation: 4, // Set the elevation (shadow) of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set the border radius
                        ),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal, // Set the background color
                        onPrimary: Colors.white, // Set the text color
                        elevation: 4, // Set the elevation (shadow) of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Set the border radius
                        ),
                      ),
                      child: const Text('Share Profile'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              'Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
              controller: nameEditor,
            ),
            SizedBox(height: 20),
            const Text(
              'Email',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              controller: emailEditor,
            
            ),
            SizedBox(height: 20),
            const Text(
              'Phone Number',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
              controller: phoneEditor,
            ),
            const SizedBox(height: 20),
            const Text(
              'About You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell us about yourself',
              ),
              controller: aboutEditor,
            ),
            // Add more widgets or features as desired
          ],
        ),
      ),
    );
  }
  
  } // LoginScreen