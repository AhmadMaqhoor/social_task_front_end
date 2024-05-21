import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isd_project/taskmanager/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MemberItem {
  final int id;
  final String userProfilePicUrl;
  final String username;
  final int score;

  MemberItem({
    required this.id,
    required this.userProfilePicUrl,
    required this.username,
    required this.score,
  });
}

class AddTaskDialogAsAdmin extends StatefulWidget {
  final int companyId;

  const AddTaskDialogAsAdmin({Key? key, required this.companyId}) : super(key: key);

  @override
  State<AddTaskDialogAsAdmin> createState() => _AddTaskDialogAsAdminState();
}

class _AddTaskDialogAsAdminState extends State<AddTaskDialogAsAdmin> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime duedate = DateTime.now();
  String priority = "low";
  bool isLoading = true;
  List<MemberItem> members = [];
  List<int> selectedMemberIds = [];

  Future<void> createTask() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    String formattedDueDate = DateFormat('yyyy-MM-dd').format(duedate);
    priority = priority.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';
    print('Access Token: $accessToken');

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/organization-by-/${widget.companyId}/create-task'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description,
        'due_date': formattedDueDate,
        'priority': priority,
        'reminder': "0",
        'assigned_members': selectedMemberIds,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Task created successfully
      // You can navigate to another screen or show a success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task created successfully'),
        ),
      );
    } else {
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to create task. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchMembers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/taskapp/organizations/${widget.companyId}/members'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          members = (data['members'] as List)
              .map((item) => MemberItem(
                    id: item['id'],
                    userProfilePicUrl: item['image'] ?? '',
                    username: item['name'] ?? '',
                    score: item['score'] ?? 0,
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void dropdownCallback(String? selectedValue) {
    setState(() {
      priority = selectedValue ?? 'high';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void _showSelectMembersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Members'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = members[index];
                return CheckboxListTile(
                  value: selectedMemberIds.contains(member.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedMemberIds.add(member.id);
                      } else {
                        selectedMemberIds.remove(member.id);
                      }
                    });
                  },
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(member.userProfilePicUrl),
                      ),
                      SizedBox(width: 10),
                      Text(member.username),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        width: 320,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.work),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create a new task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel_rounded),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'title of the task',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description for the task',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDatePicker(
                    initialDate: DateTime.now(),
                    onDateSelected: (DateTime selectedDate) {
                      print('Selected date: $selectedDate');
                      duedate = selectedDate;
                    },
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: const [
                        DropdownMenuItem(value: 'high', child: Text('HIGH')),
                        DropdownMenuItem(value: 'medium', child: Text('MEDIUM')),
                        DropdownMenuItem(value: 'low', child: Text('LOW')),
                      ],
                      value: priority,
                      onChanged: dropdownCallback,
                      iconSize: 25,
                      iconEnabledColor: Colors.black,
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      autofocus: true,
                      borderRadius: BorderRadius.circular(10),
                      focusColor: Colors.blue,
                      dropdownColor: Colors.blue,
                      elevation: 0,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showSelectMembersDialog,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(40, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Text(
                      'Members',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(200, 0, 0, 15),
              child: ElevatedButton(
                  onPressed: createTask,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(40, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
