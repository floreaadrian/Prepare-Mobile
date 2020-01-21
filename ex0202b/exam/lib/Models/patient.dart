class Patient {
  final int id;
  final String name;

  Patient({
    this.id,
    this.name,
  });

  Patient.fromJson(Map<String, dynamic> json)
      : name = json["name"] ?? "",
        id = json["id"] ?? -1;

  Map<String, dynamic> toJson() => {
        'id': id ?? -1,
        'name': name ?? "",
      };
}
