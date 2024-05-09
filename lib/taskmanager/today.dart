import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';
import 'package:isd_project/taskmanager/todayorganizationtask.dart';
import 'package:isd_project/taskmanager/todaytasklist.dart'; // Import your TodayTasksScreen if it exists

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  String _selectedItem = 'My Tasks';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _buildTaskList(String selectedItem) {
    if (selectedItem == 'My Tasks') {
      // Fetch and display today's tasks
      return TodayTasksScreen(); // Use your TodayTasksScreen widget here
    } else if (selectedItem == 'My Companies') {
     return TodayOrganizationTasksScreen();
      
    } else {
      return Container(); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedItem,
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
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue!;
                            });
                            print('Selected value: $_selectedItem');
                          },
                          items: <String>[
                            'My Tasks',
                            'My Companies',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/addtask');
                          },
                          icon: const Icon(Icons.add),
                        ),
                        const Text("Add Task"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildTaskList(_selectedItem),
          ),
        ],
      ),
      drawer: const NavSideBar(),
    );
  }
}