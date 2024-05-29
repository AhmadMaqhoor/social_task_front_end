import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isd_project/socialapp/navigationbarsocial.dart';
import 'package:isd_project/socialapp/profilepostcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialProfilePage extends StatefulWidget {
  @override
  _SocialProfilePageState createState() => _SocialProfilePageState();
}

class _SocialProfilePageState extends State<SocialProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Map<String, dynamic> _userProfile = {};
  List<dynamic> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/socialapp/show-all-user-posts'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _userProfile = responseData['user_profile'];
        _posts = responseData['posts'];
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildProfileInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_userProfile['image']),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userProfile['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(_userProfile['email']),
              SizedBox(height: 8),
              Text('Score: ${_userProfile['score']}'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.hide_source),
        ),
        title:const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  buildProfileInfo(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return ProfilePostCard(
                        username: _userProfile['name'],
                        userProfileImage: _userProfile['image'],
                        postImage: post['image_path'],
                        caption: post['caption'],
                        likesCount: post['likes_count'],
                        commentsCount: post['comment_count'],
                        postId: post['id'],
                        fetchPosts:
                            fetchPosts, // Pass fetchPosts as a parameter
                      );
                    },
                  ),
                ],
              ),
            ),
      drawer: const NavSideBar(),
    );
  }
}