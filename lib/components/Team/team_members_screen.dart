
import 'package:flutter/material.dart';
import '../widgetmethods/alert_widget.dart';
import '../widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/card_widget.dart';
import '../widgetmethods/logout _method.dart';
import '../widgetmethods/no_data_found.dart';
import '../widgetmethods/toast_method.dart';

class TeamMembersScreen extends StatefulWidget {
  const TeamMembersScreen({super.key});

  @override
  State<TeamMembersScreen> createState() => _TeamMembersScreenState();
}

class _TeamMembersScreenState extends State<TeamMembersScreen> {
  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> usersList = [];
  List<Map<String, dynamic>> rolesList = [];
  List<Map<String, dynamic>> teamsList = [];
  int? selectedUserId;
  int? selectedRoleId;
  int? selectedTeamId;

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _getData();
  }
  Future<void> _getData() async {
    await fetchTeamsMembers();
    await fetchUsers();
    await fetchRoles();
    await fetchTeams();
  }

  Future<void> fetchUsers() async {
    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'User/GetAllUsers',
    );
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        usersList = List<Map<String, dynamic>>.from(response['apiResponse']);
      });
    } else {
      showToast(msg: 'Failed to load users');
    }
  }

  Future<void> fetchRoles() async {
    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'roles/GetAllRole',
    );
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        rolesList = List<Map<String, dynamic>>.from(response['apiResponse']);
      });
    } else {
      print("Failed to load roles");
    }
  }

  Future<void> fetchTeams() async {
    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'teams/GetAllTeam',
    );
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        teamsList = List<Map<String, dynamic>>.from(response['apiResponse']);
      });
    } else {
      print("Failed to load teams");
    }
  }

  Future<void> fetchTeamsMembers() async {
    setState(() {
      isLoading = true;
    });

    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'teams/GetAllTeamMember',
    );
    print('Response: $response');
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        teams = List<Map<String, dynamic>>.from(
          response['apiResponse'].map((role) => {
            'tmId': role['tmId'] ?? 0,
            'userId': role['userId'] ?? 0,
            'roleId': role['roleId'] ?? 0,
            'teamId': role['teamId'] ?? 0,

            'teamName': role['teamName'] ?? 'Unknown team',
            'createdAt': role['createdAt'] ?? '',
            'roleName': role['roleName'] ?? 'Unknown role',
            'userName': role['userName'] ?? 'Unknown team',
          }),
        );
      });
    } else {
      showToast(msg: response['message'] ?? 'Failed to load team members');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _addTeamMembers( int userId, int roleId, int teamId) async {
    final response = await new ApiService().request(
      method: 'post',
      endpoint: 'teams/AddEditTeamMember',
      body: {

        'userId': userId,
        'roleId': roleId,
        'teamId': teamId,
      },
    );

    if (response.isNotEmpty && response['statusCode'] == 200) {
      fetchTeamsMembers();
      showToast(
        msg: response['message'] ?? 'Team Members added successfully',
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    } else {
      showToast(
        msg: response['message'] ?? 'Failed to add team member',
      );
    }
  }


  Future<void> _showAddRoleModal() async {

    setState(() {
      selectedUserId = null;
      selectedRoleId = null;
      rolesList.clear();
    });

    await fetchRoles();

    showCustomAlertDialog(
      context,
      title: 'Add Team Members',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Select User', border: OutlineInputBorder()),
                items: usersList.map((user) {
                  return DropdownMenuItem<int>(
                    value: user['userId'],
                    child: Text(user['userName']),
                  );
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    selectedUserId = value;
                    rolesList.clear();
                  });
                  await fetchRoles();
                  setState(() {});
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Select Role', border: OutlineInputBorder()),
                items: rolesList.map((role) {
                  return DropdownMenuItem<int>(
                    value: role['roleId'],
                    child: Text(role['roleName']),
                  );
                }).toList(),
                onChanged: (value) => selectedRoleId = value,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Select team', border: OutlineInputBorder()),
                items: teamsList.map((role) {
                  return DropdownMenuItem<int>(
                    value: role['teamId'],
                    child: Text(role['teamName']),
                  );
                }).toList(),
                onChanged: (value) => selectedTeamId = value,
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (selectedUserId == null || selectedRoleId == null || selectedTeamId == null) {
              showToast(msg: 'Please select all fields');
              return;
            }
            _addTeamMembers(selectedUserId!, selectedRoleId!,selectedTeamId!);
          },
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _confirmDeleteTeamMember(int tmId) {
    showCustomAlertDialog(
      context,
      title: 'Delete Team Member',
      content: Text('Are you sure you want to delete this team Member?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            _deleteTeamMember(tmId);
            Navigator.pop(context);
          },
          child: Text('Delete',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Future<void> _deleteTeamMember(int tmId) async {

    final response = await new ApiService().request(
      method: 'delete',
      endpoint: 'teams/deleteTeamMember/$tmId',
    );
    if (response['statusCode'] == 200) {
      String message = response['message'] ?? 'Team Member deleted successfully';
      showToast(msg: message, backgroundColor: Colors.green);
      fetchTeamsMembers();
    } else {
      String message = response['message'] ?? 'Failed to delete TeamMember';
      showToast(msg: message);
    }
  }


  Future<void> _updateUserRole(int tmId, int userId, int roleId, int teamId) async {
    final response = await ApiService().request(
      method: 'post',
      endpoint: 'teams/AddEditTeamMember',
      body: {
        'tmId': tmId,
        'userId': userId,
        'roleId': roleId,
        'teamId': teamId,
        'updateFlag': true,
      },
    );

    if (response['statusCode'] == 200) {
      fetchTeamsMembers();
      showToast(msg: response['message'] ?? 'Role updated successfully', backgroundColor: Colors.green);
      Navigator.pop(context);
    } else {
      showToast(msg: response['message'] ?? 'Failed to update role');
    }
  }

  Future<void> _showEditTeammemberModal(int tmId) async {


    // Here, find the selected member from the team list using tmId
    final currentMember = teams.firstWhere((member) => member['tmId'] == tmId);

    // Initialize the selected values for the dropdowns
    selectedUserId = currentMember['userId'];
    selectedRoleId = currentMember['roleId'];
    selectedTeamId = currentMember['teamId'];

    print("Selected UserId: $selectedUserId");
    print("Selected RoleId: $selectedRoleId");
    print("Selected TeamId: $selectedTeamId");

    showCustomAlertDialog(
      context,
      title: 'Edit Team Member',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // User dropdown
              DropdownButtonFormField<int>(
                value: selectedUserId,
                decoration: InputDecoration(labelText: 'Select User', border: OutlineInputBorder()),
                items: usersList.map((user) {
                  return DropdownMenuItem<int>(
                    value: user['userId'],
                    child: Text(user['userName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserId = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Role dropdown
              DropdownButtonFormField<int>(
                value: selectedRoleId,
                decoration: InputDecoration(labelText: 'Select Role', border: OutlineInputBorder()),
                items: rolesList.map((role) {
                  return DropdownMenuItem<int>(
                    value: role['roleId'],
                    child: Text(role['roleName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRoleId = value;
                  });
                },
              ),
              SizedBox(height: 10),

              // Team dropdown
              DropdownButtonFormField<int>(
                value: selectedTeamId,
                decoration: InputDecoration(labelText: 'Select Team', border: OutlineInputBorder()),
                items: teamsList.map((team) {
                  return DropdownMenuItem<int>(
                    value: team['teamId'],
                    child: Text(team['teamName']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTeamId = value;
                  });
                },
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (selectedUserId == null || selectedRoleId == null || selectedTeamId == null) {
              showToast(msg: 'Please select all fields');
              return;
            }
            _updateUserRole(tmId, selectedUserId!, selectedRoleId!, selectedTeamId!);
          },
          child: Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Team Members',
        onLogout: () => AuthService.logout(context),
      ),
      body: RefreshIndicator(
        onRefresh: fetchTeamsMembers,
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
                      onPressed: _showAddRoleModal,
                    ),
                  ],
                ),

                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (teams.isEmpty)
                  NoDataFoundScreen()
                else
                  Column(
                    children: teams.map((role) {
                      Map<String, dynamic> roleFields = {
                        'TeamName': role['teamName'],
                        'Username:': role['userName'],
                        'Rolename': role['roleName'],
                        'CreatedAt': role['createdAt'],
                      };

                      return buildUserCard(
                        userFields: roleFields,
                        onEdit: () => _showEditTeammemberModal(role['tmId']),
                        onDelete: () => _confirmDeleteTeamMember(role['tmId']),
                        trailingIcon:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: ()=>_showEditTeammemberModal(role['tmId']),
                                icon: Icon(Icons.edit,color: Colors.green,)),
                            IconButton(onPressed: ()=>_confirmDeleteTeamMember(role['tmId']),
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