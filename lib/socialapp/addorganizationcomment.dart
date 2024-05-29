import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddOrganizationCommentDialog extends StatefulWidget {
  final int postId;

  const AddOrganizationCommentDialog({Key? key, required this.postId})
      : super(key: key);

  @override
  _AddCommentDialogState createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddOrganizationCommentDialog> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/socialapp/organization-post/${widget.postId}/create-comment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, String>{
        'content': _commentController.text,
      }),
    );

    if (response.statusCode == 200) {
    } else {
      print('Failed to add comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: TextField(
        controller: _commentController,
        decoration: const InputDecoration(labelText: 'Enter your comment'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5, // Adds a shadow for a 3D effect
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await _addComment();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5, // Adds a shadow for a 3D effect
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}