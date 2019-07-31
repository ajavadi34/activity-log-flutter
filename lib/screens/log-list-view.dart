import 'package:activity_log_app/models/log.dart';
import 'package:activity_log_app/screens/log-editor.dart';
import 'package:activity_log_app/shared/log-service-client.dart';
import 'package:flutter/material.dart';

class ActivityLogListView extends StatefulWidget {
  _ActivityLogListViewState createState() => _ActivityLogListViewState();
}

class _ActivityLogListViewState extends State<ActivityLogListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Logs'),
        ),
        body: FutureBuilder<List<Log>>(
          future: LogServiceClient().fetchLogs(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return ListView(
              children: snapshot.data
                  .map((log) => ListTile(
                        title: Text(log.title),
                        subtitle: Text(log.description),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
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
