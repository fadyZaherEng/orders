class OrderModel {
  dynamic orderName,
      conservation,
      city,
      address,
      type,
      employerName,
      employerEmail,
      employerPhone,
      orderPhone,
      serviceType,
      statusOrder,
      notes,
    paper,
  editEmail,
      date;
  int number;
  double price, totalPrice, salOfCharging;
  dynamic barCode;
  bool isSelected;

  OrderModel({
    required this.serviceType,
    required this.notes,
    required this.editEmail,
    required this.statusOrder,
    required this.employerPhone,
    required this.employerEmail,
    required this.orderName,
    required this.orderPhone,
    required this.conservation,
    required this.city,
    required this.address,
    required this.type,
    this.barCode,
    required this.employerName,
    required this.date,
    required this.number,
    required this.price,
    required this.totalPrice,
    required this.salOfCharging,
    required this.isSelected,
    required this.paper,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderName': orderName,
      'editEmail': editEmail,
      'statusOrder': statusOrder,
      'conservation': conservation,
      'city': city,
      'isSelected': isSelected,
      'address': address,
      'type': type,
      'paper': paper,
      'employerName': employerName,
      'employerEmail': employerEmail,
      'employerPhone': employerPhone,
      'orderPhone': orderPhone,
      'serviceType': serviceType,
      'notes': notes,
      'date': date,
      'number': number,
      'price': price,
      'totalPrice': totalPrice,
      'salOfCharging': salOfCharging,
      'barCode': barCode,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderName: map['orderName'],
      conservation: map['conservation'],
      city: map['city'],
      paper: map['paper'],
      statusOrder: map['statusOrder'],
      editEmail: map['editEmail'],
      address: map['address'],
      type: map['type'],
      isSelected: map['isSelected'],
      employerName: map['employerName'],
      employerEmail: map['employerEmail'],
      employerPhone: map['employerPhone'],
      orderPhone: map['orderPhone'],
      serviceType: map['serviceType'],
      notes: map['notes'],
      date: map['date'],
      number: map['number'],
      price: map['price'],
      totalPrice: map['totalPrice'],
      salOfCharging: map['salOfCharging'],
      barCode: map['barCode'],
    );
  }
}
