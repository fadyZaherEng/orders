class MoneyModel{
  String type,docId;
  double value;

  MoneyModel({required this.docId,required this.type,required this.value});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'docId': docId,
    };
  }

  factory MoneyModel.fromMap(Map<String, dynamic> map) {
    return MoneyModel(
      type: map['type'] ,
      value: map['value'] ,
      docId: map['docId'] ,
    );
  }
}