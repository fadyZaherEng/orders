
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orders/models/order_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
class Test extends StatefulWidget {
  List<OrderModel> orders = [];

  Test(this.orders, {super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final doc = pw.Document();
  pw.Font? font;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getFont().then((value) {
      doc.addPage(
        pw.MultiPage(
          textDirection:pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base:value,
          ),
          pageFormat: PdfPageFormat.letter,
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
                'Item Name',
                'Date'
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
                order.type,
                order.date.toString().split(" ")[0],
              ]).toList(),
            ], context: ctx),
          ],
        ),
      );
      //savePdf();
      print(doc.document);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Expanded(child: showOrders())),
    );
  }
  Widget showOrders(){
    return PdfPreview(build: (format)=>doc.save(),pdfFileName: "orders.pdf",);
  }
  Future<pw.Font> getFont()async{
    return pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf"));
  }
}
