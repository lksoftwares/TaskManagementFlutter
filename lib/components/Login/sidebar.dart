import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.people_alt_rounded, color: Colors.white),
            title: Text(
              'Roles',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/roles');
            },
          ),

          ListTile(
            leading: Icon(Icons.people_alt_rounded, color: Colors.white),
            title: Text(
              'Roles',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/roles');
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text(
              'Users',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_outlined, color: Colors.white),
            title: Text(
              'User Roles',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/userrole');
            },
          ),
          ListTile(
            leading: Icon(Icons.task, color: Colors.white),
            title: Text(
              'Working Status',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/status');
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: Colors.white),
            title: Text(
              'Team',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/team');
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_people, color: Colors.white),
            title: Text(
              'Team Members',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/teammember');
            },
          ),
          ListTile(
            leading: Icon(Icons.note_alt_outlined, color: Colors.white),
            title: Text(
              'Projects',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/project');
            },
          ),
          ListTile(
            leading: Icon(Icons.login_sharp, color: Colors.white),
            title: Text(
              'User Logs',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/userlogs');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month, color: Colors.white),
            title: Text(
              'Working Days',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/workingdays');
            },
          ),
        ],
      ),
    );
  }
}
