import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    Timer(Duration(seconds: 5), () {
      Navigator.pushNamed(context, '/login');
    });
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF005296),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/Logo.png',
                width: 135,
                height: 135,
              ),
              SizedBox(height: 10),
              Text(
                "Task Management",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "Real-time Maintenance, and Seamless reporting for Tasks",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Version: $appVersion',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
