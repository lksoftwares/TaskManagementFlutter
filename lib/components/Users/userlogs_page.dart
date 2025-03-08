import 'package:flutter/material.dart';
import 'package:taskmanagement/components/widgetmethods/textstyle_method.dart';
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
            'userEmail': role['userEmail'] ?? 'UnknownEmail',
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

  Map<String, List<Map<String, dynamic>>> groupLogsByUser() {
    Map<String, List<Map<String, dynamic>>> groupedLogs = {};

    for (var log in userlogs) {
      String userName = log['userName'];
      if (!groupedLogs.containsKey(userName)) {
        groupedLogs[userName] = [];
      }
      groupedLogs[userName]!.add(log);
    }

    return groupedLogs;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedLogs = groupLogsByUser();

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
                    children: groupedLogs.entries.map((entry) {
                      String userName = entry.key;
                      List<Map<String, dynamic>> logs = entry.value;

                      Map<String, dynamic> userInfo = {
                        'Username': '$userName (${logs.first['roleName']})',
                        '': '',
                        'UserEmail': logs.first['userEmail'],
                      };


                      return buildUserCard(
                        userFields: userInfo,
                        additionalContent: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: logs.map((log) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Text(
                                      'Login Time         : ',
                                      style: AppTextStyle.boldTextStyle(),
                                    ),
                                    Text(
                                      '${log['loginTime']}',
                                      style: AppTextStyle.regularTextStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7,),
                                Row(
                                  children: [
                                    Text(
                                      'IP Address         : ',
                                      style: AppTextStyle.boldTextStyle(),
                                    ),
                                    Text(
                                      '${log['ipAddress']}',
                                      style: AppTextStyle.regularTextStyle(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 7,),

                                Row(
                                  children: [
                                    Text(
                                      'Device Id            : ',
                                      style: AppTextStyle.boldTextStyle(),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${log['deviceId']}',
                                        style: AppTextStyle.regularTextStyle(),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),

Divider(color: Colors.grey,),
                                SizedBox(height: 5),
                              ],
                            );
                          }).toList(),
                        ),
                      );


                    }).toList(),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
