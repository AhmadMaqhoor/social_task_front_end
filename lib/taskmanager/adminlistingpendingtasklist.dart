import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminListingPendingTaskScreen extends StatefulWidget {
  final int companyId;

  const AdminListingPendingTaskScreen({Key? key, required this.companyId})
      : super(key: key);

  @override
  _AdminListingPendingTaskScreen createState() =>
      _AdminListingPendingTaskScreen();
}

class _AdminListingPendingTaskScreen
    extends State<AdminListingPendingTaskScreen> {
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
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/organizationstasks/${widget.companyId}/admin/assigned-tasks/pending'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks = jsonDecode(response.body)['assigned_tasks'];
      });
    } else {
      print('Failed to load tasks');
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
                      'http://127.0.0.1:8000/api/taskapp/organization-task/admin/remove-task-by/$taskId'),
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
