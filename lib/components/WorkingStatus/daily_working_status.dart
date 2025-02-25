
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import '../widgetmethods/alert_widget.dart';
// import '../widgetmethods/api_method.dart';
// import '../widgetmethods/appbar_method.dart';
// import '../widgetmethods/datagrid_class.dart';
// import '../widgetmethods/datagrid_controller.dart';
// import '../widgetmethods/logout _method.dart';
// import '../widgetmethods/no_data_found.dart';
// import '../widgetmethods/toast_method.dart';
//
// class DailyWorkingStatus extends StatefulWidget {
//   const DailyWorkingStatus({super.key});
//
//   @override
//   State<DailyWorkingStatus> createState() => _DailyWorkingStatusState();
// }
//
// class _DailyWorkingStatusState extends State<DailyWorkingStatus> {
//   List<Map<String, dynamic>> roles = [];
//   List<Map<String, dynamic>> users = [];
//   String? token;
//   String? selectedUserId;
//   DataGridController _dataGridController = DataGridController();
//   bool isLoading = false;
//
//   List<ColumnConfig> getColumnsConfig() {
//     return [
//       ColumnConfig(
//         columnName: 'workingDesc  ',
//         labelText: 'Working Desc ',
//         visible: true,
//       ),
//
//       ColumnConfig(
//         columnName: 'workingDate  ',
//         labelText: 'Working Date  ',
//         visible: true,
//       ),
//       ColumnConfig(
//         columnName: 'createdAt',
//         labelText: 'Created At',
//         visible: true,
//         columnWidthMode: ColumnWidthMode.auto,
//       ),
//       ColumnConfig(
//         columnName: 'updatedAt ',
//         labelText: 'Updated At ',
//         visible: true,
//         columnWidthMode: ColumnWidthMode.auto,
//       ),
//
//     ];
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getData();
//   }
//
//   Future<void> _getData() async {
//     await fetchUsers();
//     await fetchWorking();
//   }
//
//   Future<void> fetchUsers() async {
//     final response = await new ApiService().request(
//       method: 'get',
//       endpoint: 'User/GetAllUsers',
//     );
//     print("responsesssss $response");
//     if (response['statusCode'] == 200 && response['apiResponse'] != null) {
//       setState(() {
//         users = List<Map<String, dynamic>>.from(response['apiResponse']);
//       });
//
//     } else {
//       showToast(msg: response['message'] ?? 'Failed to load users');
//     }
//   }
//
//
//   Future<void> fetchWorking() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     final response = await new ApiService().request(
//       method: 'get',
//       endpoint: 'WorkingStatus/GetWorkingStatus',
//     );
//     print('Response: $response');
//     if (response['statusCode'] == 200 && response['apiResponse'] != null) {
//       setState(() {
//         roles = List<Map<String, dynamic>>.from(
//           response['apiResponse'].map((role) => {
//             'workingDesc ': role['workingDesc'] ?? 'Unknown Desc',
//             'txnId': role['txnId'] ?? 0,
//             'workingDate ': role['workingDate'] ?? 'Unknown Date',
//             'createdAt': role['createdAt'] ?? '',
//             'updatedAt': role['updatedAt'] ?? '',
//           }),
//         );
//       });
//     } else {
//       showToast(msg: response['message'] ?? 'Failed to load roles');
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   void _confirmDeleteRole(int txnId) {
//     showCustomAlertDialog(
//       context,
//       title: 'Delete Working Desc',
//       content: Text('Are you sure you want to delete this Description?'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             _deleteRole(txnId);
//             Navigator.pop(context);
//           },
//           child: Text('Delete'),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _deleteRole(int txnId) async {
//
//     final response = await new ApiService().request(
//       method: 'delete',
//       endpoint: 'WorkingStatus/deleteWorkingStatus/$txnId',
//     );
//     print("eeeggggggg $response");
//     if (response['statusCode'] == 200) {
//       String message = response['message'] ?? 'Working Desc deleted successfully';
//       showToast(msg: message, backgroundColor: Colors.green);
//       fetchWorking();
//     } else {
//       String message = response['message'] ?? 'Failed to delete Working Desc';
//       showToast(msg: message);
//     }
//   }
//
//
//   void _showAddWorkingModal() {
//     String workingDesc = '';
//
//     InputDecoration inputDecoration = InputDecoration(
//       labelText: 'Working Desc',
//       border: OutlineInputBorder(),
//     );
//     fetchUsers();
//
//     showCustomAlertDialog(
//       context,
//       title: 'Add Working Desc',
//       content: Container(
//         height: 130,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               onChanged: (value) => workingDesc = value,
//               decoration: inputDecoration,
//             ),
//             SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: selectedUserId,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedUserId = newValue;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Select User',
//                 border: OutlineInputBorder(),
//               ),
//               items: users.map<DropdownMenuItem<String>>((user) {
//                 return DropdownMenuItem<String>(
//                   value: user['userId'].toString(),
//                   child: Text(user['userName'] ?? 'Unknown User'),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (workingDesc.isEmpty) {
//               showToast(msg: 'Please fill in the Working desc');
//             } else if (selectedUserId == null) {
//               showToast(msg: 'Please select a user');
//             } else {
//               _addWorking(workingDesc, selectedUserId!);
//             }
//           },
//           child: Text('Add'),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _addWorking(String workingDesc, String userId) async {
//     final response = await new ApiService().request(
//       method: 'post',
//       endpoint: 'WorkingStatus/SaveWorkingStatus',
//       body: {
//         'workingDesc': workingDesc,
//         'userId': selectedUserId
//       },
//     );
//     if (response.isNotEmpty && response['statusCode'] == 200) {
//       fetchWorking();
//       showToast(
//         msg: response['message'] ?? 'Working Desc added successfully',
//         backgroundColor: Colors.green,
//       );
//       Navigator.pop(context);
//     } else {
//       showToast(
//         msg: response['message'] ?? 'Failed to add Working Desc',
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Working Status',
//         onLogout: () => AuthService.logout(context),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.add, color: Colors.blue, size: 30),
//                     onPressed: _showAddWorkingModal,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               if (isLoading)
//                 Center(child: CircularProgressIndicator())
//               else if (roles.isEmpty)
//                 NoDataFoundScreen()
//               else
//                 Column(
//                   children: [
//                     Container(
//                       height: 480,
//                       child: SfDataGridTheme(
//                         data: SfDataGridThemeData(
//                           headerHoverColor: Colors.yellow,
//                           rowHoverColor: Colors.blueAccent[100],
//                           gridLineColor: Colors.black,
//                           gridLineStrokeWidth: 1.0,
//                           headerColor: Colors.blueAccent[100],
//                         ),
//                         child: SfDataGrid(
//                           headerGridLinesVisibility: GridLinesVisibility.both,
//                           gridLinesVisibility: GridLinesVisibility.both,
//                           allowSorting: true,
//                           source: RoleDataSource(
//                             roles: roles,
//                             onDeleteRole: _confirmDeleteRole,
//                           ),
//                           columns: buildDataGridColumns(getColumnsConfig(), showDeleteColumn: true),
//                           controller: _dataGridController,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class RoleDataSource extends DataGridSource {
//   final List<Map<String, dynamic>> roles;
//   final Function(int txnId) onDeleteRole;
//
//   RoleDataSource({
//     required this.roles,
//     required this.onDeleteRole,
//   });
//
//   @override
//   List<DataGridRow> get rows => roles.map<DataGridRow>((role) {
//     return DataGridRow(cells: [
//       DataGridCell<String>(columnName: 'workingDesc ', value: role['workingDesc ']),
//       DataGridCell<int>(columnName: 'txnId', value: role['txnId'] ?? 0),
//       DataGridCell<String>(columnName: 'workingDate ', value: role['workingDate ']),
//       DataGridCell<String>(columnName: 'createdAt', value: role['createdAt']),
//       DataGridCell<String>(columnName: 'updatedAt', value: role['updatedAt']),
//     ]);
//   }).toList();
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     final txnId = row.getCells()[1].value as int;
//     final workingDesc  = row.getCells()[0].value as String;
//     final workingDate  = row.getCells()[2].value as String;
//     final createdAt = row.getCells()[3].value as String;
//     final updatedAt = row.getCells()[4].value as String;
//
//     return DataGridRowAdapter(cells: [
//       Container(
//         padding: EdgeInsets.all(8.0),
//         alignment: Alignment.centerLeft,
//         child: Text(workingDesc ),
//       ),
//       // Container(
//       //   padding: EdgeInsets.all(8.0),
//       //   alignment: Alignment.centerLeft,
//       //   child: Text(txnId.toString()),  // Display txnId
//       // ),
//       Container(
//         padding: EdgeInsets.all(8.0),
//         alignment: Alignment.centerLeft,
//         child: Text(workingDate )
//       ),
//       Container(
//         padding: EdgeInsets.all(8.0),
//         alignment: Alignment.centerLeft,
//         child: Text(createdAt),
//       ),
//       Container(
//         padding: EdgeInsets.all(8.0),
//         alignment: Alignment.centerLeft,
//         child: Text(updatedAt),
//       ),
//       Container(
//         alignment: Alignment.center,
//         child: IconButton(
//           icon: Icon(Icons.edit, color: Colors.green),
//           onPressed: () {
//             // onEditRole(roleId, roleName);
//           },
//         ),
//       ),
//       Container(
//         alignment: Alignment.center,
//         child: IconButton(
//           icon: Icon(Icons.delete, color: Colors.red),
//           onPressed: () {
//              onDeleteRole(txnId);
//           },
//         ),
//       ),
//     ]);
//   }
// }


import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:taskmanagement/components/widgetmethods/card_widget.dart';
import '../widgetmethods/alert_widget.dart';
import '../widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/datagrid_class.dart';
import '../widgetmethods/logout _method.dart';
import '../widgetmethods/no_data_found.dart';
import '../widgetmethods/toast_method.dart';

class DailyWorkingStatus extends StatefulWidget {
  const DailyWorkingStatus({super.key});

  @override
  State<DailyWorkingStatus> createState() => _DailyWorkingStatusState();
}

class _DailyWorkingStatusState extends State<DailyWorkingStatus> {
  List<Map<String, dynamic>> roles = [];
  List<Map<String, dynamic>> users = [];
  String? token;
  String? selectedUserId;

  bool isLoading = false;

  List<ColumnConfig> getColumnsConfig() {
    return [
      ColumnConfig(
        columnName: 'workingDesc  ',
        labelText: 'Working Desc ',
        allowSorting: true,
        visible: true,
      ),
      ColumnConfig(
        columnName: 'workingDate  ',
        labelText: 'Working Date  ',
        visible: true,
      ),
      ColumnConfig(
        columnName: 'createdAt',
        labelText: 'Created At',
        visible: true,
        columnWidthMode: ColumnWidthMode.auto,
      ),
      ColumnConfig(
        columnName: 'updatedAt ',
        labelText: 'Updated At ',
        visible: true,
        columnWidthMode: ColumnWidthMode.auto,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
 await fetchWorking();
 await fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'User/GetAllUsers',
    );
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        users = List<Map<String, dynamic>>.from(response['apiResponse']);
      });
    } else {
      showToast(msg: 'Failed to load users');
    }
  }


  Future<void> fetchWorking() async {
    setState(() {
      isLoading = true;
    });

    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'WorkingStatus/GetWorkingStatus',
    );
    print('Response: $response');
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        roles = List<Map<String, dynamic>>.from(
          response['apiResponse'].map((role) => {
            'txnId': role['txnId'] ?? 0,
            'workingDesc': role['workingDesc'] ?? 'Unknown Desc',
            'workingDate': role['workingDate'] ?? 'Unknown',
            'createdAt': role['createdAt'] ?? '',
            'updatedAt': role['updatedAt'] ?? '',
          }),
        );
      });
    } else {
      showToast(msg: response['message'] ?? 'Failed to load roles');
    }
    setState(() {
      isLoading = false;
    });
  }




    void _showAddWorkingModal() {
    String workingDesc = '';

    InputDecoration inputDecoration = InputDecoration(
      labelText: 'Working Desc',
      border: OutlineInputBorder(),
    );
    fetchUsers();

    showCustomAlertDialog(
      context,
      title: 'Add Working Desc',
      content: Container(
        height: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => workingDesc = value,
              decoration: inputDecoration,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedUserId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedUserId = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select User',
                border: OutlineInputBorder(),
              ),
              items: users.map<DropdownMenuItem<String>>((user) {
                return DropdownMenuItem<String>(
                  value: user['userId'].toString(),
                  child: Text(user['userName'] ?? 'Unknown User'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (workingDesc.isEmpty) {
              showToast(msg: 'Please fill in the Working desc');
            } else if (selectedUserId == null) {
              showToast(msg: 'Please select a user');
            } else {
              _addWorking(workingDesc, selectedUserId!);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Future<void> _addWorking(String workingDesc, String userId) async {
    final response = await new ApiService().request(
      method: 'post',
      endpoint: 'WorkingStatus/SaveWorkingStatus',
      body: {
        'workingDesc': workingDesc,
        'userId': selectedUserId
      },
    );
    if (response.isNotEmpty && response['statusCode'] == 200) {
      fetchWorking();
      showToast(
        msg: response['message'] ?? 'Working Desc added successfully',
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    } else {
      showToast(
        msg: response['message'] ?? 'Failed to add Working Desc',
      );
    }
  }
  void _confirmDeleteRole(int txnId) {
    showCustomAlertDialog(
      context,
      title: 'Delete Working Desc',
      content: Text('Are you sure you want to delete this Description?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteRole(txnId);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _deleteRole(int txnId) async {

    final response = await new ApiService().request(
      method: 'delete',
      endpoint: 'WorkingStatus/deleteWorkingStatus/$txnId',
    );
    print("eeeggggggg $response");
    if (response['statusCode'] == 200) {
      String message = response['message'] ?? 'Working Desc deleted successfully';
      showToast(msg: message, backgroundColor: Colors.green);
      fetchWorking();
    } else {
      String message = response['message'] ?? 'Failed to delete Working Desc';
      showToast(msg: message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Working Status',
        onLogout: () => AuthService.logout(context),
      ),
      body: RefreshIndicator(
        onRefresh: fetchWorking,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.blue, size: 30),
                      onPressed: _showAddWorkingModal,
                    ),
                  ],
                ),

                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (roles.isEmpty)
                  NoDataFoundScreen()
                else
                  Column(
                    children: roles.map((role) {
                      Map<String, dynamic> workingFields = {
                        'WorkingDesc': role['workingDesc'],
                        'WorkingDate': role['workingDate'],
                        'CreatedAt': role['createdAt'],
                      };

                      return buildUserCard(
                        userFields: workingFields,
                        onDelete: () => _confirmDeleteRole(role['txnId']),
                        showDelete: true
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