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
  bool _hasPreviousPage = false;
  bool _hasNextPage = false;
  int _totalPages = 0;

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

  bool get hasPreviousPage => _hasPreviousPage;

  bool get hasNextPage => _hasNextPage;

  int get totalPages => _totalPages;

  Future<List<Log>> getLogs(int typeId, int pageNumber) async {
    var getLogsUrl = '$taskApiUrl?Type=$typeId&PageNumber=$pageNumber';
    var response = await http.get(getLogsUrl);

    if (response.statusCode != HttpStatus.ok)
      throw Exception('Failed to load logs');

    final items = json.decode(response.body).cast<String, dynamic>();

    _logTypeList = items['types'].map<LogType>((logType) {
      return LogType.fromJson(logType);
    }).toList();

    List<Log> logList = items['rows'].map<Log>((log) {
      return Log.fromJson(log);
    }).toList();

    _totalPages = (items['totalRows'] / items['pageSize']).ceil();

    _hasPreviousPage = items['pageNumber'] > 1;

    _hasNextPage = _totalPages > items['pageNumber'];

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
