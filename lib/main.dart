import 'package:flutter/material.dart';
import 'package:taskmanagement/components/Login/login_screen.dart';
import 'package:taskmanagement/components/Roles/roles_screen.dart';
import 'package:taskmanagement/components/WorkingStatus/daily_working_status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      home: RolesPage()
    );
  }
}

