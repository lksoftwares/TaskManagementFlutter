import 'package:taskmanagement/Packages/headerfiles.dart';


class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Roles', 'icon': Icons.people_alt_rounded, 'color': Colors.blue, 'page': RolesPage()},
    {'title': 'Users', 'icon': Icons.person, 'color': Colors.orange, 'page': UsersPage()},
    {'title': 'User Role', 'icon': Icons.supervised_user_circle_outlined, 'color': Colors.purple, 'page': UserroleScreen()},
    {'title': 'Working Status', 'icon': Icons.task, 'color': Colors.green, 'page': DailyWorkingStatus()},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        onLogout: () => AuthService.logout(context),
      ),      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: dashboardItems.length,
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => item['page'],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: item['color'], width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 40, color: item['color']),
                    SizedBox(height: 8),
                    Text(item['title'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}