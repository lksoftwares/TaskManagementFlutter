import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagement/Packages/headerfiles.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Roles', 'icon': Icons.people_alt_rounded, 'color': Colors.blue, 'route': '/roles'},
    {'title': 'Users', 'icon': Icons.person, 'color': Colors.orange, 'route': '/users'},
    {'title': 'User Role', 'icon': Icons.supervised_user_circle_outlined, 'color': Colors.purple, 'route': '/userrole'},
    {'title': 'Working Status', 'icon': Icons.task, 'color': Colors.green, 'route': '/status'},
    {'title': 'Team', 'icon': Icons.group, 'color': Colors.brown, 'route': '/team'},
    {'title': 'Team Members', 'icon': Icons.emoji_people, 'color': Colors.red, 'route': '/teammember'},
    {'title': 'Projects', 'icon': Icons.note_alt_outlined, 'color': Colors.deepPurple, 'route': '/project'},
    {'title': 'UserLogs', 'icon': Icons.login_sharp, 'color': Colors.teal, 'route': '/userlogs'},
    {'title': 'Working Days', 'icon': Icons.calendar_month, 'color': Colors.pinkAccent, 'route': '/workingdays'},
  ];

  Future<Map<String, String>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('user_Name') ?? 'Unknown User';
    String roleName = prefs.getString('role_Name') ?? 'No Role';
    return {'user_name': userName, 'role_name': roleName};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        onLogout: () => AuthService.logout(context),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${userData['user_name']}!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${userData['role_name']}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0,bottom: 16.0),
                    itemCount: dashboardItems.length,
                    itemBuilder: (context, index) {
                      final item = dashboardItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: item['color'], width: 2),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          onTap: () {
                            Navigator.pushNamed(context, item['route']);
                          },
                          leading: Icon(item['icon'], size: 30, color: item['color']),
                          title: Text(
                            item['title'],
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          tileColor: item['color'].withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
