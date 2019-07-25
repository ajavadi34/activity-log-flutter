import 'dart:convert';
import 'dart:io';
import 'package:activity_log_app/models/log-model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ListViewApiState extends StatefulWidget {
  _ListViewApiState createState() => _ListViewApiState();
}

class _ListViewApiState extends State<ListViewApiState> {
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

  void _viewLog(Log log) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(log.title),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(log.type),
              ),
              SimpleDialogOption(
                child: Text(log.description),
              ),
              SimpleDialogOption(
                child: new InkWell(
                    child: new Text(log.link), onTap: () => launch(log.link)),
              ),
              SimpleDialogOption(
                child: Text(log.date.toString()),
              ),
            ],
          );
        });
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
                        onTap: () => _viewLog(log),
                      ))
                  .toList(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _viewLog(Log(
              id: 0,
              type: '',
              title: '',
              description: '',
              link: '',
              date: null,
              timestamp: null,
              rowCount: 0)),
          tooltip: 'Add new log',
          child: Icon(Icons.add),
        ));
  }
}
