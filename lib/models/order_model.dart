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
      'orderName': orderName,
      'conservation': conservation,
      'city': city,
      'address': address,
      'type': type,
      'employerName': employerName,
      'employerEmail': employerEmail,
      'employerPhone': employerPhone,
      'orderPhone': orderPhone,
      'serviceType': serviceType,
      'notes': notes,
      'date': date,
      'number': number,
      'confirm': confirm,
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
      address: map['address'],
      type: map['type'],
      employerName: map['employerName'],
      employerEmail: map['employerEmail'],
      employerPhone: map['employerPhone'],
      orderPhone: map['orderPhone'],
      serviceType: map['serviceType'],
      notes: map['notes'],
      date: map['date'],
      number: map['number'] ,
      confirm: map['confirm'],
      price: map['price'] ,
      totalPrice: map['totalPrice'] ,
      salOfCharging: map['salOfCharging'] ,
      barCode: map['barCode'] ,
    );
  }
}
