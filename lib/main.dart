import 'package:flutter/material.dart';
import 'package:taskmanagement/components/Team/team_members_screen.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeamMembersScreen(),
    );
  }
}

