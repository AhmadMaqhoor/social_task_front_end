import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:isd_project/socialapp/navigationbarsocial.dart';
import 'package:isd_project/socialapp/cezarpostcard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExploreState();
}

class _ExploreState extends State<ExplorePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/socialapp/show-all-posts'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          posts = data['posts'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts ');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
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
          icon: Icon(Icons.menu),
        ),
        title: Text('Explore'),
      ),
      drawer: const NavSideBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  username: post['user_profile']['name'],
                  userProfileImage: post['user_profile']['image'] ?? 'https://via.placeholder.com/150',
                  postImage: post['image_path'] ?? 'https://via.placeholder.com/600',
                  caption: post['caption'],
                  likesCount: post['likes_count'],
                  commentsCount: post['comment_count'],
                  postId: post['id'],
                );
              },
            ),
    );
  }
}
