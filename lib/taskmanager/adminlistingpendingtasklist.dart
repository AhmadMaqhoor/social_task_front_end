import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminListingPendingTaskScreen extends StatefulWidget {
  final int companyId;

  const AdminListingPendingTaskScreen({Key? key, required this.companyId})
      : super(key: key);

  @override
  AdminListingPendingTaskScreenState createState() =>
      AdminListingPendingTaskScreenState();
}

class AdminListingPendingTaskScreenState
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
          'http://192.168.0.105:8000/api/taskapp/organizationstasks/${widget.companyId}/admin/assigned-tasks/pending'),
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
  void refetchTasks() {
    fetchTasks();
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
                      'http://192.168.0.105:8000/api/taskapp/organization-task/admin/remove-task-by/$taskId'),
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
          onSave: (updatedTask) {
            fetchTasks(); // Fetch tasks again after updating
          },
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

class TaskDetailsDialog extends StatefulWidget {
  final dynamic task;
  final Function onSave;

  TaskDetailsDialog({required this.task, required this.onSave});

  @override
  _TaskDetailsDialogState createState() => _TaskDetailsDialogState();
}

class _TaskDetailsDialogState extends State<TaskDetailsDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task['title'];
    descriptionController.text = widget.task['description'];
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveEditedTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse(
          'http://192.168.0.105:8000/api/taskapp/organization-task/admin/update-task-by/${widget.task['id']}'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      widget.onSave(widget.task); // Notify parent to fetch tasks again
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task updated successfully')),
      );
      Navigator.pop(context);
    } else {
      print('Failed to update task');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Task Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          SizedBox(height: 16),
          Text('Priority: ${widget.task['priority']}'),
          SizedBox(height: 8),
          Text('Due Date: ${widget.task['due_date']}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveEditedTask,
          child: Text('Save'),
        ),
      ],
    );
  }
}
