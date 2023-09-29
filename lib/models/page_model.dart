class PageModel{
  String id,name,date;
  PageModel({
    required this.id,
    required this.name,
    required this.date,
});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'] ,
      name: map['name'] ,
      date: map['date'] ,
    );
  }
}