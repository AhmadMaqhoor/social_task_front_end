import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodayOrganizationTasksScreen extends StatefulWidget {
  @override
  _TodayOrganizationTasksScreenState createState() =>
      _TodayOrganizationTasksScreenState();
}

class _TodayOrganizationTasksScreenState
    extends State<TodayOrganizationTasksScreen> {
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchOrganizationTasks();
  }

  bool iscompleted = false;
  Future<void> fetchOrganizationTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/organizationstasks/today-assigned'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks = jsonDecode(response.body)['assigned_messages'];
      });
    } else {
      print('Failed to load tasks');
    }
  }

  void updateTaskCompletion(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/organization-task/update-task-completion/$taskId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, bool>{'completed': true}),
    );

    if (response.statusCode == 200) {
      // Task updated successfully
      // Refresh task list
      fetchOrganizationTasks();
    } else {
      // Failed to update task
      print('Failed to update task completion');
    }
  }

  void viewTaskDetails(int taskId) {
    // Navigate to task details screen using taskId
    // Implement your navigation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            leading: IconButton(
              onPressed: () {
                // Update task completion status
                updateTaskCompletion(task['id']);
                setState(() {
                  iscompleted = !iscompleted;
                });
              },
              icon: task['completed']
                  ? Icon(Icons.check_circle)
                  : Icon(Icons.circle_outlined),
            ),
            title: Text(task['title']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    viewTaskDetails(task['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
