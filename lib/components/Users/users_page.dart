import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgetmethods/alert_widget.dart';
import '../widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/card_widget.dart';
import '../widgetmethods/logout _method.dart';
import '../widgetmethods/no_data_found.dart';
import '../widgetmethods/toast_method.dart';

class ShreyaPage extends StatefulWidget {
  const ShreyaPage({super.key});

  @override
  State<ShreyaPage> createState() => _ShreyaPageState();
}

class _ShreyaPageState extends State<ShreyaPage> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final response = await ApiService().request(
      method: 'get',
      endpoint: 'User/GetAllUsers',
    );

    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        users = List<Map<String, dynamic>>.from(
          response['apiResponse'].map((user) => {
            'userId': user['userId'] ?? 0,
            'userName': user['userName'] ?? 'Unknown user',
            'userEmail': user['userEmail'] ?? 'Unknown user',
            'userPassword': user['userPassword'] ?? 'Unknown user',
            'userStatus': user['userStatus'] ?? false,
            'createdAt': user['createdAt'] ?? '',
            'updatedAt': user['updatedAt'] ?? '',
          }),
        );
      });
    } else {
      showToast(msg: response['message'] ?? 'Failed to load users');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _addUser(String userName, String userEmail, String userPassword) async {
    final response = await ApiService().request(
      method: 'post',
      endpoint: 'User/AddEditUser',
      body: {
        'userName': userName,
        'userEmail': userEmail,
        'userPassword': userPassword,
      },
      isMultipart: true,
    );

    if (response.isNotEmpty && response['statusCode'] == 200) {
      fetchUsers();
      showToast(
        msg: response['message'] ?? 'User added successfully',
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    } else {
      showToast(msg: response['message'] ?? 'Failed to add user');
    }
  }

  Future<void> _updateUser(int userId, String userName, String userEmail, String userPassword) async {
    final response = await ApiService().request(
      method: 'post',
      endpoint: 'User/AddEditUser',
      body: {
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'userPassword': userPassword,
        'updateFlag': true,
      },
      isMultipart: true,
    );

    if (response.isNotEmpty && response['statusCode'] == 200) {
      fetchUsers();
      showToast(
        msg: response['message'] ?? 'User updated successfully',
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    } else {
      showToast(msg: response['message'] ?? 'Failed to update user');
    }
  }


  void _showUserForm({int? userId, String? userName, String? userEmail, String? userPassword}) {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController emailController = TextEditingController(text: userEmail);
    TextEditingController passwordController = TextEditingController(text: userPassword);

    showCustomAlertDialog(
      context,

      title: userId == null ? 'Add User' : 'Edit User',
      content: Container(
        height: 200,
        child: Column(
          children: [
            TextField(controller: nameController,  decoration: InputDecoration(labelText: 'Username',border: OutlineInputBorder())),
            SizedBox(height: 15,),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email',border: OutlineInputBorder())),
            SizedBox(height: 15,),

            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder())),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
              showToast(msg: 'Please fill all fields');
              return;
            }
            if (userId == null) {
              _addUser(nameController.text, emailController.text, passwordController.text);
            } else {
              _updateUser(userId, nameController.text, emailController.text, passwordController.text);
            }
          },
          child: Text(userId == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
  void _confirmDeleteRole(int userId) {
    showCustomAlertDialog(
      context,
      title: 'Delete User',
      content: Text('Are you sure you want to delete this user?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteUser(userId);
            Navigator.pop(context);
          },
          child: Text('Delete'),
        ),
      ],
    );
  }

  Future<void> _deleteUser(int userId) async {

    final response = await new ApiService().request(
      method: 'delete',
      endpoint: 'User/DeleteUser/$userId',
    );
    if (response['statusCode'] == 200) {
      String message = response['message'] ?? 'User deleted successfully';
      showToast(msg: message, backgroundColor: Colors.green);
      fetchUsers();
    } else {
      String message = response['message'] ?? 'Failed to delete User';
      showToast(msg: message);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Users',
        onLogout: () => AuthService.logout(context),
      ),
      body: RefreshIndicator(
        onRefresh: fetchUsers,
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
                      icon: Icon(Icons.add_circle, color: Colors.blue, size: 30),
                      onPressed: () => _showUserForm(),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (users.isEmpty)
                  NoDataFoundScreen()
                else
                  Column(
                    children: users.map((user) {
                      Map<String, dynamic> roleFields = {
                        'User Name': user['userName'],
                        '':  user[''],
                        'User Status': user['userStatus'] ?? false,

                        'userEmail': user['userEmail'],
                        'Password: ': user['userPassword'],
                        'CreatedAt': user['createdAt'],

                      };

                      return buildUserCard(
                        userFields: roleFields,
                        // onEdit: () => _showUserForm(
                        //   userId: user['userId'],
                        //   userName: user['userName'],
                        //   userEmail: user['userEmail'],
                        //   userPassword: user['userPassword'],
                        // ),

                        trailingIcon:

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: ()=>_showUserForm(
                              userId: user['userId'],
                              userName: user['userName'],
                              userEmail: user['userEmail'],
                              userPassword: user['userPassword'],
                            ),
                                icon: Icon(Icons.edit,color: Colors.green,)),
                            IconButton(onPressed: ()=>_confirmDeleteRole(user['userId']),
                                icon: Icon(Icons.delete,color: Colors.red,)),

                          ],
                        ),
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