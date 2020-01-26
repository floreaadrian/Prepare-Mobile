class Item {
  final int id;
  final String details;
  final String status;
  final int user;
  final int age;
  final String type;

  Item({
    this.id,
    this.details,
    this.status,
    this.user,
    this.age,
    this.type,
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        details = json["details"],
        status = json["status"],
        user = json["user"],
        age = json["age"],
        type = json["type"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'details': details,
        'status': status,
        'user': user,
        'age': age,
        'type': type,
      };
}
