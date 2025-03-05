import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:taskmanagement/components/WorkingStatus/daily_working_status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _checkDeveloperOptions(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DailyWorkingStatus(),
    );
  }

  Future<void> _checkDeveloperOptions(BuildContext context) async {
    bool isDeveloperOptionsEnabled = await _isDeveloperOptionsEnabled();

    if (isDeveloperOptionsEnabled) {
      Fluttertoast.showToast(
        msg: "Developer Options is ON!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<bool> _isDeveloperOptionsEnabled() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.isPhysicalDevice && androidInfo.version.sdkInt >= 30;
  }
}

// import 'package:flutter/material.dart';
// import 'package:taskmanagement/components/Splash/splash_screen.dart';
// import 'package:taskmanagement/components/Team/team_members_screen.dart';
// import 'package:taskmanagement/components/widgetmethods/routes_method.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       initialRoute: '/',
//       routes: AppRoutes.getRoutes(),
//       onGenerateRoute: (settings) {
//         return MaterialPageRoute(builder: (context) => SplashScreen());
//       },
//     );
//   }
// }
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mobile_number/mobile_number.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String _mobileNumber = '';
//   bool _isPermissionGranted = false;
//   List<SimCard> _simCard = <SimCard>[];
//
//   @override
//   void initState() {
//     super.initState();
//     MobileNumber.listenPhonePermission((isPermissionGranted) {
//       if (isPermissionGranted) {
//         _isPermissionGranted = isPermissionGranted;
//         initMobileNumberState();
//       } else {
//         _showPermissionDeniedDialog();
//       }
//     });
//
//     initMobileNumberState();
//   }
//
//   Future<void> initMobileNumberState() async {
//     if (!await MobileNumber.hasPhonePermission) {
//       await MobileNumber.requestPhonePermission;
//       return;
//     } else {
//       _isPermissionGranted = true;
//     }
//
//     try {
//       _mobileNumber = (await MobileNumber.mobileNumber) ?? 'Unknown';
//       _simCard = (await MobileNumber.getSimCards) ?? <SimCard>[];
//       _showDataDialog();
//     } on PlatformException catch (e) {
//       debugPrint("Failed to get mobile number because of '${e.message}'");
//       _showErrorDialog(e.message ?? 'Unknown error');
//     }
//
//     if (!mounted) return;
//
//     setState(() {});
//   }
//
//   void _showDataDialog() {
//     String simCardData = _simCard
//         .map((SimCard sim) =>
//     'Sim Card Number: (${sim.countryPhonePrefix}) - ${sim.number}\n')
//         .join();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Mobile Number and Sim Card Info'),
//           content: SingleChildScrollView(
//             child: Text(
//               'Mobile Number: $_mobileNumber\n\n'
//                   'Permission Granted: $_isPermissionGranted\n\n'
//                   'Sim Card Data:\n$simCardData',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showErrorDialog(String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(errorMessage),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showPermissionDeniedDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Permission Denied'),
//           content: Text('Permission to access phone information was denied.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget fillCards() {
//     List<Widget> widgets = _simCard
//         .map((SimCard sim) => Text(
//         'Sim Card Number: (${sim.countryPhonePrefix}) - ${sim.number}\n'))
//         .toList();
//     return Column(children: widgets);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Mobile Number example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Text('Permission for access sim card: $_isPermissionGranted\n'),
//               fillCards()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }