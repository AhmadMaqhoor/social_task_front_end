import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isd_project/socialapp/navigationbarsocial.dart';
import 'package:isd_project/socialapp/organizationpostcard.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
   
  List<dynamic> posts = [];
  bool isLoading = true;
  String _selectedItem = 'Companies'; // Default value
  List<String> organizationNames = ['Companies']; // Default value
  List<int> organizationIds = [-1]; // Default value

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
    fetchPosts(-1); // Fetch posts for default (all companies) initially
  }

  Future<void> fetchOrganizations() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/taskapp/get-member-organizations'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['organizations'];
      setState(() {
        organizationNames = ['Companies']; // Resetting the list
        organizationIds = [-1]; // Resetting the list
        for (final organization in data) {
          organizationNames.add(organization['title']);
          organizationIds.add(organization['id']);
        }
      });
    } else {
      throw Exception('Failed to load organizations');
    }
  }

  Future<void> fetchPosts(int organizationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/socialapp/show-all-organization-posts-by/${organizationId == -1 ? '' : organizationId.toString()}'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          posts = data['organization_post'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
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
          icon: Icon(Icons.hide_source),
        ),
        title: Text('Home'),
      ),
      drawer: const NavSideBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedItem == 'Companies' ? -1 : int.parse(_selectedItem),
                iconSize: 25,
                iconEnabledColor: Colors.blue,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                autofocus: true,
                borderRadius: BorderRadius.circular(10),
                iconDisabledColor: Colors.blue,
                focusColor: Colors.blue,
                dropdownColor: Colors.blue,
                elevation: 0,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedItem = newValue == -1 ? 'Companies' : newValue.toString();
                    isLoading = true; // Set loading to true while fetching posts
                    fetchPosts(newValue ?? -1);
                  });
                  print('Selected value: $_selectedItem');
                },
                items: organizationNames.map<DropdownMenuItem<int>>((String value) {
                  final index = organizationNames.indexOf(value);
                  return DropdownMenuItem<int>(
                    value: organizationIds[index],
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          Divider(),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return OrganizationPostCard(
                        username: post['user_profile']['name'],
                        userProfileImage: post['user_profile']['image'] ?? 'https://via.placeholder.com/150',
                        postImage: post['image_path'] ?? 'https://via.placeholder.com/600',
                        caption: post['caption'] ?? '',
                        likesCount: post['likes_count'],
                        commentsCount: post['comment_count'],
                        postId: post['id'],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
