class User {
  final int id;
  final int orders;

  User({
    this.id,
    this.orders,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        orders = json["orders"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'orders': orders,
      };
}
