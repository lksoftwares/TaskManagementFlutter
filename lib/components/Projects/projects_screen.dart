
import 'package:flutter/material.dart';
import '../widgetmethods/alert_widget.dart';
import '../widgetmethods/api_method.dart';
import '../widgetmethods/appbar_method.dart';
import '../widgetmethods/card_widget.dart';
import '../widgetmethods/logout _method.dart';
import '../widgetmethods/no_data_found.dart';
import '../widgetmethods/toast_method.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> usersList = [];

  bool isLoading = false;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _getData();
  }
  Future<void> _getData() async {
    await fetchProjects();
    await fetchUsers();

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
  Future<void> fetchProjects() async {
    setState(() {
      isLoading = true;
    });

    final response = await new ApiService().request(
      method: 'get',
      endpoint: 'projects/GetAllProject',
    );
    print('Response: $response');
    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        projects = List<Map<String, dynamic>>.from(
          response['apiResponse'].map((role) => {
            'projectId': role['projectId'] ?? 0,
            'projectName': role['projectName'] ?? 'Unknown project',
            'projectDescription': role['projectDescription'] ?? 'Unknown desc',
            'createdByUserName': role['createdByUserName'] ?? '',
            'updateByUserName': role['updateByUserName'] ?? '',
            'createdAt': role['createdAt'] ?? '',
            'startDate': role['startDate'] ?? '',
            'endDate': role['endDate'] ?? '',
            'createdBy': role['createdBy'] ?? '',
            'updatedBy': role['updatedBy'] ?? '',

            'projectStatus': role['projectStatus'] ?? false,


          }),
        );
      });
    } else {
      showToast(msg: response['message'] ?? 'Failed to load team');
    }
    setState(() {
      isLoading = false;
    });
  }

  void _showAddProjectModal() {
    String projectName = '';
    String projectDescription = '';
    int? createdBy;
    int? updatedBy;
    DateTime? startDate;
    DateTime? endDate;

    showCustomAlertDialog(
      context,
      title: 'Add Project',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => projectName = value,
              decoration: InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) => projectDescription = value,
              decoration: InputDecoration(
                labelText: 'Project Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: createdBy,
              onChanged: (value) => setState(() => createdBy = value),
              items: usersList.map((user) {
                return DropdownMenuItem<int>(
                  value: user['userId'],
                  child: Text(user['userName']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Created By',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: updatedBy,
              onChanged: (value) => setState(() => updatedBy = value),
              items: usersList.map((user) {
                return DropdownMenuItem<int>(
                  value: user['userId'],
                  child: Text(user['userName']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Updated By',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) setState(() => startDate = picked);
                  },
                  child: Text(startDate == null ? ' Start Date' : startDate!.toLocal().toString().split(' ')[0]),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) setState(() => endDate = picked);
                  },
                  child: Text(endDate == null ? ' End Date' : endDate!.toLocal().toString().split(' ')[0]),
                ),
              ],
            ),
            SizedBox(height: 10),

          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (projectName.isEmpty || projectDescription.isEmpty || createdBy == null || updatedBy == null || startDate == null || endDate == null) {
              showToast(msg: 'Please fill in all fields');
              return;
            }
            _addProject(projectName, projectDescription, createdBy!, updatedBy!, startDate!, endDate!);
          },
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Future<void> _addProject(String projectName, String projectDescription, int createdBy, int updatedBy, DateTime startDate, DateTime endDate) async {
    final response = await new ApiService().request(
      method: 'post',
      endpoint: 'projects/AddEditProject',
      body: {
        'projectName': projectName,
        'projectDescription': projectDescription,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    if (response['statusCode'] == 200) {
      showToast(msg: 'Project added successfully', backgroundColor: Colors.green);
      fetchProjects();
      Navigator.pop(context);
    } else {
      showToast(msg: response['message'] ?? 'Failed to add project');
    }
  }

  void _confirmDeleteProject(int projectId) {
    showCustomAlertDialog(
      context,
      title: 'Delete Project',
      content: Text('Are you sure you want to delete this Project?'),
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
            _deleteProject(projectId);
            Navigator.pop(context);
          },
          child: Text('Delete',style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Future<void> _deleteProject(int projectId) async {

    final response = await new ApiService().request(
      method: 'delete',
      endpoint: 'projects/DeleteProject/$projectId',
    );
    if (response['statusCode'] == 200) {
      String message = response['message'] ?? 'Project deleted successfully';
      showToast(msg: message, backgroundColor: Colors.green);
      fetchProjects();
    } else {
      String message = response['message'] ?? 'Failed to delete Project';
      showToast(msg: message);
    }
  }
  Future<void> _updateProject(
      int projectId,
      String projectName,
      String projectDescription,
      int createdBy,
      int updatedBy,
      DateTime startDate,
      DateTime endDate,
      ) async {
    final response = await ApiService().request(
      method: 'post',
      endpoint: 'projects/AddEditProject',
      body: {
        'projectId': projectId,
        'projectName': projectName,
        'projectDescription': projectDescription,
        'createdBy': createdBy,
        'updatedBy': updatedBy,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'updateFlag': true,
      },
    );

    if (response['statusCode'] == 200) {
      showToast(msg: 'Project updated successfully', backgroundColor: Colors.green);
      fetchProjects();
      Navigator.pop(context);
    } else {
      showToast(msg: response['message'] ?? 'Failed to update project');
    }
  }

  void _showEditProjectModal(Map<String, dynamic> project) {
    TextEditingController projectNameController =
    TextEditingController(text: project['projectName']);
    TextEditingController projectDescriptionController =
    TextEditingController(text: project['projectDescription']);
    int? createdBy = project['createdBy'] ?? 0;
    int? updatedBy = project['updatedBy'] ?? 0;

    DateTime? startDate =
    project['startDate'] != null ? DateTime.parse(project['startDate']) : null;
    DateTime? endDate =
    project['endDate'] != null ? DateTime.parse(project['endDate']) : null;

    showCustomAlertDialog(
      context,
      title: 'Edit Project',
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: projectNameController,
              decoration: InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: projectDescriptionController,
              decoration: InputDecoration(
                labelText: 'Project Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: createdBy != null && usersList.any((user) => user['userId'] == createdBy)
                  ? createdBy
                  : usersList.isNotEmpty ? usersList[0]['userId'] : null,
              onChanged: (value) => setState(() => createdBy = value),
              items: usersList.map((user) {
                return DropdownMenuItem<int>(
                  value: user['userId'],
                  child: Text(user['userName']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Created By',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            DropdownButtonFormField<int>(
              value: updatedBy != null && usersList.any((user) => user['userId'] == updatedBy)
                  ? updatedBy
                  : usersList.isNotEmpty ? usersList[0]['userId'] : null,
              onChanged: (value) => setState(() => updatedBy = value),
              items: usersList.map((user) {
                return DropdownMenuItem<int>(
                  value: user['userId'],
                  child: Text(user['userName']),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Updated By',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => startDate = picked);
              },
              child: Text(startDate == null
                  ? ' Start Date'
                  : startDate!.toLocal().toString().split(' ')[0]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => endDate = picked);
              },
              child: Text(endDate == null
                  ? ' End Date'
                  : endDate!.toLocal().toString().split(' ')[0]),
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            if (projectNameController.text.isEmpty ||
                projectDescriptionController.text.isEmpty ||
                createdBy == null ||
                updatedBy == null ||
                startDate == null ||
                endDate == null) {
              showToast(msg: 'Please fill in all fields');
              return;
            }
            _updateProject(
              project['projectId'],
              projectNameController.text,
              projectDescriptionController.text,
              createdBy!,
              updatedBy!,
              startDate!,
              endDate!,
            );
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
        title: 'Projects',
        onLogout: () => AuthService.logout(context),
      ),
      body: RefreshIndicator(
        onRefresh: fetchProjects,
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
                      onPressed: _showAddProjectModal,
                    ),
                  ],
                ),

                SizedBox(height: 20),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (projects.isEmpty)
                  NoDataFoundScreen()
                else
                  Column(
                    children: projects.map((role) {
                      Map<String, dynamic> roleFields = {
                        'ProjectName': role['projectName'],
                        '': role[''],
                        'Projectdesc': role['projectDescription'],
                        'ProjectStatus': role['projectStatus'],
                        'CreatedBy': role['createdByUserName'],
                        'UpdatedBy': role['updateByUserName'],
                        'StartDate': role['startDate'],
                        'EndDate': role['endDate'],
                        'CreatedAt': role['createdAt'],
                      };

                      return buildUserCard(
                        userFields: roleFields,
                        onEdit: () => _showEditProjectModal(role),
                        onDelete: () => _confirmDeleteProject(role['projectId']),
                        trailingIcon:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: ()=>_showEditProjectModal(role),
                                icon: Icon(Icons.edit,color: Colors.green,)),
                            IconButton(onPressed: ()=>_confirmDeleteProject(role['projectId']),
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