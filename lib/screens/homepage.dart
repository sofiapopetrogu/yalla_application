import 'package:flutter/material.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project_app/screens/profile.dart';
import 'package:project_app/screens/community.dart';
import 'package:project_app/screens/settings.dart';
import 'package:project_app/util/authentication.dart';
import 'package:project_app/util/data_access.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
        backgroundColor: Colors.teal, // Set the background color to teal
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
                  var final_message = steps.map(
                    (e) => e.time.toString() + ' ' + e.value.toString()
                  ).join('\n'
                  );
   
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text(final_message)));
                },
                child: Text('Get Step')),
                ElevatedButton(
                onPressed: () async {
                  //final statusOK = await Data_Access.getStep();

                  //final message = statusOK
                   //   ? 'Request successful'
                     // : 'Request failed';

                  final heart = await Data_Access.getHeart();

                  //convert list to string
                  var final_message = heart.map(
                    (e) => e.time.toString() + ' ' + e.value.toString()
                  ).join('\n'
                  );
   
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(content: Text(final_message)));
                },
                child: Text('Get Heart')),
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
          }
           else if (index == 1) {
            _toCommunity(context);
          } 
          else if (index == 2) {
            _toSettings(context);
          }
        },
      ),
    );
  } //build

  void _toLoginPage(BuildContext context) async{
    //Unset the 'username' filed in SharedPreference 
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    //Pop the drawer first 
    Navigator.pop(context);
    //Then push to login
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
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

} //HomePage
