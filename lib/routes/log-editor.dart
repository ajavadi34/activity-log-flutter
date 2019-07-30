import 'package:activity_log_app/models/log-model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LogEditor extends StatefulWidget {
  final Log log;
  LogEditor(this.log);

  @override
  State<StatefulWidget> createState() => _LogEditorState(log);
}

class _LogEditorState extends State<LogEditor> {
  Log log;
  _LogEditorState(this.log);

  TextEditingController typeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    final double _formDistance = 5.0;

    typeController.text = log.type;
    titleController.text = log.title;
    descriptionController.text = log.description;
    linkController.text = log.link;

    return Scaffold(
      appBar: AppBar(
        title: Text("Log Editor"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: TextField(
                controller: typeController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: TextField(
                controller: titleController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: linkController,
                      style: textStyle,
                      decoration: InputDecoration(
                        labelText: "Link",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Icon(Icons.open_in_new),
                    onTap: () => launch(log.link),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: TextField(
                controller: dateController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2018),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark(),
                        child: child,
                      );
                    },
                  ).then((value) => dateController.text = value.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
