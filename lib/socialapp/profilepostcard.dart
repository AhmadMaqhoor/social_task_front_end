import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isd_project/socialapp/commentspage.dart';
import 'package:isd_project/socialapp/comment.dart';
import 'package:isd_project/socialapp/addcomment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePostCard extends StatefulWidget {
  final String username;
  final String userProfileImage;
  final String postImage;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final int postId;
  final Function fetchPosts; // Add this parameter

  const ProfilePostCard({
    Key? key,
    required this.username,
    required this.userProfileImage,
    required this.postImage,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.postId,
    required this.fetchPosts, // Add this parameter
  }) : super(key: key);

  @override
  _ProfilePostCardState createState() => _ProfilePostCardState();
}

class _ProfilePostCardState extends State<ProfilePostCard> {
  late bool _isLiked = false;
  late int _likesCount;
  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchLikedStatus();
    _likesCount = widget.likesCount;
  }

  Future<void> _fetchLikedStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/socialapp/like-post-status-by/${widget.postId}'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _isLiked = responseData['liked'];
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _toggleLike() async {
    await _fetchLikedStatus();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.put(
      Uri.parse(
          'http://127.0.0.1:8000/api/socialapp/like-post/${widget.postId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, bool>{"liked": !_isLiked}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _isLiked = !_isLiked; // Toggle the liked status
        _likesCount = responseData['updatedLikesCount'];
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(responseData['message'])),
      // );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to update like status')),
      // );
    }
  }

  Future<void> fetchComments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/socialapp/comments/${widget.postId}'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        comments = jsonDecode(response.body)['comment'];
      });
    } else {
      print('Failed to load tasks');
    }
  }

  void deletePost(int postId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to delete this post?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final response = await http.delete(
                  Uri.parse(
                      'http://127.0.0.1:8000/api/socialapp/remove-post-by/$postId'),
                  headers: <String, String>{
                    'Authorization': 'Bearer $accessToken',
                  },
                );
                if (response.statusCode == 200) {
                  widget.fetchPosts(); // Call fetchPosts after deletion
                } else {
                  print('Failed to delete post');
                }
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Delete icon to the right
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Delete icon
                IconButton(
                  onPressed: () {
                    deletePost(widget.postId); // Activate delete function
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          ),
          // Post image
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.postImage,
              fit: BoxFit.cover,
            ),
          ),
          // Likes and comments
          Row(
            children: [
              IconButton(
                onPressed: _toggleLike,
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCommentDialog(
                        postId: widget.postId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.comment),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark),
                  ),
                ),
              ),
            ],
          ),
          // Description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      "$_likesCount likes",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: widget.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '  ${widget.caption}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(child: CircularProgressIndicator());
                      },
                      barrierDismissible: false,
                    );

                    // Fetch comments
                    await fetchComments();

                    // Close loading indicator
                    Navigator.of(context).pop();

                    // Show comments page
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CommentsPage(
                          comments
                              .map((comment) => Comment(
                                    username: comment['username'],
                                    comment: comment['content'],
                                  ))
                              .toList(),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'show all ${widget.commentsCount} comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'here is the date',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
