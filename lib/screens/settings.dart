// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  static const routename = 'Settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationEnabled = true;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _performSearch() {
    String query = _searchController.text;
    setState(() {
      _searchQuery = query;
    });
    // Implement your search logic here
    // This is just a sample action
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search'),
          content: Text('Performing search for: $query'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.teal, // Set the background color to teal
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Search Query: $_searchQuery',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
            SwitchListTile(
              title: Text('Enable Notifications'),
              activeColor: Colors.teal,
              value: _notificationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationEnabled = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Other Settings',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Account Settings'),
              onTap: () {
                // Perform action when account settings is tapped
              },
            ),
            ListTile(
              title: Text('Privacy Settings'),
              onTap: () {
                // Perform action when privacy settings is tapped
              },
            ),
            
            
          ],
        ),
      ),
    );
  }
}