// ignore_for_file: avoid_print, deprecated_member_use, must_be_immutable


import 'package:flutter/material.dart';
import 'package:orders/models/order_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
class DataTableScreen extends StatefulWidget {
  List<OrderModel> orders = [];

  DataTableScreen(this.orders, {super.key});

  @override
  State<DataTableScreen> createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  final pdf = pw.Document();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => [
          pw.Table.fromTextArray(data: <List<String>>[
            <String>[
              'City',
              'Area',
              'Address',
              'Order Phone',
              'Employee Phone',
              'Employee Email',
              'Employee name',
              'Item Name'
            ],
            ...widget.orders
                .map((order) => [
                      order.conservation,
                      order.city,
                      order.address,
                      order.orderPhone,
                      order.employerPhone,
                      order.employerEmail,
                      order.employerName,
                      order.type
                    ])
                .toList(),
          ], context: ctx),
        ],
      ),
    );
    //savePdf();
    print(pdf.document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Expanded(child: showOrders())),
    );
  }
  Widget showOrders(){
    return PdfPreview(build: (format)=>pdf.save(),pdfFileName: "orders.pdf",);
  }
}
