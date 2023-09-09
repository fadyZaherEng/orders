import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class OrderModel {
  String orderName, conservation, city, address,
      type,
      employerName,
      employerEmail,
      employerPhone,
      orderPhone,
      serviceType,
      notes,
      date;
  int number;
  bool confirm=false;
  double price, totalPrice, salOfCharging;
  dynamic barCode;

  OrderModel({
    required this.serviceType,
    required this.notes,
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
    required this.salOfCharging,this.confirm=false});

  Map<String, dynamic> toMap() {
    return {
      'serviceType': serviceType,
      'notes': notes,
      'orderName': orderName,
      'confirm': confirm,
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
      serviceType: map['serviceType'],
      notes: map['notes'],
      orderPhone: map['orderPhone'],
      confirm: map['confirm'],
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
