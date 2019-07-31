import 'package:activity_log_app/screens/log-list-view.dart';
import 'package:flutter/material.dart';

void main() => runApp(LogApp());

class LogApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Log',
      theme: ThemeData(
          primarySwatch: Colors.blue),
      home: ActivityLogListView(),
    );
  }
}
