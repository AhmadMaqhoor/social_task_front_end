import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MemberItem {
  final String userProfilePicUrl;
  final String username;
  final int score;

  MemberItem(
      {required this.userProfilePicUrl,
      required this.username,
      required this.score});
}

class MemberList extends StatefulWidget {
  final int companyId; // Add companyId parameter

  const MemberList({super.key, required this.companyId});

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  List<MemberItem> members = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/taskapp/organizations/${widget.companyId}/members'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          members = (data['members'] as List)
              .map((item) => MemberItem(
                    userProfilePicUrl: item['image'] ?? '',
                    username: item['name'] ?? '',
                    score: item['score'] ?? 0,
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load members');
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
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return MemberTile(member: member);
      },
    );
  }
}

class MemberTile extends StatefulWidget {
  final MemberItem member;

  const MemberTile({Key? key, required this.member}) : super(key: key);

  @override
  _MemberTileState createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  late String userProfilePicUrl;
  late String username;
  late int score;

  @override
  void initState() {
    super.initState();
    userProfilePicUrl = widget.member.userProfilePicUrl;
    username = widget.member.username;
    score = widget.member.score;
  }

  void _onMemberTap() {
    // Handle the member tap
    print('Member $username tapped.');
    // You can navigate to another page, show a dialog, etc.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onMemberTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userProfilePicUrl),
              radius: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("$score"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
