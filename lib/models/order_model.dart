import 'package:flutter/material.dart';

class OrderModel {
  String orderName, conservation, city, address,
      type,
      employerName,
      employerEmail,
      employerPhone,
      orderPhone,
      date;
  int number;
  double price, totalPrice, salOfCharging;
  dynamic barCode;

  OrderModel({
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
    required this.salOfCharging});

  Map<String, dynamic> toMap() {
    return {
      'orderName': orderName,
      'orderPhone': orderPhone,
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
      orderPhone: map['orderPhone'],
      orderName: map['orderName'],
      employerPhone: map['employerPhone'],
      conservation: map['conservation'],
      city: map['city'],
      address: map['address'],
      type: map['type'],
      barCode: map['barCode'],
      employerName: map['employerName'],
      date: map['date'],
      number: map['number'],
      price: map['price'],
      totalPrice: map['totalPrice'],
      salOfCharging: map['salOfCharging'],
    );
  }
}
