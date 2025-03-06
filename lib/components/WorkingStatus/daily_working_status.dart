import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:taskmanagement/components/widgetmethods/alert_widget.dart';
import 'package:taskmanagement/components/widgetmethods/api_method.dart';
import 'package:taskmanagement/components/widgetmethods/appbar_method.dart';
import 'package:taskmanagement/components/widgetmethods/card_widget.dart';
import 'package:taskmanagement/components/widgetmethods/logout%20_method.dart';
import 'package:taskmanagement/components/widgetmethods/no_data_found.dart';
import 'package:taskmanagement/components/widgetmethods/toast_method.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:taskmanagement/config.dart';

class DailyWorkingStatus extends StatefulWidget {
  const DailyWorkingStatus({super.key});

  @override
  State<DailyWorkingStatus> createState() => _DailyWorkingStatusState();
}

class _DailyWorkingStatusState extends State<DailyWorkingStatus> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool isRecording = false;
  String? audioFilePath;
  bool isPlaying = false;
  String? selectedUserId;
  Map<String, bool> isPlayingMap = {};
  bool isLoading = false;
  DateTime? fromDate;
  DateTime? toDate;
  String? selectedUserName;
  Map<String, dynamic>? selectedUser;
  List<Map<String, dynamic>> roles = [];
  List<Map<String, dynamic>> users = [];
  double currentPosition = 0.0;
  Timer? positionTimer;
  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _initializePlayer();
    _getData();
  }


  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }
  Future<void> _initializePlayer() async {
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();
  }
  Future<void> _getData() async {
    await fetchWorking();
    await fetchUsers();
  }

  Future<void> _startRecording() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      String path = await _getFilePath();
      await _recorder!.startRecorder(toFile: path);
      setState(() {
        isRecording = true;
        audioFilePath = path;
      });
      showToast(msg: "Recording started!",backgroundColor: Colors.green);

      print("Recording started. File path: $audioFilePath");
    } else {
      showToast(msg: "Permission denied. Please allow microphone access.");
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      isRecording = false;
    });

    showToast(msg: "Recording stopped!",backgroundColor: Colors.green);
    print("Recording stopped. File saved at: $audioFilePath");
  }


  Future<String> _getFilePath() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String path = '${appDirectory.path}/recording.aac';
    return path;
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
      endpoint: 'Working/GetWorking',
    );

    print('Response: $response');

    if (response['statusCode'] == 200 && response['apiResponse'] != null) {
      setState(() {
        var workingStatusList = response['apiResponse']['workingStatusList'];

        roles = List<Map<String, dynamic>>.from(
          workingStatusList.map((role) {
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
              'workingNote': role['workingNote'] ?? '',
              'workingDescFilePath': role['workingDescFilePath'] ?? '',
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
        height: 200,
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
            SizedBox(height: 10),
            IconButton(
              icon: Icon(
                isRecording ? Icons.stop : Icons.mic,
                color: isRecording ? Colors.red : Colors.blue,
                size: 30,
              ),
              onPressed: () {
                if (isRecording) {
                  _stopRecording();
                } else {
                  _startRecording();
                }
              },
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            if (isRecording) {
              showToast(msg: 'Please stop the recording first.', backgroundColor: Colors.red);
            } else if (workingDesc.isEmpty) {
              showToast(msg: 'Please fill in the Working desc');
            } else if (selectedUserId == null) {
              showToast(msg: 'Please select a user');
            }else {
              _addWorking(workingDesc, selectedUserId!);
            }
          },
          child: Text(
            'Add',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      titleHeight: 65,
    );
  }

  Future<void> _addWorking(String workingDesc, String userId) async {
    final uri = Uri.parse('${Config.apiUrl}Working/AddWorking');

    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields['workingDesc'] = workingDesc;
      request.fields['userId'] = selectedUserId!;
      if (audioFilePath != null) {
        var file = await http.MultipartFile.fromPath(
          'workingAudioFile',
          audioFilePath!,
          contentType: MediaType('audio', 'aac'),
        );
        request.files.add(file);
      }
      var response = await request.send();
      final responseData = await http.Response.fromStream(response);
      final responseJson = jsonDecode(responseData.body);
      if (response.statusCode == 200) {
        if (responseJson != null && responseJson['message'] != null) {
          showToast(msg: responseJson['message'], backgroundColor: Colors.green);
        }
        fetchWorking();
        Navigator.pop(context);
        setState(() {
          selectedUserId = null;
        });
      } else {
        showToast(msg: responseJson['message'], backgroundColor: Colors.green);
      }
    } catch (e) {
      print("Error uploading working desc: $e");
      showToast(msg: 'An error occurred while uploading');
    }
  }


  void _showDatePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime(2025,DateTime.february),
      lastDate: DateTime(2025,DateTime.april),
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            _deleteRole(txnId);
            Navigator.pop(context);
          },
          child: Text('Delete',style: TextStyle(color: Colors.white),),
        ),
      ],
      titleHeight: 65,

    );
  }

  Future<void> _deleteRole(int txnId) async {
    final response = await new ApiService().request(
      method: 'delete',
      endpoint: 'Working/DeleteWorking/$txnId',
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
  void _showFullDescription(String workingDesc, String workingDate, String userName, BuildContext context) {
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(workingDate);
    String formattedWorkingDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    showCustomAlertDialog(
      context,
      title: 'Working Description',

      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 250,
            constraints: BoxConstraints(
              maxHeight: 500,
            ),
            child: SingleChildScrollView(
              child: Text(
                "Description: $workingDesc",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
      titleFontSize: 27.0,
      additionalTitleContent: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Column(
          children: [
            Divider(),
            Text(
              "User: $userName               Date: $formattedWorkingDate",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showWorkingNoteDialog(String? workingNote, String workingDate, String userName, BuildContext context) {
    if (workingNote == null || workingNote.isEmpty) {
      showToast(msg: "No working note available");
      return;
    }

    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(workingDate);
    String formattedWorkingDate = DateFormat('dd-MM-yyyy').format(parsedDate);

    showCustomAlertDialog(
      context,
      title: 'Working Note',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 250,
            constraints: BoxConstraints(
              maxHeight: 400,
            ),
            child: SingleChildScrollView(
              child: Text(
                "Note: $workingNote",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Close"),
        ),
      ],
      titleFontSize: 27.0,
      additionalTitleContent: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Column(
          children: [
            Divider(),
            Text(
              "User: $userName               Date: $formattedWorkingDate",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getFilteredData() {
    return roles.where((role) {
      bool matchesUserName = true;
      bool matchesDate = true;
      if (selectedUserName != null && selectedUserName!.isNotEmpty) {
        matchesUserName = role['userName'] == selectedUserName;
      }
      if (fromDate != null && toDate != null) {
        DateTime workingDate = _parseDate(role['workingDate']);
        matchesDate = (workingDate.isAtSameMomentAs(fromDate!) ||
            workingDate.isAfter(fromDate!)) &&
            (workingDate.isAtSameMomentAs(toDate!) ||
                workingDate.isBefore(toDate!));
      }
      return matchesUserName && matchesDate;
    }).toList();
  }

  Future<void> _playAudio(String url) async {
    try {
      setState(() {
        isPlayingMap[url] = true;
      });
      await _player!.startPlayer(
        fromURI: url,
        whenFinished: () {
          setState(() {
            isPlayingMap[url] = false;
          });
        },
      );
    } catch (e) {
      print("Error playing audio: $e");
      showToast(msg: 'Error playing audio');
    }
  }

  Future<void> _stopAudio(String url) async {
    await _player!.stopPlayer();
    setState(() {
      isPlayingMap[url] = false;
    });
    positionTimer?.cancel();
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
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return users
                            .where((user) => user['userName']!
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                            .map((user) => user['userName'] as String)
                            .toList();
                      },
                      onSelected: (String userName) {
                        setState(() {
                          selectedUserName = userName;
                        });
                        fetchWorking();
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        return Container(
                          width: 230,
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: 'Select User',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  selectedUserName = null;
                                });
                                fetchWorking();
                              }
                            },
                          ),
                        );
                      },
                    ),

                    IconButton(
                      icon: Icon(
                          Icons.filter_alt_outlined, color: Colors.blue, size: 30),
                      onPressed: _showDatePicker,
                    ),
                    SizedBox(width: 10),

                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.blue, size: 30),
                      onPressed: _showAddWorkingModal,
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
                            'Username': role['userName'],
                            'workingDate': role['workingDate'],
                            'Note ': role[''] ?? "",
                            'WorkingDesc': role['workingDesc'],
                            'CreatedAt': role['createdAt'],
                            'updatedAt': role['updatedAt'],
                            'WorkingNote': role['workingNote'],
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
                              ? Colors.red[900]!
                              : Colors.red[100]!;
                          bool hasAudioFile = role['workingDescFilePath'] != null && role['workingDescFilePath'] != '';
                          return buildUserCard(
                            userFields: {
                              'Username': role['userName'],
                              'Date: ': role['workingDate'],
                              'Note ': role[''] ?? "",
                              'WorkingDesc': shortenedWorkingDesc,
                              'CreatedAt':role['createdAt'],

                            },
                            onDelete: () => _confirmDeleteRole(role['txnId']),
                            showView: true,
                            onView: () =>
                                _showFullDescription(role['workingDesc'], role['workingDate'],
                                    role['userName'],context),
                              trailingIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (hasAudioFile)
                                    IconButton(
                                      icon: Icon(
                                        isPlayingMap[role['workingDescFilePath']] == true
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: isPlayingMap[role['workingDescFilePath']] == true
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      onPressed: () {
                                        if (isPlayingMap[role['workingDescFilePath']] == true) {
                                          _stopAudio(role['workingDescFilePath']);
                                        } else {
                                          _playAudio(role['workingDescFilePath']);
                                        }
                                      },
                                    ),
                                  IconButton(
                                    onPressed: () => _confirmDeleteRole(role['txnId']),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              leadingIcon: IconButton(
                              onPressed: () {
                                if (hasWorkingNote) {
                                  _showWorkingNoteDialog(
                                      role['workingNote'],
                                      role['workingDate'],
                                      role['userName'],
                                      context
                                  );
                                }
                              },
                              icon: Icon(
                                icon,
                                color: iconColor,
                                size: 20,
                              ),
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
  }}