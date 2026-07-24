class RoomModel {
  final String id;
  final String name;
  final String description;
  final String hostId;
  final List<String> participants;
  final List<String> moderators;
  final bool isLocked;
  final String? password;
  final DateTime createdAt;

  RoomModel({
    required this.id,
    required this.name,
    required this.description,
    required this.hostId,
    required this.participants,
    required this.moderators,
    this.isLocked = false,
    this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'hostId': hostId,
      'participants': participants,
      'moderators': moderators,
      'isLocked': isLocked,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      hostId: map['hostId'] ?? '',
      participants: List<String>.from(map['participants'] ?? []),
      moderators: List<String>.from(map['moderators'] ?? []),
      isLocked: map['isLocked'] ?? false,
      password: map['password'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
