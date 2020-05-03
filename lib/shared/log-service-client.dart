import 'package:activity_log_app/models/log-type.dart';
import 'package:activity_log_app/models/log.dart';
import 'package:activity_log_app/shared/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

/// Singleton class used for making http calls to PHP web service
class LogServiceClient {
  final String taskApiUrl = Constants.taskApiUrl;
  List<LogType> _logTypeList = [];

  static final LogServiceClient _logServiceClient =
      LogServiceClient._internal();

  final Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  LogServiceClient._internal();

  factory LogServiceClient() {
    return _logServiceClient;
  }

  List<LogType> getLogTypes() {
    return _logTypeList;
  }

  Future<List<Log>> fetchLogs() async {
    var response = await http.get(taskApiUrl);

    if (response.statusCode != HttpStatus.ok)
      throw Exception('Failed to load logs');

    final items = json.decode(response.body).cast<String, dynamic>();

    _logTypeList = items['types'].map<LogType>((logType) {
      return LogType.fromJson(logType);
    }).toList();

    List<Log> logList = items['rows'].map<Log>((log) {
      return Log.fromJson(log);
    }).toList();

    return logList;
  }

  Future<bool> saveLog(Log log) async {
    http.Response response;

    debugPrint(log.date.toString());
    debugPrint(DateFormat('yyyy/MM/dd').format(log.date));
    print(log.date);

    if (log.id > 0) {
      // update
      response = await http.put(
        taskApiUrl,
        headers: headers,
        body: json.encode({
          'Id': log.id,
          'TypeId': log.typeId,
          'Title': log.title,
          'Description': log.description,
          'Link': log.link,
          'Date': DateFormat('yyyy/MM/dd').format(log.date)
        }),
      );
    } else {
      //insert
      response = await http.post(
        taskApiUrl,
        headers: headers,
        body: json.encode({
          'TypeId': log.typeId,
          'Title': log.title,
          'Description': log.description,
          'Link': log.link,
          'Date': log.date.toString()
        }),
      );
    }

    return response.statusCode == HttpStatus.ok;
  }

  Future<bool> deleteLog(int logId) async {
    final client = http.Client();
    http.StreamedResponse response;
    final String request = json.encode({'Id': logId});

    try {
      response = await client
          .send(http.Request('DELETE', Uri.parse(taskApiUrl))..body = request);
    } finally {
      client.close();
    }

    return response.statusCode == HttpStatus.ok;
  }
}
