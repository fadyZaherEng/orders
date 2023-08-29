class OrderModel {
  String orderName, conservation, city, address,
      type,
      barCode,
      employerName,
      employerEmail,
      employerPhone,
      orderPhone,
      date;
     dynamic orderId;
  int number;
  double price, totalPrice, salOfCharging;

  OrderModel(
      {
        required this.employerPhone,
        required this.employerEmail,
        required this.orderName,
       this.orderId,
       required this.orderPhone,
      required this.conservation,
      required this.city,
      required this.address,
      required this.type,
      required this.barCode,
      required this.employerName,
      required this.date,
      required this.number,
      required this.price,
      required this.totalPrice,
      required this.salOfCharging});

  Map<String, dynamic> toMap() {
    return {
      'orderName': orderName,
      'orderPhone': orderPhone,
      'orderId':orderId,
      'conservation': conservation,
      'city': city,
      'address': address,
      'type': type,
      'barCode': barCode,
      'employerName': employerName,
      'employerPhone': employerPhone,
      'date': date,
      'number': number,
      'price': price,
      'employerEmail': employerEmail,
      'totalPrice': totalPrice,
      'salOfCharging': salOfCharging,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      employerEmail: map['employerEmail'],
      orderId:map['orderId'],
      orderPhone:map['orderPhone'],
      orderName: map['orderName'] ,
      employerPhone: map['employerPhone'] ,
      conservation: map['conservation'] ,
      city: map['city'] ,
      address: map['address'] ,
      type: map['type'] ,
      barCode: map['barCode'] ,
      employerName: map['employerName'] ,
      date: map['date'] ,
      number: map['number'],
      price: map['price'] ,
      totalPrice: map['totalPrice'] ,
      salOfCharging: map['salOfCharging'] ,
    );
  }
}
