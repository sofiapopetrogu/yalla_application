// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

//import 'package:charts_flutter/flutter.dart' as charts;

class CommunityHub extends StatelessWidget {
  const CommunityHub({Key? key}) : super(key: key);

  static const routename = 'CommunityHub';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Hub'),
        backgroundColor: Colors.teal, // Set the background color to teal
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section: Previous User Experiences
            Card(
              child: ExpansionTile(
              title: Text('Previous User Experiences'),
              leading: Icon(Icons.history),
              children: <Widget>[
                  ListTile(title: Text('UX 1'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('UX 2'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('UX 3'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                ],
              ),
            ),
            
            // Section: Question and Answer
            Card(
              child: ExpansionTile(
              title: Text('Question and Answer'),
              subtitle: Text('Ask a question or find answers to health-related queries.'), //TODO: update font size later
              leading: Icon(Icons.question_answer),
              children: <Widget>[
                  ListTile(title: Text('QA 1'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('QA 2'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('QA 3'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                ],
              ),
            ),
            
            // Section: Reviews
            Card(
              child: ExpansionTile(
              title: Text('User Reviews'),
              leading: Icon(Icons.group),
              children: <Widget>[
                  ListTile(title: Text('UX 1'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('UX 2'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('UX 3'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                ],
              ),
            ),

            // Section: Graphs
            /* Card(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Health Trends'),
                    SizedBox(height: 8.0),
                    Container(
                      height: 200.0,
                      child: charts.LineChart(
                        _createSampleData(),
                        animate: true,
                      ),
                    ),
                  ],
                ),
              ),
            ), */
            // Back Button
          ],
        ),
      ),
    );
  }

}

//autogeneration can be a future improvement
