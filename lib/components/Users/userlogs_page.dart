import 'package:flutter/material.dart';
import '../widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/card_widget.dart';
import '../widgetmethods/logout _method.dart';
import '../widgetmethods/no_data_found.dart';
import '../widgetmethods/toast_method.dart';

class UserlogsPage extends StatefulWidget {
  const UserlogsPage({super.key});

  @override
  State<UserlogsPage> createState() => _UserlogsPageState();
}

class _UserlogsPageState extends State<UserlogsPage> {
  List<Map<String, dynamic>> userlogs = [];
  String? token;

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    fetchUserlogs();
  }


  Future<void> fetchUserlogs() async {
    setState(() {
      isLoading = true;
    });

    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'User/GetUserLogs',
    );
    print('Response: $response');
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        userlogs = List<Map<String, dynamic>>.from(
          response['apiResponse'].map((role) => {
            'logId': role['logId'] ?? 0,
            'deviceId': role['deviceId'] ?? 'Unknown device',
            'ipAddress': role['ipAddress'] ?? 'Unknown ip',
            'loginTime': role['loginTime'] ?? '',
            'roleName': role['roleName'] ?? 'Unknown role',
            'userName': role['userName'] ?? 'Unknown user',
            'userEmail': role['roleName'] ?? 'UnknownEmail',

          }),
        );
      });
    } else {
      showToast(msg: response['message'] ?? 'Failed to load userlogs');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'User Logs',
        onLogout: () => AuthService.logout(context),
      ),
      body: RefreshIndicator(
        onRefresh: fetchUserlogs,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (userlogs.isEmpty)
                  NoDataFoundScreen()
                else
                  Column(
                    children: userlogs.map((user) {
                      Map<String, dynamic> userlogsFields = {
                        'Username': user['userName'],
                        'Rolename:': user['roleName'],
                        'UserEmail': user['userEmail'],
                        'LoginTime': user['loginTime'],
                        'DeviceId': user['deviceId'],
                        'IPAddress': user['ipAddress'],
                      };
                      return buildUserCard(
                        userFields: userlogsFields,
                      );
                    }).toList(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}