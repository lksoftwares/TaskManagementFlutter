import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagement/components/Login/login_screen.dart';


class AuthService {
  static Future<void> logout(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }
}
