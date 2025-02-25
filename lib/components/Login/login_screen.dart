import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskmanagement/components/Roles/roles_screen.dart';
import 'package:taskmanagement/components/WorkingStatus/daily_working_status.dart';
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

  String? selectedRole;

  final List<String> roles = ['Admin', 'User', 'Guest'];

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
                  width: 160,
                  height: 160,
                ),
                SizedBox(height: 60),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
        
                    CustomDropdown<String>(
                      options: roles,
                      selectedOption: selectedRole,
                      displayValue: (role) => role,
                      onChanged: (role) {
                        setState(() {
                          selectedRole = role;
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
                      onPressed: () {
                        String username = usernameController.text;
                        String password = passwordController.text;
                        if (username.isNotEmpty && password.isNotEmpty && selectedRole != null) {
                          showToast(msg:'Login Successfull');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DailyWorkingStatus()),
                          );
                        } else {
                          showToast(msg:'Please fill all fields');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
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
                    )
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
