import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project_app/screens/homepage.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  static const routename = 'ProfilePage';

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
          onPressed: () {
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
                    ),
                    ElevatedButton(
                      child: Text('Share Profile'),
                      onPressed: () {
                        // Handle share profile button press
                        // Add your logic here
                      },
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
              onChanged: (value) {
                // Handle name input
                // Add your logic here
              },
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
              onChanged: (value) {
                // Handle email input
                // Add your logic here
              },
            
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
              onChanged: (value) {
                // Handle phone number input
                // Add your logic here
              },
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
              onChanged: (value) {
                // Handle biography input
                // Add your logic here
              },
            ),
            // Add more widgets or features as desired
          ],
        ),
      ),
    );
  }
}
