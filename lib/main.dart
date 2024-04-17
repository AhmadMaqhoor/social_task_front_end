import 'package:flutter/material.dart';
import 'package:isd_project/auth/login.dart';
import 'package:isd_project/auth/signup.dart';
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
      '/profile': (context) => const ProfilePage(),
      '/productivity': (context) => const ProductivityPage(),
    });
  }
}
