import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcomingOrganizationTasksScreen extends StatefulWidget {
  final DateTime selectedDate;

  const UpcomingOrganizationTasksScreen({
    required this.selectedDate,
  });

  @override
  _UpcomingOrganizationTasksScreenState createState() =>
      _UpcomingOrganizationTasksScreenState();
}

class _UpcomingOrganizationTasksScreenState
    extends State<UpcomingOrganizationTasksScreen> {
  List<dynamic> tasks = [];

  @override
  void didUpdateWidget(covariant UpcomingOrganizationTasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget) {
      fetchOrganizationUpcomingTasks();
    }
  }

  bool iscompleted = false;

  @override
  void initState() {
    super.initState();
    fetchOrganizationUpcomingTasks();
  }

  Future<void> fetchOrganizationUpcomingTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';
    final formattedDueDate =
        DateFormat('yyyy-MM-dd').format(widget.selectedDate);

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/organizationstasks/upcoming-assigned?_method=GET'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'due_date': formattedDueDate,
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

  void viewTaskDetails(int taskId) {
    // Navigate to task details screen using taskId
    // Implement your navigation logic here
  }

  void updateTaskCompletion(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.patch(
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
      fetchOrganizationUpcomingTasks();
    } else {
      // Failed to update task
      print('Failed to update task completion');
    }
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
