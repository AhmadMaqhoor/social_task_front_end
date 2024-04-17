import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/calendar.dart';
import 'package:isd_project/taskmanager/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String title = '';
  String description = '';
  DateTime duedate = DateTime.now();
  DateTime reminder = DateTime.now();
  String priority = 'priority 1';

  void dropdownCallback(String? selectedValue) {
    selectedValue is String
        ? setState(() {
            priority = selectedValue;
          })
        : setState(() {
            priority = 'priority 1';
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              color: Colors.grey[100],
            ),
            width: 320,
            height: 300,
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
                    onChanged: (val) {
                      setState(() => title = val);
                    },
                    decoration: const InputDecoration(
                      hintText: 'title of the task',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() => description = val);
                    },
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
                            DropdownMenuItem(
                                value: 'priority 1', child: Text('priority 1')),
                            DropdownMenuItem(
                                value: 'priority 2', child: Text('priority 2')),
                            DropdownMenuItem(
                                value: 'priority 3', child: Text('priority 3')),
                            DropdownMenuItem(
                                value: 'priority 4', child: Text('priority 4')),
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
                      // CustomDatePicker(
                      //   initialDate: DateTime.now(),
                      //   onDateSelected: (DateTime selectedDate) {
                      //     print('Selected date: $selectedDate');
                      //     reminder = selectedDate;
                      //   },
                      // ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(40, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          'Reminder',
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
                      onPressed: () {
                        Task(
                            title: title,
                            description: description,
                            duedate: duedate,
                            reminder: reminder,
                            priority: priority);
                        print(title);
                        print(description);
                        print(duedate);
                        print(reminder);
                        print(priority);
                        Navigator.pop(context);
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
      ),
    );
  }
}
