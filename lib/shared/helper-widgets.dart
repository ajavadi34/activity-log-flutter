import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperWidgets {
  void showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<bool> showConfirmDialog(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            RaisedButton(
              child: Text(
                'Yes',
                style:
                    TextStyle(color: Theme.of(context).dialogBackgroundColor),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context, false),
            )
          ],
        );
      },
    );
  }
}
