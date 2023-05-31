import 'package:flutter/material.dart';




class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
            SizedBox(height: 20),
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
            // Add more widgets or features as desired
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
