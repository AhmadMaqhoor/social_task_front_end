import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompletedTasksScreen extends StatefulWidget {
  @override
  _CompletedTasksScreenState createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/completed-tasks'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks = jsonDecode(response.body)['completed_tasks'];
      });
    } else {
      print('Failed to load tasks');
    }
  }

  void updateTaskCompletion(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.patch(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/update-task-completion/$taskId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, bool>{'completed': false}),
    );

    if (response.statusCode == 200) {
      // Task updated successfully
      // Refresh task list
      fetchTasks();
    } else {
      // Failed to update task
      print('Failed to update task completion');
    }
  }

  void deleteTask(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();
                // Proceed with task deletion
                final response = await http.delete(
                  Uri.parse(
                      'http://127.0.0.1:8000/api/taskapp/remove-task/$taskId'),
                  headers: <String, String>{
                    'Authorization': 'Bearer $accessToken',
                  },
                );
                if (response.statusCode == 200) {
                  // Task deleted successfully
                  // Refresh task list
                  fetchTasks();
                } else {
                  // Failed to delete task
                  print('Failed to delete task');
                }
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
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
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show delete confirmation dialog
                    deleteTask(task['id']);
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