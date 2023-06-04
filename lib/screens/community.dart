import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_app/screens/homepage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_app/screens/community.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(CommunityHub());
}

class CommunityHub extends StatelessWidget {
  const CommunityHub({Key? key}) : super(key: key);

  static const routename = 'CommunityHub';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Hub'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section: Previous User Experiences
            Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Previous User Experiences'),
                subtitle: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
              ),
            ),

            // Section: Question and Answer
            Card(
              child: ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('Question and Answer'),
                subtitle: Text('Ask a question or find answers to health-related queries.'),
              ),
            ),

            // Section: Community Hub
            Card(
              child: ListTile(
                leading: Icon(Icons.group),
                title: Text('Community Hub'),
                subtitle: Text('Connect with other users and share your insights.'),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the previous screen (dashboard)
              },
              child: Text('Go Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  // Create sample data for the graph
  /* List<charts.Series<TimeSeriesData, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesData(DateTime(2022, 1, 1), 5),
      TimeSeriesData(DateTime(2022, 2, 1), 10),
      TimeSeriesData(DateTime(2022, 3, 1), 8),
      TimeSeriesData(DateTime(2022, 4, 1), 12),
      TimeSeriesData(DateTime(2022, 5, 1), 6),
      TimeSeriesData(DateTime(2022, 6, 1), 9),
    ];

    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Health Insights',
        colorFn: (, _) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: data,
      ),
    ];
  } */
}

/* class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}
 */

// Set Full Page Background to Teal
// 3 boxes: Previous User Experience, Question and Answer, Reviews  
//autogeneration can be a future improvement
