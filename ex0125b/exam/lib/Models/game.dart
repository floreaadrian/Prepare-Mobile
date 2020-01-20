class Game {
  final int id;
  final String name;
  final int quantity;
  final String type;
  final String status;

  Game({
    this.id,
    this.name,
    this.quantity,
    this.type,
    this.status,
  });

  Game.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        type = json["type"],
        quantity = json["quantity"],
        id = json["id"] ?? -1,
        status = json["status"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'quantity': quantity,
        'status': status,
      };
}
