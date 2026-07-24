class VoiceMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String audioUrl;
  final int duration;
  final DateTime timestamp;
  final String roomId;

  VoiceMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.audioUrl,
    required this.duration,
    required this.timestamp,
    required this.roomId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'audioUrl': audioUrl,
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'roomId': roomId,
    };
  }

  factory VoiceMessageModel.fromMap(Map<String, dynamic> map) {
    return VoiceMessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderAvatar: map['senderAvatar'] ?? '',
      audioUrl: map['audioUrl'] ?? '',
      duration: map['duration'] ?? 0,
      timestamp: DateTime.parse(map['timestamp']),
      roomId: map['roomId'] ?? '',
    );
  }
}
