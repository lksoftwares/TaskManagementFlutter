import 'package:flutter/material.dart';
import 'package:taskmanagement/components/Login/login_screen.dart';
import 'package:taskmanagement/components/Projects/projects_screen.dart';
import 'package:taskmanagement/components/Roles/roles_screen.dart';
import 'package:taskmanagement/components/Splash/splash_screen.dart';
import 'package:taskmanagement/components/Team/team_members_screen.dart';
import 'package:taskmanagement/components/Team/team_screen.dart';
import 'package:taskmanagement/components/UserRole/userrole_screen.dart';
import 'package:taskmanagement/components/Users/users_page.dart';
import 'package:taskmanagement/components/WorkingStatus/daily_working_status.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginScreen(),
      '/roles': (context) => RolesPage(),
      '/users': (context) => UsersPage(),
      '/userrole': (context) => UserroleScreen(),
      '/status': (context) => DailyWorkingStatus(),
      '/team': (context) => TeamScreen(),
      '/teammember': (context) => TeamMembersScreen(),
      '/project': (context) => ProjectsScreen(),

    };
  }
}
