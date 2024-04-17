import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/calendar.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
                icon: const Icon(Icons.hide_source),
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
                        'Upcoming',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: CustomDatePicker(
                        initialDate: DateTime.now(),
                        onDateSelected: (DateTime selectedDate) {
                          print('Selected date: $selectedDate');
                        },
                      ),
                    ),
                    // should show the tasks here later
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
        ],
      ),
      drawer: const NavSideBar(),
    );
  }
}
