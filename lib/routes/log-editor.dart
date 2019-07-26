import 'package:activity_log_app/models/log-model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LogEditor extends StatelessWidget {
  final Log log;

  LogEditor({Key key, @required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Editor"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Title: ' + log.title),
            Text('Type: ' + log.type),
            Text('Description: ' + log.description),
            InkWell(
              child: new Text(
                log.link,
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () => launch(log.link),
            ),
            Text('Date: ' + log.date.toString()),
          ],
        ),
      ),
    );
  }
}
