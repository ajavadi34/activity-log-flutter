import 'dart:convert';
import 'dart:io';
import 'package:activity_log_app/models/log-model.dart';
import 'package:activity_log_app/routes/log-editor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActivityLogListView extends StatefulWidget {
  _ActivityLogListViewState createState() => _ActivityLogListViewState();
}

class _ActivityLogListViewState extends State<ActivityLogListView> {
  static final String apiDomain = 'http://activitylogdemo.ajdrafts.com';
  final String taskApiUrl = '$apiDomain/Controller/TaskController.php';
  final String taskTypeApiUrl = '$apiDomain/Controller/TaskTypeController.php';

  Future<List<Log>> _fetchLogs() async {
    var response = await http.get(taskApiUrl);

    if (response.statusCode != HttpStatus.ok)
      throw Exception('Failed to load logs');

    final items = json.decode(response.body).cast<String, dynamic>();
    List<Log> logList = items['rows'].map<Log>((log) {
      return Log.fromJson(log);
    }).toList();

    return logList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Logs'),
        ),
        body: FutureBuilder<List<Log>>(
          future: _fetchLogs(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return ListView(
              children: snapshot.data
                  .map((log) => ListTile(
                        title: Text(log.title),
                        subtitle: Text(log.description),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(log.rowCount.toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogEditor(log))),
                      ))
                  .toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogEditor(
                Log(
                    id: 0,
                    type: '',
                    title: '',
                    description: '',
                    link: '',
                    date: null,
                    timestamp: null,
                    rowCount: 0),
              ),
            ),
          ),
          tooltip: 'Add new log',
          child: Icon(Icons.add),
        ));
  }
}
