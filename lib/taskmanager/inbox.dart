import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Text(
                        'Inbox',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text('Tasks received from company'),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.circle_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text('task 1 is to do this thing'),
                        Spacer(),
                        Icon(Icons.visibility),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.delete),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.check_circle_outline),
                        SizedBox(
                          width: 5,
                        ),
                        Text('task 2 is to do this other thing which is'),
                        Spacer(),
                        Icon(Icons.visibility),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.delete),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.check_circle),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            'task 3 is to do this other thing which is different from 1 and 2'),
                        Spacer(),
                        Icon(Icons.visibility),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.delete),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
      drawer: const NavSideBar(),
    );
  }
}
