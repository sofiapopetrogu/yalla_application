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

class _HomePageState extends State<HomePage> {
   void getPatients(){
     Data_Access.getPatients().then((value) {
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
    getPatients();
  }
  Map<DateTime, double> stepsList = Map();
  Map<DateTime, double> heartList = Map();
  DateTime enddate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(seconds: 1));
  DateTime startdate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(seconds: 1))
          .subtract(Duration(days: 7));
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


  @override
  Widget build(BuildContext context) {
    //initialize stepPlot

    Container stepPlot = _buildPlotSteps(context, stepsList);
    Container heartPlot = _buildPlotHeart(context, heartList);

    
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
        backgroundColor: Colors.teal, // Set the background color to teal
      ),
      // await inserting data and then call other DAOs in the body
      floatingActionButton: patients.isEmpty ? null:FloatingActionButton(
        onPressed: () async {
          //clear table before inserting steps
          await Provider.of<DatabaseRepository>(context, listen: false)
              .deleteAllSteps();
          await Provider.of<DatabaseRepository>(context, listen: false)
              .deleteAllHeart();
          await Authentication.getAndStoreTokens();
          final steps = await Data_Access.getStepWeek(
              DateTime.now().subtract(Duration(days: 8)),
              DateTime.now().subtract(Duration(days: 1)), currentpatient);
          final hearts = await Data_Access.getHeartWeek(
              DateTime.now().subtract(Duration(days: 8)),
              DateTime.now().subtract(Duration(days: 1)), currentpatient);
          await Provider.of<DatabaseRepository>(context, listen: false)
              .database
              .stepDao
              .insertMultSteps(steps
                  .map((step) => Steps_Daily(
                      steps: step.value,
                      dateTime: step.time,
                      patient: step.patient))
                  .toList());
          await Provider.of<DatabaseRepository>(context, listen: false)
              .database
              .heartDao
              .insertMultHeart(hearts
                  .map((heart) => Heart_Daily(
                      heart: heart.value,
                      dateTime: heart.time,
                      patient: heart.patient))
                  .toList());

          final datastep = await getMapStep(startdate, enddate, mycondition);
          final dataheart = await getMapHeart(startdate, enddate, mycondition);

          setState(() {
            stepsList = datastep;
            heartList = dataheart;
          });
        },
        child: Icon(Icons.update),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
                  disabledHint: const Text("Loading"),
                  value: currentpatient,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      currentpatient = value!;
                    });
                  },
                  items: patients.isEmpty ? null: patients.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                      value: value.username,
                      child: Text(value.displayname),
                    )).toList(), 
                ),
          ] + (patients.isEmpty ? []:[  Row(
              children: [
                Expanded(
                  child: Column(children: [
                    const Padding(
                        padding:
                            const EdgeInsets.only(top: 30.0, left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Timeframe',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    ListTile(
                      title: const Text('Week'),
                      leading: Radio<String>(
                        value: 'Week',
                        groupValue: timewindow,
                        //if I'm selected, groupvalue will match value showing the filled button
                        onChanged: (String? value) async {
                          final datastep = await getMapStep(
                              enddate.subtract(Duration(days: 7)),
                              enddate,
                              mycondition);
                          final dataheart = await getMapHeart(
                              enddate.subtract(Duration(days: 7)),
                              enddate,
                              mycondition);
                          setState(() {
                            print("selected week");
                            timewindow = 'Week';
                            startdate = enddate.subtract(Duration(days: 7));
                            stepsList = datastep;
                            heartList = dataheart;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Day'),
                      leading: Radio<String>(
                        value: 'Day',
                        groupValue: timewindow,
                        //if I'm selected, groupvalue will match value showing the filled button
                        onChanged: (String? value) async {
                          final datastep = await getMapStep(
                              enddate.subtract(Duration(days: 1)),
                              enddate,
                              mycondition);
                          final dataheart = await getMapHeart(
                              enddate.subtract(Duration(days: 1)),
                              enddate,
                              mycondition);
                          setState(() {
                            print("selected day");
                            timewindow = 'Day';
                            startdate = enddate.subtract(Duration(days: 1));
                            stepsList = datastep;
                            heartList = dataheart;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Hour'),
                      leading: Radio<String>(
                        value: 'Hour',
                        groupValue: timewindow,
                        //if I'm selected, groupvalue will match value showing the filled button
                        onChanged: (String? value) async {
                          final datastep = await getMapStep(
                              enddate.subtract(Duration(hours: 1)),
                              enddate,
                              mycondition);
                          final dataheart = await getMapHeart(
                              enddate.subtract(Duration(hours: 1)),
                              enddate,
                              mycondition);
                          setState(() {
                            print("selected hour");
                            timewindow = 'Hour';
                            startdate =
                                enddate.subtract(Duration(hours: 1));
                            stepsList = datastep;
                            heartList = dataheart;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
                Expanded(
                    child: Column(
                  children: [
                    const Padding(
                        padding:
                            const EdgeInsets.only(top: 30.0, left: 30.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Grouping',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        )),
                    ListTile(
                      title: const Text('Day'),
                      leading: Radio<String>(
                        value: 'Day',
                        groupValue: groupby,
                        //if I'm selected, groupvalue will match value showing the filled button
                        onChanged: (String? value) async {
                          final datastep = await getMapStep(
                              startdate,
                              enddate,
                              "DATE(dateTime / 1000, 'unixepoch')");
                          final dataheart = await getMapHeart(
                              startdate,
                              enddate,
                              "DATE(dateTime / 1000, 'unixepoch')");
                          setState(() {
                            print("selected day");
                            groupby = 'Day';
                            mycondition =
                                "DATE(dateTime / 1000, 'unixepoch')";
                            stepsList = datastep;
                            heartList = dataheart;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Hour'),
                      leading: Radio<String>(
                        value: 'Hour',
                        groupValue: groupby,
                        //if I'm selected, groupvalue will match value showing the filled button
                        onChanged: (String? value) async {
                          final datastep = await getMapStep(
                              startdate,
                              enddate,
                              "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'");
                          final dataheart = await getMapHeart(
                              startdate,
                              enddate,
                              "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'");
                          setState(() {
                            print("selected hour");
                            groupby = 'Hour';
                            mycondition =
                                "DATE(dateTime / 1000, 'unixepoch')";
                            stepsList = datastep;
                            heartList = dataheart;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Minute'),
                      leading: Radio<String>(
                        value: 'Minute',
                        groupValue: groupby,
                        //if I'm selected, groupvalue will match value showing the filled button
                        onChanged: (String? value) async {
                          final datastep = await getMapStep(
                              startdate,
                              enddate,
                              "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'");
                          final dataheart = await getMapHeart(
                              startdate,
                              enddate,
                              "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'");
                          setState(() {
                            print("selected minute");
                            groupby = 'Minute';
                            mycondition =
                                "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'";
                            stepsList = datastep;
                            heartList = dataheart;
                          });
                        },
                      ),
                    ),
                  ],
                ))
              ],
            ),
            stepPlot, 
            heartPlot
          ]),
        ),
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          //TODO: Add icon for Dashboard
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
          if (index == 0) {
            _toProfile(context);
          } else if (index == 1) {
            _toCommunity(context);
          } else if (index == 2) {
            _toSettings(context);
          }
        },
      ),
    );
  } //build

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

  void _toProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void _toCommunity(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityHub()),
    );
  }

  void _toSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  //Function to built plot for steps
  Container _buildPlotSteps(BuildContext context, Map<DateTime, double> steps) {
    return Container(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: steps.isEmpty
              ? Center(
                  child: 
                  Image.asset('assets/images/walking.png',
                      width: 125, height: 125)
                )
              : _buildPlotWithDataSteps(context, steps),
        ),
      ),
    );
  } //buildPlotSteps

  //Function to build plot with data
  Widget _buildPlotWithDataSteps(
      BuildContext context, Map<DateTime, double> steps) {
    LineChart chart;

    chart = LineChart.fromDateTimeMaps(
      [steps],
      [Colors.blue],
      ['Steps'],
      yAxisName: 'Steps',
      //showLegends: true,
      //legendPosition: LegendPosition.bottom,
      //legendStyle: TextStyle(color: Colors.black),
      //chartValueStyle: TextStyle(color: Colors.black),
      //dateTimeFactory: const LocalDateTimeFactory(),
    );
    //AreaLineChart()
    return Column(children: [
      Expanded(
              child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedLineChart(
            textStyle: TextStyle(color: Colors.black),
            chart,
            gridColor: Colors.black,
            toolTipColor: Colors.black,
            //chartValueStyle: TextStyle(color: Colors.black),
          )))
    ]);
  } //buildPlotWithDataSteps

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
        Steps_Daily
      WHERE 
        dateTime > $start_date AND dateTime < $end_date
      GROUP BY $mycondition
      ORDER BY 
        date ASC;"""))
            .map((e) =>
                Pair(DateTime.parse(e['date'] as String), e['steps'] as double))
            .toList();
    return {for (var item in list) item.left: item.right};
  } //getMap

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
        Heart_Daily
      WHERE 
        dateTime > $start_date AND dateTime < $end_date
      GROUP BY $mycondition
      ORDER BY 
        date ASC;"""))
            .map((e) =>
                Pair(DateTime.parse(e['date'] as String), e['heart'] as double))
            .toList();
    return {for (var item in list) item.left: item.right};
  } //getMap

  //Function to built plot for steps
  Container _buildPlotHeart(
      BuildContext context, Map<DateTime, double> hearts) {
    return Container(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: hearts.isEmpty
              ? Center(
                  child: 
                  Image.asset('assets/images/heart.png',
                      width: 125, height: 125)
                )
              : _buildPlotWithDataHeart(context, hearts),
        ),
      ),
    );
  } //buildPlotSteps

  //Function to build plot with data
  Widget _buildPlotWithDataHeart(
      BuildContext context, Map<DateTime, double> hearts) {
    LineChart chart;

    chart = LineChart.fromDateTimeMaps(
      [hearts],
      [Colors.blue],
      ['Heart Rate'],
      yAxisName: 'Heart Rate',
      //showLegends: true,
      //legendPosition: LegendPosition.bottom,
      //legendStyle: TextStyle(color: Colors.black),
      //chartValueStyle: TextStyle(color: Colors.black),
      //dateTimeFactory: const LocalDateTimeFactory(),
    );
    return Column(children: [
      
          Expanded(
              child: Padding(
          padding: const EdgeInsets.all(10.0), child: AnimatedLineChart(
            textStyle: TextStyle(color: Colors.black),
            chart,
            gridColor: Colors.black,
            toolTipColor: Colors.black,
          )))
    ]);
  } //buildPlotWithDataSteps
} //HomePage
