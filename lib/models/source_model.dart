class SourceModel {
  String date;
  double  price;
  double total;
  int num;
  SourceModel({
        required this.price,
        required this.date,
        required this.num,
        required this.total,
      });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'price': price,
      'num': num,
      'total': total,
    };
  }

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      date: map['date'],
      total: map['total'],
      num: map['num'],
      price: map['price'],
    );
  }
}
