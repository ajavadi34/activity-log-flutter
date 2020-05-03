class LogType {
  int typeId;
  String name;
  int hasTasks;

  LogType({this.typeId, this.name, this.hasTasks});

  factory LogType.fromJson(Map<String, dynamic> json) {
    return LogType(
      typeId: int.parse(json['TypeId']),
      name: json['Name'],
      hasTasks: json['HasTasks'] != null ? int.parse(json['HasTasks']) : 0,
    );
  }
}
