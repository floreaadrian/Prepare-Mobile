class Bike {
  final int id;
  final String name;
  final String type;
  final String size;
  final String owner;
  final String status;

  Bike({
    this.id,
    this.name,
    this.type,
    this.size,
    this.owner,
    this.status,
  });

  Bike.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        type = json["type"],
        id = json["id"] ?? -1,
        size = json["size"],
        owner = json["owner"],
        status = json["status"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'size': size,
        'owner': owner,
        'status': status,
      };
}
