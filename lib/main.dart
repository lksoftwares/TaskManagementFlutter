import 'package:flutter/material.dart';
import 'package:taskmanagement/components/Users/users_page.dart';
import 'package:taskmanagement/components/WorkingStatus/daily_working_status.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DailyWorkingStatus()
    );
  }
}

