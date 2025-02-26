import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmanagement/components/WorkingStatus/daily_working_status.dart';
import 'package:taskmanagement/components/widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/dropdown_controller.dart';
import '../widgetmethods/textfieldcontroller.dart';
import '../widgetmethods/toast_method.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Map<String, dynamic>? selectedRole;
  List<Map<String, dynamic>> roles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    final response = await ApiService().request(
      method: 'GET',
      endpoint: 'Roles/GetAllRole',
    );

    if (response['statusCode'] == 200) {
      List<Map<String, dynamic>> fetchedRoles = [];
      for (var role in response['apiResponse']) {
        fetchedRoles.add({
          'roleId': role['roleId'],
          'roleName': role['roleName'],
        });
      }

      setState(() {
        roles = fetchedRoles;
        isLoading = false;
      });
    } else {
      showToast(msg: 'Failed to load roles');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loginUser() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty && selectedRole != null) {
      Map<String, dynamic> requestBody = {
        "userEmail": username,
        "userPassword": password,
        "roleId": selectedRole!['roleId'],
      };

      final response = await ApiService().request(
        method: 'POST',
        endpoint: 'User/Login',

      );

      if (response['statusCode'] == 200) {
        showToast(  msg: response['message'] ?? 'Login successfully', backgroundColor: Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DailyWorkingStatus()),
        );
      } else {
        showToast(msg: 'Login Failed: ${response['message']}');
      }
    } else {
      showToast(msg: 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Login',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'images/Logo.png',
                  width: 140,
                  height: 140,
                ),
                SizedBox(height: 60),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      CircularProgressIndicator(),
                    if (!isLoading)
                      CustomDropdown<String>(
                        options: roles.map((role) => role['roleName'] as String).toList(),
                        selectedOption: selectedRole?['roleName'],
                        displayValue: (roleName) => roleName,
                        onChanged: (roleName) {
                          setState(() {
                            selectedRole = roles.firstWhere((role) => role['roleName'] == roleName);
                          });
                        },
                        labelText: 'Select Role',
                        prefixIcon: Icon(Icons.person),
                      ),

                    SizedBox(height: 20),
                    CustomTextField(
                      controller: usernameController,
                      label: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.people_alt_outlined),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.password),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                        EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
