class Voice {
  String? id;
  String? url;
  String? userId;
  final VoiceState state;
  final DateTime createdAt;

  Voice({
    this.id,
    this.url,
    this.userId,
    required this.state,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "userId": userId,
        "state": state,
        "createdAt": createdAt,
      };
}

enum VoiceState {
  angry,
  happy,
  sad,
}
