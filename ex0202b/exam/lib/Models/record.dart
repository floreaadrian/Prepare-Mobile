class Record {
  final int id;
  final String name;
  final int patientId;
  final String details;
  final String type;
  final String status;
  final int date;

  Record({
    this.type,
    this.id,
    this.name,
    this.patientId,
    this.details,
    this.status,
    this.date,
  });

  Record.fromJson(Map<String, dynamic> json)
      : name = json["name"] ?? "",
        patientId = json["patientId"] ?? "",
        details = json["details"] ?? "",
        id = json["id"] ?? -1,
        date = json["date"] ?? -1,
        status = json["status"] ?? "",
        type = json["type"] ?? "";

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date,
        'patientId': patientId,
        'details': details,
        'status': status,
        'type': type,
      };

  String forDb() {
    return '''
      $id,
      "$type",
      "$status"
    ''';
  }
}
