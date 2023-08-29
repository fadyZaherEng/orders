class CategoryModel {
  String catName,date, notes;
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
      required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
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
