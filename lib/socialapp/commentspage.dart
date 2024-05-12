import 'dart:html';

import 'package:flutter/material.dart';
import 'package:isd_project/socialapp/commentcard.dart';
import 'package:isd_project/socialapp/comment.dart';

class CommentsPage extends StatefulWidget {
  final List<Comment> comments;

  CommentsPage(this.comments);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          return CommentCard(
            username: widget.comments[index].username,
            comment: widget.comments[index].comment,
          );
        },
      ),
    );
  }
}