import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
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
                        'Completed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
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
                        Icon(Icons.check_circle),
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
