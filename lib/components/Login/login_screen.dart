// import 'package:taskmanagement/Packages/headerfiles.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   Map<String, dynamic>? selectedRole;
//   List<Map<String, dynamic>> roles = [];
//   bool isLoading = true;
//   bool _obscurePassword = true;
//   @override
//   void initState() {
//     super.initState();
//     fetchRoles();
//   }
//
//   Future<void> fetchRoles() async {
//     final response = await ApiService().request(
//       method: 'GET',
//       endpoint: 'Roles/GetAllRole',
//     );
//
//     if (response['statusCode'] == 200) {
//       List<Map<String, dynamic>> fetchedRoles = [];
//       for (var role in response['apiResponse']) {
//         fetchedRoles.add({
//           'roleId': role['roleId'],
//           'roleName': role['roleName'],
//         });
//       }
//
//       setState(() {
//         roles = fetchedRoles;
//         isLoading = false;
//       });
//     } else {
//       showToast(msg: 'Failed to load roles');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> loginUser() async {
//     String username = usernameController.text;
//     String password = passwordController.text;
//
//     if (username.isNotEmpty && password.isNotEmpty && selectedRole != null) {
//       Map<String, dynamic> requestBody = {
//         "userEmail": username,
//         "userPassword": password,
//         "roleId": selectedRole!['roleId'],
//       };
//
//       final response = await ApiService().request(
//         method: 'POST',
//         endpoint: 'User/Login',
//         body: requestBody
//       );
//
//       if (response['statusCode'] == 200) {
//         showToast(  msg: response['message'] ?? 'Login successfully', backgroundColor: Colors.green);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => DashboardScreen()),
//         );
//       } else {
//         showToast(msg: 'Login Failed: ${response['message']}');
//       }
//     } else {
//       showToast(msg: 'Please fill all fields');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size(double.infinity, 100),
//           child: AppBar(
//             centerTitle: true,
//             backgroundColor: Colors.black,
//             actions: [
//               TextButton(onPressed: () {}, child: const Text("Skip"))
//             ],
//           )
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: Column(
//               children: [
//                 Image.asset(
//                   'images/Logo.png',
//                   width: 140,
//                   height: 140,
//                 ),
//                 SizedBox(height: 60),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (isLoading)
//                       CircularProgressIndicator(),
//                     if (!isLoading)
//                       CustomDropdown<String>(
//                         options: roles.map((role) => role['roleName'] as String).toList(),
//                         selectedOption: selectedRole?['roleName'],
//                         displayValue: (roleName) => roleName,
//                         onChanged: (roleName) {
//                           setState(() {
//                             selectedRole = roles.firstWhere((role) => role['roleName'] == roleName);
//                           });
//                         },
//                         labelText: 'Select Role',
//                         prefixIcon: Icon(Icons.person),
//                         width: 320,
//                       ),
//
//                     SizedBox(height: 20),
//                     CustomTextField(
//                       controller: usernameController,
//                       label: 'Username',
//                       hintText: 'Enter your username',
//                       prefixIcon: Icon(Icons.people_alt_outlined),
//                     ),
//                     SizedBox(height: 10),
//                     CustomTextField(
//                       controller: passwordController,
//                       label: 'Password',
//                       hintText: 'Enter your password',
//                       obscureText: _obscurePassword,
//                       prefixIcon: Icon(Icons.password),
//                       suffixIcon: Icon(
//                         _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onSuffixIconPressed: () {
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: loginUser,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         padding:
//                         EdgeInsets.symmetric(horizontal: 70, vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         'Login',
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart'; // Add this import
// import 'package:taskmanagement/Packages/headerfiles.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   Map<String, dynamic>? selectedRole;
//   List<Map<String, dynamic>> roles = [];
//   bool isLoading = true;
//   bool _obscurePassword = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRoles();
//     //checkDeveloperOptions();
//   }
//
//   // Future<void> checkDeveloperOptions() async {
//   //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//   //
//   //   if (androidInfo.isPhysicalDevice == true &&
//   //       await _isDeveloperOptionsEnabled()) {
//   //     _showDeveloperOptionsDialog();
//   //   }
//   // }
//
//   // Future<bool> _isDeveloperOptionsEnabled() async {
//   //   try {
//   //     final deviceInfo = await DeviceInfoPlugin().androidInfo;
//   //     return deviceInfo.isPhysicalDevice ?? false;
//   //   } catch (e) {
//   //     return false;
//   //   }
//   // }
//   //
//   // void _showDeveloperOptionsDialog() {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: Text("Developer Options Detected"),
//   //         content: Text(
//   //             "It looks like Developer Options are enabled. Please disable it."),
//   //         actions: <Widget>[
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: Text("Cancel"),
//   //           ),
//   //
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//
//   Future<void> fetchRoles() async {
//     final response = await ApiService().request(
//       method: 'GET',
//       endpoint: 'Roles/GetAllRole',
//     );
//
//     if (response['statusCode'] == 200) {
//       List<Map<String, dynamic>> fetchedRoles = [];
//       for (var role in response['apiResponse']) {
//         fetchedRoles.add({
//           'roleId': role['roleId'],
//           'roleName': role['roleName'],
//         });
//       }
//
//       setState(() {
//         roles = fetchedRoles;
//         isLoading = false;
//       });
//     } else {
//       showToast(msg: 'Failed to load roles');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> loginUser() async {
//     String username = usernameController.text;
//     String password = passwordController.text;
//
//     if (username.isNotEmpty && password.isNotEmpty && selectedRole != null) {
//       Map<String, dynamic> requestBody = {
//         "userEmail": username,
//         "userPassword": password,
//         "roleId": selectedRole!['roleId'],
//       };
//
//       final response = await ApiService().request(
//         method: 'POST',
//         endpoint: 'User/Login',
//         body: requestBody,
//       );
//
//       if (response['statusCode'] == 200) {
//         showToast(msg: response['message'] ?? 'Login successfully',
//             backgroundColor: Colors.green);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => DashboardScreen()),
//         );
//       } else {
//         showToast(msg: 'Login Failed: ${response['message']}');
//       }
//     } else {
//       showToast(msg: 'Please fill all fields');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Login",
//       ),
//       body: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height,
//             child: Image.asset(
//               'images/Login8.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Center(
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'images/Logo.png',
//                       width: 120,
//                       height: 120,
//                     ),
//                     SizedBox(height: 20),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         if (isLoading)
//                           CircularProgressIndicator(),
//                         if (!isLoading)
//                           CustomDropdown<String>(
//                             options: roles.map((
//                                 role) => role['roleName'] as String).toList(),
//                             selectedOption: selectedRole?['roleName'],
//                             displayValue: (roleName) => roleName,
//                             onChanged: (roleName) {
//                               setState(() {
//                                 selectedRole = roles.firstWhere((
//                                     role) => role['roleName'] == roleName);
//                               });
//                             },
//                             labelText: 'Select Role',
//                             prefixIcon: Icon(Icons.person),
//                             width: 320,
//                           ),
//                         SizedBox(height: 20),
//                         CustomTextField(
//                           controller: usernameController,
//                           label: 'Username',
//                           hintText: 'Enter your username',
//                           prefixIcon: Icon(Icons.people_alt_outlined),
//                         ),
//                         SizedBox(height: 10),
//                         CustomTextField(
//                           controller: passwordController,
//                           label: 'Password',
//                           hintText: 'Enter your password',
//                           obscureText: _obscurePassword,
//                           prefixIcon: Icon(Icons.password),
//                           suffixIcon: Icon(
//                             _obscurePassword ? Icons.visibility_off : Icons
//                                 .visibility,
//                           ),
//                           onSuffixIconPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                         SizedBox(height: 15),
//                         ElevatedButton(
//                           onPressed: loginUser,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blueAccent,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 50, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagement/Packages/headerfiles.dart';

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
  bool _obscurePassword = true;

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
        body: requestBody,
      );

      if (response['statusCode'] == 200) {
        int user_Id = response['apiResponse']['user_Id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_Id', user_Id);
       print(user_Id);
        showToast(msg: response['message'] ?? 'Login successfully', backgroundColor: Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
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
        title: "Login",
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'images/Login8.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'images/Logo.png',
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading)
                          CircularProgressIndicator(),
                        if (!isLoading)
                          CustomDropdown<String>(
                            options: roles.map((
                                role) => role['roleName'] as String).toList(),
                            selectedOption: selectedRole?['roleName'],
                            displayValue: (roleName) => roleName,
                            onChanged: (roleName) {
                              setState(() {
                                selectedRole = roles.firstWhere((
                                    role) => role['roleName'] == roleName);
                              });
                            },
                            labelText: 'Select Role',
                            prefixIcon: Icon(Icons.person),
                            width: 320,
                          ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: usernameController,
                          label: 'Username',
                          hintText: 'Enter your username',
                          prefixIcon: Icon(Icons.people_alt_outlined),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          controller: passwordController,
                          label: 'Password',
                          hintText: 'Enter your password',
                          obscureText: _obscurePassword,
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons
                                .visibility,
                          ),
                          onSuffixIconPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
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
        ],
      ),
    );
  }
}
