import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationItem {
  final String userProfilePicUrl;
  final String username;
  final String content;
  final String postimage;

  NotificationItem(
      {required this.userProfilePicUrl,
      required this.username,
      required this.content,
      required this.postimage});
}

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.105:8000/api/socialapp/notifications'),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notifications = (data['notifications'] as List)
              .map((item) => NotificationItem(
                    userProfilePicUrl: item['sender']['image'] ??
                        '', // Update the sender image URL
                    username:
                        item['sender']['name'] ?? '', // Update the sender name
                    content:
                        item['type'] ?? '', // Update the notification content
                    postimage: item['post']['image_path'] ??
                        '', // Update the post image URL
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load notifications');
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
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationTile(notification: notification);
      },
    );
  }
}

class NotificationTile extends StatefulWidget {
  final NotificationItem notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late String userProfilePicUrl;
  late String username;
  late String content;
  late String  postimage;

  @override
  void initState() {
    super.initState();
    userProfilePicUrl = widget.notification.userProfilePicUrl;
    username = widget.notification.username;
    content = widget.notification.content;
    postimage=widget.notification.postimage;
  }

  void _onNotificationTap() {
    // Handle the notification tap
    print('Notification from $username tapped.');
    // You can navigate to another page, show a dialog, etc.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onNotificationTap,
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
                  Text(content),
                ],
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(postimage),
              radius: 20,
            ),
          ],
        ),
      ),
    );
  }
}
