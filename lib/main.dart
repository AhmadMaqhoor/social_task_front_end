import 'package:flutter/material.dart';
import 'package:isd_project/auth/login.dart';
import 'package:isd_project/auth/signup.dart';
import 'package:isd_project/socialapp/createpost.dart';
import 'package:isd_project/socialapp/explore.dart';
import 'package:isd_project/socialapp/home.dart';
import 'package:isd_project/socialapp/notifications.dart';
import 'package:isd_project/socialapp/profile.dart';
import 'package:isd_project/socialapp/search.dart';
import 'package:isd_project/taskmanager/addtask.dart';
import 'package:isd_project/taskmanager/company.dart';
import 'package:isd_project/taskmanager/completed.dart';
import 'package:isd_project/taskmanager/inbox.dart';
import 'package:isd_project/taskmanager/productivity.dart';
import 'package:isd_project/taskmanager/profile.dart';
import 'package:isd_project/taskmanager/settings.dart';
import 'package:isd_project/taskmanager/today.dart';
import 'package:isd_project/taskmanager/upcoming.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => const LoginPage(),
      '/signup': (context) => const SignupPage(),
      '/inbox': (context) => const InboxPage(),
      '/settings': (context) => const SettingsPage(),
      '/addtask': (context) => const AddTaskPage(),
      '/today': (context) => const TodayPage(),
      '/upcoming': (context) => const UpcomingPage(),
      '/completed': (context) => const CompletedPage(),
      '/company': (context) => const CompanyPage(),
      '/profile': (context) => ProfilePage(),
      '/productivity': (context) => const ProductivityPage(),
      '/home': (context) => const HomePage(),
      '/explore': (context) => const ExplorePage(),
      '/notifications': (context) => const NotificationPage(),
      '/search': (context) => const SearchPage(),
      '/createpost': (context) => CreatePostDialog(),
      '/socialprofile': (context) => const SocialProfilePage(),
    });
  }
}
