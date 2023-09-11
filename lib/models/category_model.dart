class CategoryModel {
  String catName,date, notes,source;
  double totalPrice,salOfCharging, price;
  int amount;
  dynamic catId;
  CategoryModel(
      {required this.date,
        required this.catName,
         this.catId,
      required this.salOfCharging,
      required this.notes,
      required this.totalPrice,
      required this.price,
      required this.amount,
      required this.source,
      });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'source': source,
      'catId': catId,
      'catName': catName,
      'salOfCharging': salOfCharging,
      'notes': notes,
      'totalPrice': totalPrice,
      'price': price,
      'amount': amount,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      catName: map['catName'],
      source: map['source'],
      catId: map['catId'],
      date: map['date'],
      salOfCharging: map['salOfCharging'],
      notes: map['notes'],
      totalPrice: map['totalPrice'],
      price: map['price'],
      amount: map['amount'],
    );
  }
}
