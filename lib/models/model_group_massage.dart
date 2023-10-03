class MassageModelGroup {
  dynamic text, dateTime, senderId,createdAt, name;
  MassageModelGroup(
      {required this.name,
      required this.createdAt,
      required this.text,
      required this.dateTime,
      required this.senderId,
});

  MassageModelGroup.fromJson(Map<String, dynamic>? json) {
    senderId = json!['senderId'];
    text = json['text'];
    dateTime = json['dateTime'];
    createdAt = json['createdAt'];
    name = json['name'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'dateTime': dateTime,
      'createdAt': createdAt,
      'name': name
    };
  }
}
