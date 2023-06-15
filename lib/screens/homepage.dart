import 'package:fl_animated_linechart/common/pair.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:project_app/database/steps/steps_daily.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Dashboard';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<DateTime, double> stepsList = Map();
  DateTime startdate = DateTime.now().subtract(Duration(days: 8));
  DateTime enddate = DateTime.now().subtract(Duration(days: 1));
  String mycondition = "DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'";
  /*
      for group by day
      DATE(dateTime / 1000, 'unixepoch') 
      for group by hour
      DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':00:00'
      for group by minute
      DATE(dateTime / 1000, 'unixepoch') || ' ' || strftime('%H',  dateTime / 1000, 'unixepoch') || ':' || strftime('%M',  dateTime / 1000, 'unixepoch') || ':00'
   */

  @override
  Widget build(BuildContext context) {
    //initialize stepPlot

    Container stepPlot = _buildPlot(context, stepsList);

    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
        backgroundColor: Colors.teal, // Set the background color to teal
      ),
      // await inserting data and then call other DAOs in the body
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //clear table before inserting steps
          await Provider.of<DatabaseRepository>(context, listen: false)
              .deleteAllSteps();
          final steps = await Data_Access.getStepWeek(startdate, enddate);
          await Provider.of<DatabaseRepository>(context, listen: false)
              .database
              .stepDao
              .insertMultSteps(steps
                  .map((step) => Steps_Daily(
                      steps: step.value,
                      dateTime: step.time,
                      patient: step.patient))
                  .toList());

          final AppDatabase database = await $FloorAppDatabase.databaseBuilder('database.db').build();
          final start_date = startdate.millisecondsSinceEpoch;
          final end_date = enddate.millisecondsSinceEpoch;

          final List<Pair<DateTime, double>> list = (await database.database.rawQuery("""
            SELECT $mycondition as date,
              AVG(steps) AS steps
            FROM 
              Steps_Daily
            WHERE 
              dateTime > $start_date AND dateTime < $end_date
            GROUP BY $mycondition
            ORDER BY 
              date ASC;""")).map((e) {
                print(e);
                return e;
              }).map( 
                (e) => Pair(DateTime.parse(e['date'] as String), e['steps'] as double)
              ).toList();

          setState(() {
              stepsList = { for (var item in list)   item.left:item.right };;
          });

        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  final result = await Authentication.isImpactUp();
                  final message = result
                      ? 'IMPACT backend is up!'
                      : 'IMPACT backend is down!';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
                child: Text('Ping IMPACT')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final result = await Authentication.getAndStoreTokens();
                  final message =
                      result == 200 ? 'Request successful' : 'Request failed';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
                child: Text('Get tokens')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  final access = sp.getString('access');
                  print(access);
                  final refresh = sp.getString('refresh');
                  final message = access == null
                      ? 'No stored tokens'
                      : 'access: $access; refresh: $refresh';
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
                child: Text('Print tokens')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  final refresh = sp.getString('refresh');
                  final message;
                  if (refresh == null) {
                    message = 'No stored tokens';
                  } else {
                    final result = await Authentication.refreshTokens();
                    message =
                        result == 200 ? 'Request successful' : 'Request failed';
                  } //if-else
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(message)));
                },
                child: Text('Refresh tokens')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  await sp.remove('access');
                  await sp.remove('refresh');
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text('Tokens have been deleted')));
                },
                child: Text('Delete tokens')),
            ElevatedButton(
                onPressed: () async {
                  //final statusOK = await Data_Access.getStep();

                  //final message = statusOK
                  //   ? 'Request successful'
                  // : 'Request failed';

                  final steps = await Data_Access.getStep();

                  //convert list to string
                  var final_message = steps
                      .map((e) => e.time.toString() + ' ' + e.value.toString())
                      .join('\n');

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(final_message)));
                },
                child: Text('Get Step Day')),
            ElevatedButton(
                onPressed: () async {
                  //final statusOK = await Data_Access.getStep();

                  //final message = statusOK
                  //   ? 'Request successful'
                  // : 'Request failed';

                  final heart = await Data_Access.getHeart();

                  //convert list to string
                  var final_message = heart
                      .map((e) => e.time.toString() + ' ' + e.value.toString())
                      .join('\n');

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(final_message)));
                },
                child: Text('Get Heart Day')),
            stepPlot,
          ],
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
  Container _buildPlot(BuildContext context, Map<DateTime, double> steps) {
    return Container(
      height: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: steps.isEmpty
              ? Center(
                  child: Text(
                    'No steps data',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              : _buildPlotWithData(context, steps),
        ),
      ),
    );
  } //buildPlot

  //Function to build plot with data
  Widget _buildPlotWithData(BuildContext context, Map<DateTime, double> steps) {

    LineChart chart;

    chart = LineChart.fromDateTimeMaps(
      [steps],
      [Colors.blue],
      ['Steps'],
      //showLegends: true,
      //legendPosition: LegendPosition.bottom,
      //legendStyle: TextStyle(color: Colors.black),
      //chartValueStyle: TextStyle(color: Colors.black),
      //dateTimeFactory: const LocalDateTimeFactory(),
    );
    return Column(children: [
      Expanded(
          child: AnimatedLineChart(
        chart,
        gridColor: Colors.black,
        toolTipColor: Colors.black,
      ))
    ]);
  } //buildPlotWithData
} //HomePage
