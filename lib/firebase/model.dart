class Voice {
  String? id;
  String? url;
  String? userId;
  final VoiceState voiceState;
  final DateTime createdAt;

  Voice({
    this.id,
    this.url,
    this.userId,
    required this.voiceState,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "userId": userId,
        "voiceState": voiceState,
        "createdAt": createdAt,
      };
}

enum VoiceState {
  angry,
  happy,
  sad,
}
