class Log {
  int id;
  String type;
  String title;
  String description;
  String link;
  DateTime date;
  DateTime timestamp;
  int rowCount;

  Log({
    this.id,
    this.type,
    this.title,
    this.description,
    this.link,
    this.date,
    this.timestamp,
    this.rowCount
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: int.parse(json['Id']),
      type: json['Type'],
      title: json['Title'],
      description: json['Description'] ?? '',
      link: json['Link'] ?? '',
      date: DateTime.tryParse(json['Date'] ?? ''),
      timestamp: DateTime.tryParse(json['Timestamp'] ?? ''),
      rowCount: json['RowCount']
    );
  }
}