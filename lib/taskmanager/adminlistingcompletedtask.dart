import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminListingCompletedTaskScreen extends StatefulWidget {
  final int companyId;

  const AdminListingCompletedTaskScreen({Key? key, required this.companyId})
      : super(key: key);

  @override
  _AdminListingCompletedTaskScreen createState() =>
      _AdminListingCompletedTaskScreen();
}

class _AdminListingCompletedTaskScreen
    extends State<AdminListingCompletedTaskScreen> {
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
          'http://127.0.0.1:8000/api/taskapp/organizationstasks/${widget.companyId}/admin/assigned-tasks/completed-tasks'),
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

  void updateTaskCompletion(int taskId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/organization-task/approve-task-completion/$taskId'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, bool>{'approve': true}),
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
              },
              icon: task['approve']
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