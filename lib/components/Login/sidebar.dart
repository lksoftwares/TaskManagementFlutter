import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagement/components/widgetmethods/sidebar_method.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String username = 'no user';
  String role = 'No Role';
  String userImage = ''; // Add variable to store user image URL or asset path

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user_Name') ?? 'no user';
      role = prefs.getString('role_Name') ?? 'No Role';
      userImage = prefs.getString('user_image') ?? ''; // Assuming you stored an image URL or path
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF005296),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'images/Logo.png',
                      width: 70,
                      height: 70,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Welcome, ${username}!(${role})',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 800,
            color: Colors.grey[200],
            child: Column(
              children: [
                buildListTile(Icons.people_alt_rounded, 'Roles', '/roles', context),
                buildListTile(Icons.person, 'Users', '/users', context),
                buildListTile(Icons.supervised_user_circle_outlined, 'User Roles', '/userrole', context),
                buildListTile(Icons.task, 'Working Status', '/status', context),
                buildListTile(Icons.group, 'Team', '/team', context),
                buildListTile(Icons.emoji_people, 'Team Members', '/teammember', context),
                buildListTile(Icons.note_alt_outlined, 'Projects', '/project', context),
                buildListTile(Icons.login_sharp, 'User Logs', '/userlogs', context),
                buildListTile(Icons.calendar_month, 'Working Days', '/workingdays', context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
