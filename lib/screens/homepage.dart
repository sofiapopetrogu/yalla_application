import 'package:fl_animated_linechart/common/pair.dart';
import 'package:flutter/material.dart';
import 'package:project_app/database/steps/steps_daily.dart';
import 'package:project_app/models/patient.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project_app/screens/profile.dart';
import 'package:project_app/screens/community.dart';
import 'package:project_app/screens/settings.dart';
import 'package:project_app/util/authentication.dart';
import 'package:project_app/util/data_access.dart';
import 'package:provider/provider.dart';
import 'package:project_app/database/databaseRepository.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

import '../database/db.dart';
import '../database/heart/heart_daily.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Dashboard';

  @override
  _HomePageState createState() => _HomePageState();
}

// Class that describes activity of the home page
class _HomePageState extends State<HomePage> {
  // Function requests the list of patients from the API and when it gets them, updates the state
  // in case of error, it retries the API call
  void getPatients() {
    DataAccess.getPatients().then((value) {
      setState(() {
        patients = value;
        currentpatient = patients[0].username;
      });
    }).catchError((error) {
      print('error thrown');
      print(error);
      getPatients();
    });
  }


  _HomePageState() : super() {
    // When you create the state, it immediately asks for the patient
    getPatients();
  }
  //Initializing attributes of the state
  Map<DateTime, double> stepsList = Map();
  Map<DateTime, double> prevstepsList = Map();
  Map<DateTime, double> heartList = Map();
  Map<DateTime, double> prevheartList = Map();
  // Set range of a week with endate being yesterday and startdate being 7 days before
  final DateTime enddate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(seconds: 1));
  DateTime startdate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(seconds: 1))
          .subtract(Duration(days: 7));
  // Set initial date group by condition to be by day; can be changed to hour or minute as indicated in comment below
  String mycondition = "DATE(dateTime / 1000, 'unixepoch') ";
  /*
      for group by day
      DATE(dateTime / 1000, 'unixepoch') 
      for group by hour
      DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'
      for group by minute
      DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'
   */
  String timewindow = "Week";
  String groupby = "Day";
  String currentpatient = "";
  List<Patients> patients = [];
  bool download = false;

  @override
  Widget build(BuildContext context) {
    //initialize stepPlot
    
    Container stepPlot = _buildPlotSteps(context, stepsList, prevstepsList);
    Container heartPlot = _buildPlotHeart(context, heartList, prevheartList);

    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
        backgroundColor: Colors.teal, // Set the background color to teal
      ),
      // Floating Action Button is shown only if there are patients already downloaded from API
      floatingActionButton: patients.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {

                //clear table before inserting steps/heart
                await Provider.of<DatabaseRepository>(context, listen: false)
                    .deleteAllSteps();
                await Provider.of<DatabaseRepository>(context, listen: false)
                    .deleteAllHeart();
                //sets API Authentication token
                await Authentication.getAndStoreTokens();


                // Wait for all four API calls to finish
                await Future.wait([
                  // Get steps for the current week
                  DataAccess.getStepWeek(
                      enddate.subtract(Duration(days: 7)),
                      enddate,
                      currentpatient).then((steps) async {
                        //once API call is finished, insert steps into database
                        await Provider.of<DatabaseRepository>(context, listen: false)
                          .database
                          .stepDao
                          .insertMultSteps(steps
                          //map API objects to database objects
                              .map((step) => StepsDaily(
                                  steps: step.value,
                                  dateTime: step.time,
                                  patient: step.patient))
                              .toList());
                      }),
                  // Get steps for the previous week
                  DataAccess.getStepWeek(
                      enddate.subtract(Duration(days: 15)),
                      enddate.subtract(Duration(days: 8)),
                      currentpatient).then((prev_steps) async {
                        //once API call is finished, insert steps into database
                        await Provider.of<DatabaseRepository>(context, listen: false)
                          .database
                          .stepDao
                          .insertMultSteps(prev_steps
                          //map API objects to database objects
                              .map((step) => StepsDaily(
                                  steps: step.value,
                                  dateTime: step.time,
                                  patient: step.patient))
                              .toList());
                      }),
                  // Get heart rate for the current week
                  DataAccess.getHeartWeek(
                      enddate.subtract(Duration(days: 7)),
                      enddate,
                      currentpatient).then((hearts) async {
                        //once API call is finished, insert heart data into database
                        await Provider.of<DatabaseRepository>(context, listen: false)
                          .database
                          .heartDao
                          .insertMultHeart(hearts
                          //map API objects to database objects
                              .map((heart) => HeartDaily(
                                  heart: heart.value,
                                  dateTime: heart.time,
                                  patient: heart.patient))
                              .toList());
                      }),
                  // Get heart rate for the current week
                  DataAccess.getHeartWeek(
                      enddate.subtract(Duration(days: 15)),
                      enddate.subtract(Duration(days: 8)),
                      currentpatient).then((prev_hearts) async {
                        //once API call is finished, insert heart data into database
                        await Provider.of<DatabaseRepository>(context, listen: false)
                          .database
                          .heartDao
                          .insertMultHeart(prev_hearts
                          //map API objects to database objects
                              .map((heart) => HeartDaily(
                                  heart: heart.value,
                                  dateTime: heart.time,
                                  patient: heart.patient))
                              .toList());
                      })
                ]);
                
                // Variables to store data from the database queries below
                // late suggests initialization will happen later in code
                late Map<DateTime, double> datastep;
                late Map<DateTime, double> prev_datastep;
                late Map<DateTime, double> dataheart;
                late Map<DateTime, double> prev_dataheart;
                
                final result = await Future.wait([
                  // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                  // Once DB query is executed, value of result is mapped to the corresponding variable above
                  getMapStep(startdate, enddate, mycondition).then((value) => datastep = value),
                  getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), mycondition).then((value) => prev_datastep = value),
                  getMapHeart(startdate, enddate, mycondition).then((value) => dataheart = value),
                  getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), mycondition).then((value) => prev_dataheart = value) 
                ]);

                // Once all DB queries are finished, update the state of the app
                setState(() {
                  download = true;
                  stepsList = datastep;
                  heartList = dataheart;
                  prevstepsList = prev_datastep;
                  prevheartList = prev_dataheart;
                });
              },
              // Other attributes of floating action button
              child: Icon(Icons.update),
              backgroundColor: Colors.teal,
            ),
            // Scroll view allows you to scroll down the page
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          // Sets width of container to the width of the screen
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                                      'Choose your patient:',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            // Dropdown menu to select patient
                            child: DropdownButton<String>(
                              disabledHint: const Text("Loading"),
                              value: currentpatient,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.teal,
                              ),
                              // When you select a patient in the dropdown menu, update the state of the app for currentpatient
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  currentpatient = value!;
                                });
                              },
                              // If API has not finished loading, don't make dropdown menu selectable
                              items: patients.isEmpty
                                  ? null
                                  // Otherwise, map the list of patients to dropdown menu items
                                  : patients
                                      .map<DropdownMenuItem<String>>(
                                          (value) => DropdownMenuItem<String>(
                                                value: value.username,
                                                child: Text(value.displayname),
                                              ))
                                      .toList(),
                            )),
                      ],
                    )),
              ] +
              // If API has not finished loading, display a blank screen
              // Otherwise, display everything below
              (patients.isEmpty
                  ? []
                  : [
                      Row(
                        children: [
                          Expanded(
                            child: Column(children: [
                              const Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.0, left: 20.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Choose your timeframe:',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Column(
                                  children: [
                                    // Radio buttons to select timeframe in a list tile
                                    ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      title: const Text('Week',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      // First radio button represents Week timeframe
                                      leading: Radio<String>(
                                        value: 'Week',
                                        groupValue: timewindow,
                                        //if I'm selected, groupvalue will match value showing the filled button
                                        onChanged: (String? value) async {
                                          // startdate is 7 days before enddate
                                          startdate = enddate
                                              .subtract(Duration(days: 7));
                                          // Variables initialized that will be defined later in the code
                                          late Map<DateTime, double> datastep;
                                          late Map<DateTime, double> prev_datastep;
                                          late Map<DateTime, double> dataheart;
                                          late Map<DateTime, double> prev_dataheart;
                                          
                                          
                                          final result = await Future.wait([
                                            // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                                            // Once DB query is executed, value of result is mapped to the corresponding variable above
                                            getMapStep(startdate, enddate, mycondition).then((value) => datastep = value),
                                            getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), mycondition).then((value) => prev_datastep = value),
                                            getMapHeart(startdate, enddate, mycondition).then((value) => dataheart = value),
                                            getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), mycondition).then((value) => prev_dataheart = value) 
                                          ]);
                                          // After mapping of results to variables, set state of app
                                          setState(() {
                                            timewindow = 'Week';
                                            startdate = enddate
                                                .subtract(Duration(days: 7));
                                            stepsList = datastep;
                                            heartList = dataheart;
                                            prevstepsList = prev_datastep;
                                            prevheartList = prev_dataheart;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      title: const Text('Day',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      // Second radio button is day for timeframe
                                      leading: Radio<String>(
                                        value: 'Day',
                                        groupValue: timewindow,
                                        //if I'm selected, groupvalue will match value showing the filled button
                                        onChanged: (String? value) async {
                                          startdate = enddate
                                              .subtract(Duration(days: 1));
                                          // Initialized variables that will be defined below
                                          late Map<DateTime, double> datastep;
                                          late Map<DateTime, double> prev_datastep;
                                          late Map<DateTime, double> dataheart;
                                          late Map<DateTime, double> prev_dataheart;
                                          
                                          // Condition that avoids grouping that matches the selected timeframe, i.e. if your timeframe is Day, you cannot also select Week in the groupby
                                          final c = groupby == 'Day' ? "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'" : mycondition;
                                          
                                          final result = await Future.wait([
                                            // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                                            // Once DB query is executed, value of result is mapped to the corresponding variable above
                                            getMapStep(startdate, enddate, c).then((value) => datastep = value),
                                            getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_datastep = value),
                                            getMapHeart(startdate, enddate, c).then((value) => dataheart = value),
                                            getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_dataheart = value) 
                                          ]);
                                          // After mapping of results to variables, set state of app
                                          setState(() {
                                            timewindow = 'Day';
                                            if (groupby == 'Day') {
                                              groupby = 'Hour';
                                              mycondition = "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'";
                                            }
                                            startdate = enddate
                                                .subtract(Duration(days: 1));
                                            stepsList = datastep;
                                            heartList = dataheart;
                                            prevstepsList = prev_datastep;
                                            prevheartList = prev_dataheart;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      title: const Text('Hour',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      // Final Radio Button for timeframe is hour
                                      leading: Radio<String>(
                                        value: 'Hour',
                                        groupValue: timewindow,
                                        //if I'm selected, groupvalue will match value showing the filled button
                                        onChanged: (String? value) async {
                                          startdate = enddate
                                              .subtract(Duration(hours: 1));
                                          // Initialized variables that will be defined below
                                          late Map<DateTime, double> datastep;
                                          late Map<DateTime, double> prev_datastep;
                                          late Map<DateTime, double> dataheart;
                                          late Map<DateTime, double> prev_dataheart;

                                          // Condition that avoids grouping that matches the selected timeframe, i.e. if your timeframe is Hour, you cannot also select Hour in the groupby
                                          final c = "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'";

                                          final result = await Future.wait([
                                            // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                                            // Once DB query is executed, value of result is mapped to the corresponding variable above
                                            getMapStep(startdate, enddate, c).then((value) => datastep = value),
                                            getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_datastep = value),
                                            getMapHeart(startdate, enddate, c).then((value) => dataheart = value),
                                            getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_dataheart = value) 
                                          ]);
                                          // After mapping of results to variables, set state of app
                                          setState(() {
                                            timewindow = 'Hour';
                                            groupby = 'Minute';
                                            startdate = enddate
                                                .subtract(Duration(hours: 1));
                                            mycondition = c;
                                            stepsList = datastep;
                                            heartList = dataheart;
                                            prevstepsList = prev_datastep;
                                            prevheartList = prev_dataheart;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          Expanded(
                            // Second column in row will be a listtile of Group By conditions for how to group the timeframe data
                              child: Column(
                            children: [
                              const Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.0, left: 20.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Choose your grouping:',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0,
                                    bottom:
                                        5.0), 
                                child: Column(
                                  children: [
                                    ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      title: const Text('Day',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      // First radio button for Grouping that represents Day
                                      leading: Radio<String>(
                                        value: 'Day',
                                        groupValue: groupby,
                                        //if I'm selected, groupvalue will match value showing the filled button
                                        // Disable Day group if timewindow is Hour or Day
                                        onChanged: timewindow == 'Hour' || timewindow == 'Day' ? null : (String? value) async {
                                          // Condition that avoids grouping that matches the selected timeframe, i.e. if your timeframe is Day, you cannot also select Day in the groupby
                                          final c = "DATE(dateTime / 1000, 'unixepoch')";

                                          // Initialized variables that will be defined below
                                          late Map<DateTime, double> datastep;
                                          late Map<DateTime, double> prev_datastep;
                                          late Map<DateTime, double> dataheart;
                                          late Map<DateTime, double> prev_dataheart;
                                          
                                          final result = await Future.wait([
                                            // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                                            // Once DB query is executed, value of result is mapped to the corresponding variable above
                                            getMapStep(startdate, enddate, c).then((value) => datastep = value),
                                            getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_datastep = value),
                                            getMapHeart(startdate, enddate, c).then((value) => dataheart = value),
                                            getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_dataheart = value) 
                                          ]);
                                          // After mapping of results to variables, set state of app
                                          setState(() {
                                            groupby = 'Day';
                                            mycondition = c;
                                            stepsList = datastep;
                                            heartList = dataheart;
                                            prevstepsList = prev_datastep;
                                            prevheartList = prev_dataheart;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      title: const Text('Hour',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      // 2nd Radio Button of Group by is Hour
                                      leading: Radio<String>(
                                        value: 'Hour',
                                        groupValue: groupby,
                                        //if I'm selected, groupvalue will match value showing the filled button
                                        // Disables radiobutton for Hour if Hour timewindow is selected
                                        onChanged: timewindow == 'Hour' ? null : (String? value) async {
                                          // Condition that avoids grouping that matches the selected timeframe, i.e. if your timeframe is Hour, you cannot also select Hour in the groupby
                                          final c = "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'";
                                          // Initialized variables that will be defined below                                          
                                          late Map<DateTime, double> datastep;
                                          late Map<DateTime, double> prev_datastep;
                                          late Map<DateTime, double> dataheart;
                                          late Map<DateTime, double> prev_dataheart;
                                          
                                          final result = await Future.wait([
                                            // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                                            // Once DB query is executed, value of result is mapped to the corresponding variable above
                                            getMapStep(startdate, enddate, c).then((value) => datastep = value),
                                            getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_datastep = value),
                                            getMapHeart(startdate, enddate, c).then((value) => dataheart = value),
                                            getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_dataheart = value) 
                                          ]);
                                           // After mapping of results to variables, set state of app
                                          setState(() {
                                            print("selected hour");
                                            groupby = 'Hour';
                                            mycondition = c;
                                            stepsList = datastep;
                                            heartList = dataheart;
                                            prevstepsList = prev_datastep;
                                            prevheartList = prev_dataheart;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      dense: true,
                                      contentPadding:
                                          EdgeInsets.only(left: 10.0),
                                      title: const Text('Minute',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          )),
                                      // Final Radio button of Group By is Minute
                                      leading: Radio<String>(
                                        value: 'Minute',
                                        groupValue: groupby,
                                        //if I'm selected, groupvalue will match value showing the filled button
                                        // You can group by minute no matter the time frame
                                        onChanged: (String? value) async {
                                          final c = "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'";

                                          // Initialized variables that will be defined below 
                                          late Map<DateTime, double> datastep;
                                          late Map<DateTime, double> prev_datastep;
                                          late Map<DateTime, double> dataheart;
                                          late Map<DateTime, double> prev_dataheart;
                                          
                                          final result = await Future.wait([
                                            // 4 DB queries to get steps and heart data for the current and previous week perfomed in parallel
                                            // Once DB query is executed, value of result is mapped to the corresponding variable above
                                            getMapStep(startdate, enddate, c).then((value) => datastep = value),
                                            getMapStep(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_datastep = value),
                                            getMapHeart(startdate, enddate, c).then((value) => dataheart = value),
                                            getMapHeart(startdate.subtract(Duration(days: 7)), enddate.subtract(Duration(days: 7)), c).then((value) => prev_dataheart = value) 
                                          ]);
                                          // After mapping of results to variables, set state of app
                                          setState(() {
                                            print("selected minute");
                                            groupby = 'Minute';
                                            mycondition = c;
                                            stepsList = datastep;
                                            heartList = dataheart;
                                            prevstepsList = prev_datastep;
                                            prevheartList = prev_dataheart;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                      stepPlot,
                      heartPlot
                    ]),
        ),
      ),
      // Logout option available in drawer on top left 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Container(),
            ),
            ListTile(
              leading: Icon(MdiIcons.logout),
              title: Text('Logout'),
              onTap: () => _toLoginPage(context),
            ),
          ],
        ),
      ),
      // Clickable icons to nagivate to other pages
      // Dashboard is the current page, so it is not clickable
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.ssid_chart),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountCircle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            _toProfile(context);
          } else if (index == 2) {
            _toCommunity(context);
          } else if (index == 3) {
            _toSettings(context);
          }
        },
      ),
    );
  } //build

  // Function to navigate to login page
  void _toLoginPage(BuildContext context) async {
    //Unset the 'username' filed in SharedPreference
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    //Pop the drawer first
    Navigator.pop(context);
    //Then push to login
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  // Function to navigate to profile page
  void _toProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  // Function to navigate to community page
  void _toCommunity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityHub()),
    );
  }

  // Function to navigate to settings page
  void _toSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  //Function to visualize step plot
  Container _buildPlotSteps(
    BuildContext context, Map<DateTime, double> steps, Map<DateTime, double> prevsteps) {
    return Container(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // If step data is not available or download is false, display temporaray image
          // otherwise, return plot
          child: (steps.isEmpty || !download)
              ? Center(
                  child: Image.asset('assets/images/walking.png',
                      width: 125, height: 125))
              : _buildPlotWithDataSteps(context, steps, prevsteps),
        ),
      ),
    );
  } //buildPlotSteps

  //Function to build plot with data
  Widget _buildPlotWithDataSteps(
      BuildContext context, Map<DateTime, double> steps, Map<DateTime, double> prevsteps) {
        // Create a reference line of 50 steps from min start date to max end date
    Map<DateTime, double> stepreference = {
      steps.keys.reduce((a,b) => a.isBefore(b) ? a : b): 50, //min start date
      steps.keys.reduce((a,b) => a.isAfter(b) ? a : b): 50 //max end date
    };
    // Reset date value of steps from previous week to align with current week
    prevsteps = { 
      for (var element in prevsteps.entries) element.key.add(Duration(days: 7)) : element.value 
      };
    // Build the chart using reference line and steps from current and previous week
    LineChart chart = LineChart.fromDateTimeMaps(
      [stepreference, prevsteps, steps],
      [Colors.red, Colors.orange, Colors.blue],
      ['Steps', 'Steps', 'Steps'],
      yAxisName: 'Steps',
    );
    // Display plot and legends
    return Column(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AnimatedLineChart(
                legends: const [Legend(
                            title: 'Patient Steps',
                            color: Colors.blue,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),Legend(
                            title: 'Step Reference',
                            color: Colors.red,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Legend(
                            title: 'Previous Week',
                            color: Colors.orange,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),],
                textStyle: TextStyle(color: Colors.black),
                chart,
                gridColor: Colors.black,
                toolTipColor: Colors.white,
              )))
    ]);
  } //buildPlotWithDataSteps

  // Future that is a promise to run a query in the DB that maps patient step data to date and step values in a map
  Future<Map<DateTime, double>> getMapStep(
      startdate, enddate, mycondition) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('database.db').build();
    final start_date = startdate.millisecondsSinceEpoch;
    final end_date = enddate.millisecondsSinceEpoch;

    final List<Pair<DateTime, double>> list =
        (await database.database.rawQuery("""
      SELECT $mycondition as date,
        AVG(steps) AS steps
      FROM 
        StepsDaily
      WHERE 
        dateTime > $start_date AND dateTime < $end_date
      GROUP BY $mycondition
      ORDER BY 
        date ASC;"""))
            .map((e) =>
                Pair(DateTime.parse(e['date'] as String), e['steps'] as double))
            .toList();
    // Pass list of key: value pairs to map
    return {for (var item in list) item.left: item.right};
  } //getMap
  
  // Future that is a promise to run a query in the DB that maps patient heart data to date and heart values in a map
  Future<Map<DateTime, double>> getMapHeart(
      startdate, enddate, mycondition) async {
    final AppDatabase database =
        await $FloorAppDatabase.databaseBuilder('database.db').build();
    final start_date = startdate.millisecondsSinceEpoch;
    final end_date = enddate.millisecondsSinceEpoch;

    final List<Pair<DateTime, double>> list =
        (await database.database.rawQuery("""
      SELECT $mycondition as date,
        AVG(heart) AS heart
      FROM 
        HeartDaily
      WHERE 
        dateTime > $start_date AND dateTime < $end_date
      GROUP BY $mycondition
      ORDER BY 
        date ASC;"""))
            .map((e) =>
                Pair(DateTime.parse(e['date'] as String), e['heart'] as double))
            .toList();
    // Pass list of key: value pairs to map
    return {for (var item in list) item.left: item.right};
  } //getMap

  //Function to visualize plot
  Container _buildPlotHeart(
      BuildContext context, Map<DateTime, double> hearts, Map<DateTime, double> prevhearts) {
    return Container(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // if heart data is not available and download if false, display temporary heart image
          // otherwise, return heart data plot
          child: (hearts.isEmpty || !download)
              ? Center(
                  child: Image.asset('assets/images/heart.png',
                      width: 125, height: 125))
              : _buildPlotWithDataHeart(context, hearts, prevhearts),
        ),
      ),
    );
  } //buildPlotSteps

  //Function to build plot with data
  Widget _buildPlotWithDataHeart(
      BuildContext context, Map<DateTime, double> hearts, Map<DateTime, double> prevhearts) {
    // Create lower bound reference line for heart rate from min to max start and end date
    Map<DateTime, double> heartlower = {
      hearts.keys.reduce((a,b) => a.isBefore(b) ? a : b): 60, //min start date
      hearts.keys.reduce((a,b) => a.isAfter(b) ? a : b): 60 //max end date
    };
    // Create upper bound reference line for heart rate from min to max start and end date
    Map<DateTime, double> heartupper = {
      hearts.keys.reduce((a,b) => a.isBefore(b) ? a : b): 100, //min start date
      hearts.keys.reduce((a,b) => a.isAfter(b) ? a : b): 100 //max end date
    };
    // Update datetime values for previous week heart data to current week date time to align with current week 
    prevhearts = { 
      for (var element in prevhearts.entries) element.key.add(Duration(days: 7)) : element.value 
      };
    // Create chart from LineChart class that includes heart data from current and previous week, as well as the two reference lines
    LineChart chart = LineChart.fromDateTimeMaps(
      [prevhearts, heartlower, heartupper, hearts],
      [Colors.orange, Colors.red, Colors.black, Colors.blue],
      ['Heart Rate', 'Heart Rate', 'Heart Rate', 'Heart Rate'],
      yAxisName: 'Heart Rate',
    );
    // Display legends and chart
    return Column(children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AnimatedLineChart(
                legends: const [Legend(
                            title: 'Patient HR',
                            color: Colors.blue,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Legend(
                            title: 'HR Lower',
                            color: Colors.red,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Legend(
                            title: 'HR Upper',
                            color: Colors.black,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Legend(
                            title: 'Previous Week',
                            color: Colors.orange,
                            showLeadingLine: true,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),],
                textStyle: TextStyle(color: Colors.black),
                chart,
                gridColor: Colors.black,
                toolTipColor: Colors.white,
              )))
    ]);
  } //buildPlotWithDataSteps

} //HomePage
