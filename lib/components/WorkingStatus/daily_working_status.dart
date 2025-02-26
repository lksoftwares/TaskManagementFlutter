
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


// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:taskmanagement/components/widgetmethods/card_widget.dart';
// import '../widgetmethods/alert_widget.dart';
// import '../widgetmethods/api_method.dart';
// import '../widgetmethods/appbar_method.dart';
// import '../widgetmethods/datagrid_class.dart';
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
//
//   bool isLoading = false;
//
//   List<ColumnConfig> getColumnsConfig() {
//     return [
//       ColumnConfig(
//         columnName: 'workingDesc  ',
//         labelText: 'Working Desc ',
//         allowSorting: true,
//         visible: true,
//       ),
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
//  await fetchWorking();
//  await fetchUsers();
//   }
//
//   Future<void> fetchUsers() async {
//     final response = await new ApiService().request(
//       method: 'get',
//       endpoint: 'User/GetAllUsers',
//     );
//     if (response['statusCode'] == 200 && response['apiResponse'] != null) {
//       setState(() {
//         users = List<Map<String, dynamic>>.from(response['apiResponse']);
//       });
//     } else {
//       showToast(msg: 'Failed to load users');
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
//             'txnId': role['txnId'] ?? 0,
//             'workingDesc': role['workingDesc'] ?? 'Unknown Desc',
//             'workingDate': role['workingDate'] ?? 'Unknown',
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
//
//
//
//     void _showAddWorkingModal() {
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
//     void _showFullDescription(String workingDesc) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Working Description'),
//           content: SingleChildScrollView(
//             child: Text(workingDesc),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Working Status',
//         onLogout: () => AuthService.logout(context),
//       ),
//       body: RefreshIndicator(
//         onRefresh: fetchWorking,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.add, color: Colors.blue, size: 30),
//                       onPressed: _showAddWorkingModal,
//                     ),
//                     SizedBox(width: 10),
//
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 if (isLoading)
//                   Center(child: CircularProgressIndicator())
//                 else if (roles.isEmpty)
//                   NoDataFoundScreen()
//
//                   else
//                     Column(
//                       children: roles.map((role) {
//                         Map<String, dynamic> workingFields = {
//                           'UserName': role['userName'],
//                           'WorkingDesc': role['workingDesc'],
//                           'WorkingDate': role['workingDate'],
//                           'CreatedAt': role['createdAt'],
//                         };
//
//                         String shortenedWorkingDesc = role['workingDesc'].length > 50
//                             ? role['workingDesc'].substring(0,10) + '...'
//                             : role['workingDesc'];
//
//                         return buildUserCard(
//                           userFields: {
//                             'UserName': role['userName'],
//                             'WorkingDesc': shortenedWorkingDesc,
//                             'WorkingDate': role['workingDate'],
//                             'CreatedAt': role['createdAt'],
//                           },
//                           onDelete: () => _confirmDeleteRole(role['txnId']),
//                           showDelete: true,
//                           showView: true,
//                           onView: () => _showFullDescription(role['workingDesc']),
//
//                         );
//                       }).toList(),
//                     ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:taskmanagement/components/widgetmethods/card_widget.dart';
// import 'package:taskmanagement/components/widgetmethods/logout%20_method.dart';
// import '../widgetmethods/alert_widget.dart';
// import '../widgetmethods/api_method.dart';
// import '../widgetmethods/appbar_method.dart';
// import '../widgetmethods/datagrid_class.dart';
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
//
//   bool isLoading = false;
//
//   DateTime? fromDate;
//   DateTime? toDate;
//
//   TextEditingController fromController = TextEditingController();
//   TextEditingController toController = TextEditingController();
//
//   List<ColumnConfig> getColumnsConfig() {
//     return [
//       ColumnConfig(
//         columnName: 'workingDesc  ',
//         labelText: 'Working Desc ',
//         allowSorting: true,
//         visible: true,
//       ),
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
//     await fetchWorking();
//     await fetchUsers();
//   }
//
//   Future<void> fetchUsers() async {
//     final response = await new ApiService().request(
//       method: 'get',
//       endpoint: 'User/GetAllUsers',
//     );
//     if (response['statusCode'] == 200 && response['apiResponse'] != null) {
//       setState(() {
//         users = List<Map<String, dynamic>>.from(response['apiResponse']);
//       });
//     } else {
//       showToast(msg: 'Failed to load users');
//     }
//   }
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
//
//     if (response['statusCode'] == 200 && response['apiResponse'] != null) {
//       setState(() {
//         roles = List<Map<String, dynamic>>.from(
//           response['apiResponse'].map((role) {
//             String workingDateStr = role['workingDate'] ?? 'Unknown';
//             DateTime workingDate = DateFormat('dd-MM-yyyy HH:mm:ss').parse(workingDateStr);
//
//             return {
//               'txnId': role['txnId'] ?? 0,
//               'workingDesc': role['workingDesc'] ?? 'Unknown Desc',
//               'workingDate': workingDate,
//               'createdAt': role['createdAt'] ?? '',
//               'updatedAt': role['updatedAt'] ?? '',
//             };
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
//   List<Map<String, dynamic>> getFilteredRoles() {
//     if (fromDate == null || toDate == null) {
//       return roles;
//     }
//
//     return roles.where((role) {
//       DateTime roleDate = role['workingDate']; // Now we have DateTime
//       return roleDate.isAfter(fromDate!) && roleDate.isBefore(toDate!);
//     }).toList();
//   }
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
//     final response = await new ApiService().request(
//       method: 'delete',
//       endpoint: 'WorkingStatus/deleteWorkingStatus/$txnId',
//     );
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
//   void _showFullDescription(String workingDesc) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Working Description'),
//           content: SingleChildScrollView(
//             child: Text(workingDesc),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _selectFromDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null && pickedDate != fromDate) {
//       setState(() {
//         fromDate = pickedDate;
//         fromController.text = DateFormat('dd-MM-yyyy').format(fromDate!);
//       });
//     }
//   }
//
//   Future<void> _selectToDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null && pickedDate != toDate) {
//       setState(() {
//         toDate = pickedDate;
//         toController.text = DateFormat('dd-MM-yyyy').format(toDate!);
//       });
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
//       body: RefreshIndicator(
//         onRefresh: fetchWorking,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//
//                     Expanded(
//                       child: TextField(
//                         controller: fromController,
//                         decoration: InputDecoration(
//                           labelText: 'From Date',
//                           border: OutlineInputBorder(),
//                         ),
//                         readOnly: true,
//                         onTap: _selectFromDate,
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: toController,
//                         decoration: InputDecoration(
//                           labelText: 'To Date',
//                           border: OutlineInputBorder(),
//                         ),
//                         readOnly: true,
//                         onTap: _selectToDate,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add, color: Colors.blue, size: 30),
//                       onPressed: _showAddWorkingModal,
//                     ),
//                     SizedBox(width: 10),
//                   ],
//                 ),
//
//                 SizedBox(height: 20),
//
//                 // Show loading or filtered data
//                 if (isLoading)
//                   Center(child: CircularProgressIndicator())
//                 else if (getFilteredRoles().isEmpty)
//                   NoDataFoundScreen()
//                 else
//                   Column(
//                     children: getFilteredRoles().map((role) {
//                       Map<String, dynamic> workingFields = {
//                         'UserName': role['userName'],
//                         'WorkingDesc': role['workingDesc'],
//                         'WorkingDate': role['workingDate'],
//                         'CreatedAt': role['createdAt'],
//                       };
//
//                       String shortenedWorkingDesc = role['workingDesc'].length > 50
//                           ? role['workingDesc'].substring(0, 10) + '...'
//                           : role['workingDesc'];
//
//                       return buildUserCard(
//                         userFields: {
//                           'UserName': role['userName'],
//                           'WorkingDesc': shortenedWorkingDesc,
//                           'WorkingDate': DateFormat('dd-MM-yyyy HH:mm:ss').format(role['workingDate']),
//                           'CreatedAt': role['createdAt'],
//                         },
//                         onDelete: () => _confirmDeleteRole(role['txnId']),
//                         showDelete: true,
//                         showView: true,
//                         onView: () => _showFullDescription(role['workingDesc']),
//                       );
//                     }).toList(),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:taskmanagement/components/widgetmethods/card_widget.dart';
import '../widgetmethods/alert_widget.dart';
import '../widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/datagrid_class.dart';
import '../widgetmethods/logout _method.dart';
import '../widgetmethods/no_data_found.dart';
import '../widgetmethods/toast_method.dart';
import '../widgetmethods/dates_method.dart';

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
  DateTime? fromDate;
  DateTime? toDate;

  List<ColumnConfig> getColumnsConfig() {
    return [
      ColumnConfig(
        columnName: 'workingDesc',
        labelText: 'Working Desc',
        allowSorting: true,
        visible: true,
      ),
      ColumnConfig(
        columnName: 'workingDate',
        labelText: 'Working Date',
        visible: true,
      ),
      ColumnConfig(
        columnName: 'createdAt',
        labelText: 'Created At',
        visible: true,
        columnWidthMode: ColumnWidthMode.auto,
      ),
      ColumnConfig(
        columnName: 'updatedAt',
        labelText: 'Updated At',
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
          response['apiResponse'].map((role) {
            String workingDateStr = role['workingDate'] ?? 'Unknown';
            String formattedWorkingDate = 'Unknown';
            try {
              DateTime parsedDate = DateFormat("dd-MM-yyyy HH:mm:ss").parse(workingDateStr);
              formattedWorkingDate = DateFormat('dd-MM-yyyy').format(parsedDate);
            } catch (e) {
              print("Error parsing date: $e");
            }

            return {
              'txnId': role['txnId'] ?? 0,
              'userName': role['userName'] ?? 'Unknown userName',
              'workingDesc': role['workingDesc'] ?? 'Unknown Desc',
              'workingDate': formattedWorkingDate,
              'createdAt': role['createdAt'] ?? '',
              'updatedAt': role['updatedAt'] ?? '',
              'workingNote': role['workingNote'] ?? null,
            };
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


  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime(2000);
    }
  }


  List<Map<String, dynamic>> getFilteredData() {
    if (fromDate != null && toDate != null) {
      return roles.where((role) {
        DateTime workingDate = _parseDate(role['workingDate']);
        return (workingDate.isAtSameMomentAs(fromDate!) ||
            workingDate.isAfter(fromDate!)) &&
            (workingDate.isAtSameMomentAs(toDate!) ||
                workingDate.isBefore(toDate!));
      }).toList();
    }
    return roles;
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
      endpoint: 'WorkingStatus/AddWorkingStatus',
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

  void _showDatePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: fromDate != null && toDate != null
          ? DateTimeRange(start: fromDate!, end: toDate!)
          : null,
    ).then((pickedDateRange) {
      if (pickedDateRange != null) {
        setState(() {
          fromDate = pickedDateRange.start;
          toDate = pickedDateRange.end;
        });
      }
    });
  }


  void _showFullDescription(String workingDesc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Working Description'),
          content: SingleChildScrollView(
            child: Text(workingDesc),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
      endpoint: 'WorkingStatus/DeleteWorkingStatus/$txnId',
    );
    if (response.isNotEmpty && response['statusCode'] == 200) {
      fetchWorking();
      showToast(
        msg: response['message'] ?? 'Working Desc deleted successfully',
        backgroundColor: Colors.green,
      );
    } else {
      showToast(
        msg: response['message'] ?? 'Failed to delete Working Desc',
      );
    }
  }
  void _showWorkingNoteDialog(String? workingNote) {
    if (workingNote == null || workingNote.isEmpty) {
      showToast(msg: "No working note available");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Working Note"),
          content: SingleChildScrollView(
            child: Text(workingNote),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
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
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                          Icons.date_range, color: Colors.blue, size: 30),
                      onPressed: _showDatePicker,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  if (roles.isEmpty)
                    NoDataFoundScreen()
                  else
                    if (getFilteredData().isEmpty)
                      NoDataFoundScreen()
                    else
                      Column(
                        children: getFilteredData().map((role) {
                          Map<String, dynamic> workingFields = {
                            'UserName': role['userName'],
                            '': role['workingDate'],
                            'WorkingDesc': role['workingDesc'],
                            'CreatedAt': role['createdAt'],
                            'WorkingNote': role['workingNote'],
                            // Pass workingNote
                          };

                          String shortenedWorkingDesc = role['workingDesc']
                              .length > 50
                              ? role['workingDesc'].substring(0, 10) + '...'
                              : role['workingDesc'];

                          bool hasWorkingNote = role['workingNote'] != null &&
                              role['workingNote'].isNotEmpty;

                          IconData icon = hasWorkingNote
                              ? Icons.check_circle
                              : Icons.cancel;
                          Color iconColor = hasWorkingNote
                              ? Colors
                              .red[900]!
                              : Colors
                              .red[100]!;

                          return buildUserCard(
                            userFields: {
                              'UserName': role['userName'],
                              'Date: ': role['workingDate'],

                              'WorkingDesc': shortenedWorkingDesc,
                              'CreatedAt': role['createdAt'],
                            },
                            onDelete: () => _confirmDeleteRole(role['txnId']),
                            showDelete: true,
                            showView: true,
                            onView: () =>
                                _showFullDescription(role['workingDesc']),
                            topIcon: Padding(
                              padding: const EdgeInsets.all(0),
                              child: IconButton(
                                icon: Icon(
                                  icon,
                                  color: iconColor,
                                  size: 20,
                                ),
                                onPressed: () {
                                  if (hasWorkingNote) {
                                    _showWorkingNoteDialog(role['workingNote']);
                                  }
                                },
                              ),
                            ),
                            topLabel: 'Note:',
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