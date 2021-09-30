class Voice {
  String? id;
  String? url;
  final String userId;
  final VoiceState state;
  final DateTime createdAt;
  final String text;

  Voice({
    this.id,
    this.url,
    required this.userId,
    required this.state,
    required this.text,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "userId": userId,
        "state": state.index,
        "createdAt": createdAt,
        "text": text,
      };
}

enum VoiceState {
  angry,
  happy,
  sad,
  disgust,
  surprised,
  fear,
  neutral,
  pensive,
  funny,
  illuminated,
  love
}
