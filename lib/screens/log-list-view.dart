import 'package:activity_log_app/models/log-type.dart';
import 'package:activity_log_app/models/log.dart';
import 'package:activity_log_app/screens/log-editor.dart';
import 'package:activity_log_app/shared/helper-widgets.dart';
import 'package:activity_log_app/shared/log-service-client.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityLogListView extends StatefulWidget {
  _ActivityLogListViewState createState() => _ActivityLogListViewState();
}

class _ActivityLogListViewState extends State<ActivityLogListView> {
  int _selectedLogTypeId = 0;
  int _currentPage = 1;
  LogServiceClient _logServiceClient = LogServiceClient();

  Widget _getLinkIcon(String link) {
    if (link != null && link.isNotEmpty) {
      return IconButton(
        icon: Icon(Icons.link),
        onPressed: () {
          launch(link);
        },
      );
    } else {
      return SizedBox(
        width: 40,
      );
    }
  }

  Function _incrementPage() {
    if (!_logServiceClient.hasNextPage) {
      return null;
    }

    return () {
      setState(() {
        _currentPage++;
      });
    };
  }

  Function _decrementPage() {
    if (!_logServiceClient.hasPreviousPage) {
      return null;
    }

    return () {
      setState(() {
        _currentPage--;
      });
    };
  }

  List<ListTile> _getPagesButton() {
    return <ListTile>[
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              disabledColor: Colors.grey.shade400,
              icon: Icon(Icons.arrow_back),
              onPressed: _decrementPage(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text('$_currentPage / ${_logServiceClient.totalPages}'),
            ),
            IconButton(
              disabledColor: Colors.grey.shade400,
              icon: Icon(Icons.arrow_forward),
              onPressed: _incrementPage(),
            ),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Logs'),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.filter_list),
              itemBuilder: (BuildContext context) {
                return [
                      PopupMenuItem(
                        value: 0,
                        child: Text('No Filter'),
                      )
                    ] +
                    _logServiceClient.getLogTypes().map((LogType logType) {
                      return PopupMenuItem<int>(
                        value: logType.typeId,
                        child: Text(logType.name),
                      );
                    }).toList();
              },
              onSelected: (selectedLogType) {
                setState(() {
                  _selectedLogTypeId = selectedLogType;
                });
              },
            )
          ],
        ),
        body: FutureBuilder<List<Log>>(
          future: _logServiceClient.getLogs(_selectedLogTypeId, _currentPage),
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
                          trailing: _getLinkIcon(log.link),
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogEditor(log),
                                ),
                              ).then((response) {
                                if (response)
                                  HelperWidgets().showSnackBar(context,
                                      'Saved log #${log.id} - ${log.title}');
                              }),
                          onLongPress: () {
                            HelperWidgets()
                                .showConfirmDialog(context,
                                    'Do you want to delete log #${log.id} - ${log.title}?')
                                .then((result) {
                              if (!result) return;

                              _logServiceClient
                                  .deleteLog(log.id)
                                  .then((response) {
                                if (response) {
                                  HelperWidgets().showSnackBar(context,
                                      'Deleted log #${log.id} - ${log.title}');
                                  setState(() {});
                                } else {
                                  HelperWidgets().showSnackBar(context,
                                      'Failed to delete log #${log.id}');
                                }
                              });
                            }).catchError((error) => {});
                          }))
                      .toList() +
                  _getPagesButton(),
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
