class Room {
  final String id;
  final String name;

  Room({
    required this.id,
    required this.name,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
