// ignore_for_file: avoid_print, deprecated_member_use, must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:orders/models/order_model.dart';

class DataTableScreen extends StatefulWidget {
  List<OrderModel> orders = [];

  DataTableScreen(this.orders, {super.key});

  @override
  State<DataTableScreen> createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  String date = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Share.share(date);
              },
              child: Text("Copy".tr())),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: getData(context),
          ),
        ),
      ),
    );
  }

  List<Widget> getData(ctx) {
    List<Widget> list = [];
    date="";
    String res = "";
    widget.orders.forEach((element) {
      res = "";
      res += "City: "+element.conservation +
          " | " +
          "Area: "+ element.city +
          " | " +
          "Address: "+ element.address +
          " | " +
          "Client Phone: "+element.orderPhone +
          " | " +
          "Employer Phone: "+element.employerPhone +
          " | " +
          "Employer Email: "+element.employerEmail +
          " | " +
          "Employer Name: "+element.employerName +
          " | " +
          "Item Type: "+element.type +
          " | " +
          "Date: "+element.date;
      date += res + "\n";
      date += "----------------------------------------------------------- \n";
      list.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:
        InkWell(onTap:(){
          navigateToWithReturn(ctx, UpdateOrdersScreen(element));
        },child: Text(res+ "\n",maxLines: 20,)),
      ));
      list.add(
        mySeparator(context),
      );
    });

    return list;
  }
}

