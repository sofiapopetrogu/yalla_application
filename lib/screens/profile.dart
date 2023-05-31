import 'package:flutter/material.dart';

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
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
              'Biography and Useful Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your biography and useful information',
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
