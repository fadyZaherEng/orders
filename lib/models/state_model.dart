class StateModel{
  String id,state,date;
  StateModel({
    required this.id,
    required this.state,
    required this.date,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'state': state,
      'date': date,
    };
  }

  factory StateModel.fromMap(Map<String, dynamic> map) {
    return StateModel(
      id: map['id'] ,
      state: map['state'] ,
      date: map['date'] ,
    );
  }
}