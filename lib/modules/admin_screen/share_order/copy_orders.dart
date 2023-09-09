// // ignore_for_file: avoid_print, deprecated_member_use, must_be_immutable
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:orders/models/order_model.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
// class DataTableScreen extends StatefulWidget {
//   List<OrderModel> orders = [];
//
//   DataTableScreen(this.orders, {super.key});
//
//   @override
//   State<DataTableScreen> createState() => _DataTableScreenState();
// }
//
// class _DataTableScreenState extends State<DataTableScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: Center(
//         child: IconButton(onPressed: () {
//           createExcelSheet();
//         }, icon: const Icon(Icons.night_shelter)),
//       )),
//     );
//   }
//
//
//   void createExcelSheet()async {
//     excel.Workbook workbook = excel.Workbook();
//     excel.Worksheet sheet = workbook.worksheets[0];
//     sheet.getRangeByIndex(1, 1).setText("Consignee_Name");
//     sheet.getRangeByIndex(1, 2).setText("City");
//     sheet.getRangeByIndex(1, 3).setText("Area");
//     sheet.getRangeByIndex(1, 4).setText("Address");
//     sheet.getRangeByIndex(1, 5).setText("Phone_1");
//     sheet.getRangeByIndex(1, 6).setText("Employee_Name");
//     sheet.getRangeByIndex(1, 7).setText("Number");
//     sheet.getRangeByIndex(1, 8).setText("Once");
//     sheet.getRangeByIndex(1, 9).setText("Cell");
//     sheet.getRangeByIndex(1, 10).setText("Item_Name");
//     sheet.getRangeByIndex(1, 11).setText("Item_Description");
//     sheet.getRangeByIndex(1, 12).setText("COD");
//     sheet.getRangeByIndex(1, 13).setText("Service_Type");
//     sheet.getRangeByIndex(1, 14).setText("notes");
//
//     for (int i = 0; i < widget.orders.length; i++) {
//       sheet.getRangeByIndex(i + 2, 1).setText(widget.orders[i].orderName);
//       sheet.getRangeByIndex(i + 2, 2).setText(widget.orders[i].conservation);
//       sheet.getRangeByIndex(i + 2, 3).setText(widget.orders[i].city);
//       sheet.getRangeByIndex(i + 2, 4).setText(widget.orders[i].address);
//       sheet.getRangeByIndex(i + 2, 5).setText(widget.orders[i].orderPhone);
//       sheet.getRangeByIndex(i + 2, 6).setText(widget.orders[i].employerName);
//       sheet.getRangeByIndex(i + 2, 7).setValue(widget.orders[i].counter);
//       sheet.getRangeByIndex(i + 2, 8).setText(" ");
//       sheet.getRangeByIndex(i + 2, 9).setText(" ");
//       sheet.getRangeByIndex(i + 2, 10).setText(widget.orders[i].type);
//       sheet.getRangeByIndex(i + 2, 11).setText(" ");
//       sheet.getRangeByIndex(i + 2, 12).setNumber(widget.orders[i].totalPrice);
//       sheet.getRangeByIndex(i + 2, 13).setText(widget.orders[i].serviceType);
//       sheet.getRangeByIndex(i + 2, 14).setText(widget.orders[i].notes);
//     }
//     //save
//     final List<int>bytes = workbook.saveAsStream();
//     ///File('orders.xlsx').writeAsBytes(bytes);
//     //await workbook.save();
//     workbook.dispose();
//     final String path=(await getApplicationCacheDirectory()).path;
//     final String fileName='$path/orders.xlsx';
//     final File file=File(fileName);
//     await file.writeAsBytes(bytes,flush: true);
//     OpenFile.open(fileName);
//   }
// }
