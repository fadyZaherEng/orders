class ImportModel{
  String id,import;
 ImportModel({
  required this.import,required this.id
});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'import': import,
    };
  }

  factory ImportModel.fromMap(Map<String, dynamic> map) {
    return ImportModel(
      id: map['id'] ,
      import: map['import'] ,
    );
  }
}
