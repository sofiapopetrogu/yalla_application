import 'package:flutter/material.dart';
import 'package:project_app/screens/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:project_app/screens/profile.dart';
import 'package:project_app/screens/community.dart';


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
          child: Container(),
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

} //HomePage
