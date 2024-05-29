import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:isd_project/socialapp/navigationbarsocial.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String image;
  final int score;
  final int rankProdactivityId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.score,
    required this.rankProdactivityId,
  });
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  List<User> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Simulate fetching users from backend
    // Here you can call your fetch method or any other initialization
  }

  void _performSearch(String query) {
    setState(() {
      _searchResults = _users
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchSearchName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/socialapp/search-users-by-name'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'name': name,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = (data['users'] as List)
              .map((user) => User(
                    id: user['id'],
                    name: user['name'],
                    email: user['email'],
                    image: user['image'] ??
                        '', // Use empty string if image is null
                    score: user['score'],
                    rankProdactivityId: user['rank_prodactivity_id'],
                  ))
              .toList();
          _performSearch(_searchController.text);
        });
      } else {
        throw Exception('Failed to load search');
      }
    } catch (e) {
      print(e);
    }
  }

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search users',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        fetchSearchName(value); // Fetch data on each change
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.black,
                    onPressed: () {
                      fetchSearchName(_searchController
                          .text); // Fetch data on search button press
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle tap event here
                          print('Tapped on ${user.name}');
                          // You can navigate to another page or perform any other action
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.image.isNotEmpty
                                ? NetworkImage(user.image)
                                : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider, // Provide a placeholder image
                          ),
                          title: Text(user.name),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      drawer: const NavSideBar(),
    );
  }
}