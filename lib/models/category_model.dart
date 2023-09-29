class CategoryModel {
  String catName,date;
  double  price;
  dynamic catId;
  CategoryModel(
      {
         this.catId,
      required this.price,
     required this.catName,
        required this.date,
      });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'catId': catId,
      'catName': catName,
      'price': price,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      catName: map['catName'],
      catId: map['catId'],
      date: map['date'],
      price: map['price'],
    );
  }
}
