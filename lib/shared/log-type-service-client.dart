import 'dart:convert';
import 'dart:io';
import 'package:activity_log_app/models/log-type.dart';
import 'package:activity_log_app/shared/constants.dart';
import 'package:http/http.dart' as http;

class LogTypeServiceClient {
  final String taskTypeApiUrl = Constants.taskApiUrl;

  static final LogTypeServiceClient _logTypeServiceClient = LogTypeServiceClient._internal();

  LogTypeServiceClient._internal();

  factory LogTypeServiceClient() {
    return _logTypeServiceClient;
  }

  Future<List<LogType>> fetchLogTypes() async {
    var response = await http.get(taskTypeApiUrl);

    if (response.statusCode != HttpStatus.ok)
      throw Exception('Failed to load log types');

    final items = json.decode(response.body).cast<String, dynamic>();
    List<LogType> logTypeList = items.map<LogType>((log) {
      return LogType.fromJson(log);
    }).toList();

    return logTypeList;
  }
}