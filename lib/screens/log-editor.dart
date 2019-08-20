import 'package:activity_log_app/models/log.dart';
import 'package:activity_log_app/shared/helper-widgets.dart';
import 'package:activity_log_app/shared/log-service-client.dart';
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

  TextEditingController typeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  _LogEditorState(this.log) {
    typeController.text = log.type;
    titleController.text = log.title;
    descriptionController.text = log.description;
    linkController.text = log.link;
    dateController.text = log.date.toString();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    typeController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    final double _formDistance = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Log Editor"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  maxLines: 3,
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
                    Container(
                      width: 60.0,
                      child: InkWell(
                        child: Icon(
                          Icons.open_in_new,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () => launch(log.link),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: _formDistance, bottom: _formDistance),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        style: textStyle,
                        decoration: InputDecoration(
                          labelText: "Date",
                          //hintText: DateFormat('d-MM-yyyy').format(dateSelected).toString(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60.0,
                      child: InkWell(
                        child: Icon(
                          Icons.calendar_today,
                          size: 35,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: _formDistance, bottom: _formDistance),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        onPressed: () {
                          Log updatedLog = Log(
                            id: log.id,
                            type: typeController.text,
                            title: titleController.text,
                            description: descriptionController.text,
                            link: linkController.text,
                            date: DateTime.parse(dateController.text),
                          );
                          LogServiceClient()
                              .saveLog(updatedLog)
                              .then((success) {
                            if (success)
                              Navigator.pop(context, success);
                            else
                              HelperWidgets()
                                .showSnackBar(context, 'Failed to save log');
                          }).catchError(
                            (error) => HelperWidgets()
                                .showSnackBar(context, error.toString()),
                          );
                        },
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      width: _formDistance * 5,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).buttonColor,
                        textColor: Theme.of(context).primaryColorDark,
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      dateController.text = selectedDate.toString();
      //DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }
}
