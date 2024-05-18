import 'package:flutter/material.dart';
import 'package:isd_project/taskmanager/addcompanytask.dart';
import 'package:isd_project/taskmanager/adminlistingpendingtasklist.dart';
import 'package:isd_project/taskmanager/adminlistingcompletedtask.dart';
import 'package:isd_project/taskmanager/navigationbar.dart';
import 'package:isd_project/taskmanager/memberlist.dart'; // Import MemberList
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyPage extends StatefulWidget {
  final String companyName;
  final int companyId;
  const CompanyPage(
      {super.key, required this.companyName, required this.companyId});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

Widget _buildPendingTaskList(int companyId) {
  return AdminListingPendingTaskScreen(companyId: companyId);
}

Widget _buildCompletedTaskList(int companyId) {
  return AdminListingCompletedTaskScreen(companyId: companyId);
}

class _CompanyPageState extends State<CompanyPage> {
  String _selectedSection = 'Tasks';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.companyName),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.hide_source),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSectionButton('Assign Tasks'),
                _buildSectionButton('Submitted Tasks'),
                _buildSectionButton('Inbox'),
                _buildSectionButton('Members'),
              ],
            ),
            SizedBox(height: 20),
            if (_selectedSection == 'Assign Tasks')
              Expanded(
                child: _buildPendingTaskList(widget.companyId),
              ),
            if (_selectedSection == 'Submitted Tasks')
              Expanded(
                child: _buildCompletedTaskList(widget.companyId),
              ),
            if (_selectedSection == 'Inbox') ...[
              // Replace with inbox widget
              Text('Inbox Page'),
            ],
            if (_selectedSection == 'Members') ...[
              // Use MemberList widget and pass companyId
              Expanded(
                child: MemberList(companyId: widget.companyId),
              ),
              SizedBox(height: 20),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _showInviteMembersDialog(context);
                    },
                    icon: Icon(Icons.add),
                  ),
                  Text('Invite Members'),
                ],
              ),
            ],
            if (_selectedSection == 'Assign Tasks') ...[
              SizedBox(height: 5),
              Divider(
                color: Colors.black,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddCompanyTaskPage();
                        },
                      );
                    },
                    icon: Icon(Icons.add),
                    color: Colors.black,
                    iconSize: 30,
                  ),
                  Text(
                    'Add Task',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      drawer: const NavSideBar(),
    );
  }

  Widget _buildSectionButton(String section) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedSection = section;
        });
      },
      child: Text(section),
    );
  }

  void _showInviteMembersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InviteMembersDialog(companyId: widget.companyId);
      },
    );
  }
}

class InviteMembersDialog extends StatefulWidget {
  final int companyId;

  const InviteMembersDialog({Key? key, required this.companyId})
      : super(key: key);

  @override
  _InviteMembersDialogState createState() => _InviteMembersDialogState();
}

class _InviteMembersDialogState extends State<InviteMembersDialog> {
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> createInvite() async {
    final String email = _emailController.text.trim();
    final String message = _messageController.text.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/taskapp/organizations/${widget.companyId}/send-invitation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(
          <String, String>{'recipient_email': email, 'message': message}),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent successfully'),
        ),
      );
    } else {
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to invite member'),
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

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite Member'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(hintText: "Enter member's email"),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(hintText: "Enter message"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Invite'),
          onPressed: createInvite,
        ),
      ],
    );
  }
}
