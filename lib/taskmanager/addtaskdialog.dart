import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isd_project/taskmanager/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:isd_project/taskmanager/today.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddTaskDialog extends StatefulWidget {
  final VoidCallback onTaskCreated;
  const AddTaskDialog({Key? key, required this.onTaskCreated}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime duedate = DateTime.now();
  String priority = "low";

  Future<void> createTask() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    String formattedDueDate = DateFormat('yyyy-MM-dd').format(duedate);
    priority = priority.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';
    print('Access Token: $accessToken');

    final response = await http.post(
      Uri.parse('http://192.168.0.105:8000/api/taskapp/create-task'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'due_date': formattedDueDate,
        'priority': priority,
        "reminder": "0"
        // Add other fields as needed
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // Task created successfully
      // You can navigate to another screen or show a success message

      Navigator.pop(context);
      widget.onTaskCreated();
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

  void dropdownCallback(String? selectedValue) {
    selectedValue is String
        ? setState(() {
            priority = selectedValue;
          })
        : setState(() {
            priority = 'high';
          });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Container(
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
                    hintText: 'Title of the task',
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
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 10.0,
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
                          DropdownMenuItem(
                              value: 'medium', child: Text('MEDIUM')),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      createTask();
                    },
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
      ),
    );
  }
}
