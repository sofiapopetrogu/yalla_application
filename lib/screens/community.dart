import 'package:flutter/material.dart';

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
          children: const [
            // Section: Previous User Experiences
            Card(
              child: ExpansionTile(
              title: Text('Previous User Experiences'),
              leading: Icon(Icons.history),
              children: <Widget>[
                  ListTile(title: Text('Used this app several times before. It is very helpful. I would recommend it to anyone :).'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('At first, I disliked the app. However, after using it for a while, I have grown to like it.'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('Takes some time to get used to, because there are other applications that work the same. But i enjoyed the uniqueness of the analysis part of the app.'),
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
                  ListTile(title: Text('My father has a heart condition. Is it hereditary? And should we both use the app?'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('Can my heart rate be too low?'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('Does the app calculate the different heart rate zones?'),
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
                  ListTile(title: Text('I recommended this app to my brother who has arrythmia. He found it very useful !! 4/5.'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('Too much information. I would prefer if the app was more simple 2/5.'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                  ListTile(title: Text('Nice. Easy. Simple. 5/5.'),
                            shape: Border(
                            top: BorderSide(width: 1.0, color: Colors.grey),
                          ), ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

