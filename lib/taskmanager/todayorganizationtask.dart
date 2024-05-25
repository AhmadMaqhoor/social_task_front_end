import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodayOrganizationTasksScreen extends StatefulWidget {

  const TodayOrganizationTasksScreen({Key? key}) : super(key: key);

  @override
  TodayOrganizationTasksScreenState createState() =>
      TodayOrganizationTasksScreenState();
}

class TodayOrganizationTasksScreenState
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
          'http://192.168.0.105:8000/api/taskapp/organizationstasks/today-assigned'),
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
          'http://192.168.0.105:8000/api/taskapp/organization-task/update-task-completion/$taskId'),
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

void refetchTasks() {
    fetchOrganizationTasks();
  }
 void viewTaskDetails(dynamic task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TaskDetailsDialog(
          task: task,
        );
      },
    );
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
                    viewTaskDetails(task);
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

class TaskDetailsDialog extends StatelessWidget {
  final dynamic task;

  TaskDetailsDialog({required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Task Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title: ${task['title']}'),
          SizedBox(height: 8),
          Text('Description: ${task['description']}'),
          SizedBox(height: 16),
          Text('Priority: ${task['priority']}'),
          SizedBox(height: 8),
          Text('Due Date: ${task['due_date']}'),
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
    );
  }
}
