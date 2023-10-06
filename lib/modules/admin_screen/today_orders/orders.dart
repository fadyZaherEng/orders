// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/pdf_printer/pdf.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

//checked
class TodayOrders extends StatefulWidget {
   const TodayOrders({super.key});
  @override
  State<TodayOrders> createState() => _TodayOrdersState();
}

class _TodayOrdersState extends State<TodayOrders> {
  String filterSelected="Select".tr();
  List<OrderModel> selectedOrders = [];
  pw.Document pdf = pw.Document();
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrdersHomeCubit.get(context).getTodayOrders(filterSelected);
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<OrdersHomeCubit,OrdersHomeStates>(
       listener: (ctx,state){},
       builder: (ctx,state){
         return  Padding(
           padding: const EdgeInsetsDirectional.symmetric(horizontal: 10,vertical: 5),
           child: Column(
             children: [
               DropdownButton(
                 focusColor: Theme.of(context).primaryColor,
                 borderRadius: BorderRadius.circular(10),
                 hint: Text(filterSelected),
                 items:OrdersHomeCubit.get(context).status.map((filter) => DropdownMenuItem(
                   child: Text(filter.tr()),
                   value: filter.tr(),
                 )).toList(),
                 onChanged: (val) {
                   if (val != null) {
                     filterSelected = val;
                     OrdersHomeCubit.get(context).getTodayOrders(filterSelected);
                   }
                 },
               ),
               ConditionalBuilder(
                 condition: OrdersHomeCubit
                     .get(context)
                     .todayOrders
                     .isNotEmpty,
                 builder: (ctx) =>
                     Expanded(
                       child: ListView.separated(
                         itemBuilder: (ctx, idx) {
                           return listItem(OrdersHomeCubit
                               .get(context)
                               .todayOrders[idx], idx,ctx);
                         },
                         itemCount: OrdersHomeCubit
                             .get(context)
                             .todayOrders
                             .length,
                         separatorBuilder: (ctx, idx) => mySeparator(context),
                       ),
                     ),
                 fallback: (ctx) =>
                  const Center(
                     child: CircularProgressIndicator()),
               ),
               if(OrdersHomeCubit.get(context).todayOrders.isNotEmpty)
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(0.0),
                       child: TextButton(
                           onPressed: () {
                             createExcelSheet();
                           },
                           child: Text("Copy".tr())),
                     ),
                     SizedBox(
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: MaterialButton(
                           color: Theme.of(context).primaryColor,
                           onPressed: ()async {
                             await addPage();
                             selectedOrders.clear();
                             OrdersHomeCubit.get(context).getTodayOrders(filterSelected);
                             navigateToWithReturn(context, PdfPrintOrdersScreen(pdf));
                           },
                           child: Text("Print Or Share".tr(),style: TextStyle(
                               color: Theme.of(context).scaffoldBackgroundColor
                           ),),
                         ),
                       ),
                     ),
                   ],
                 ),
             ],
           ),
         );
       },
     );
   }
  Widget listItem(OrderModel order, int idx, ctx) {
    return InkWell(
      onTap: () {
        navigateToWithReturn(
            ctx,
            UpdateOrdersScreen(
              orderModel: order,
              editEmail: OrdersHomeCubit.get(context).currentAdmin!.email,
            ));
      },
      onLongPress: () {
        order.isSelected=!order.isSelected;
        if (order.isSelected) {
          selectedOrders.add(order);
          setState(() {});
        } else {
          selectedOrders.removeAt(idx);
          setState(() {});
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                    child: Text('${"Order Name: ".tr()}${order.orderName}')),
                Flexible(
                  child: Text(
                    order.serviceType,
                  ),
                ),
                order.isSelected
                    ? Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                )
                    : const Icon(
                  Icons.check_circle,
                  color: Colors.grey,
                )
              ]),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${"Total Price: ".tr()}${order.totalPrice.toString()}',
                maxLines: 100,
              ),
              if (order.editEmail != "")
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${"edit By".tr()} ${order.editEmail} ${"to".tr()} ${order.statusOrder}',
                      maxLines: 100,
                      style: TextStyle(
                          fontSize:11,
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                ),
              Text(
                  '${"Email: ".tr()}${order.employerEmail}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addPage() async{
    // var data = await rootBundle.load("assets/fonts/Cairo_Bold.ttf");
    // dynamic ttf = pw.Font.ttf(data);
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.iBMPlexSansArabicBold(),
          ),
          textDirection: pw.TextDirection.rtl,
          mainAxisAlignment: pw.MainAxisAlignment.end,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          build: (ctx) {
       return selectedOrders.map((orderModel) {
          return  pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Order Name: ".tr()}${orderModel.orderName}',),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Order Phone: ".tr()}${orderModel.orderPhone}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Order City: ".tr()}${orderModel.conservation}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Order Area: ".tr()}${orderModel.city}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Order Address: ".tr()} ${orderModel.address}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Item Name: ".tr()}${orderModel.type}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Service Type: ".tr()}${orderModel.serviceType}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text(orderModel.number != 0
                  ? '${"Order Number: ".tr()}${orderModel.number.toString()}'
                  : ""),
              pw.SizedBox(
                height: 8,
              ),
              //barcode
              pw.Center(
                child: pw.BarcodeWidget(
                  data: orderModel.barCode,
                  barcode: pw.Barcode.qrCode(
                      errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high),
                  width: 100,
                  height: 100,
                ),
              ),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text(
                  '${"Date: ".tr()}${DateFormat().format(DateTime.parse(orderModel.date))}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Price".tr()}${orderModel.price.toString()}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text('${"Charging".tr()}${orderModel.salOfCharging.toString()}'),
              pw.SizedBox(
                height: 8,
              ),
              pw.Text("${"Total Price: ".tr()}${orderModel.totalPrice}"),
            ],
          );
        }).toList();
      }),
    );
  }

  // Future<void> printer() async{
  //   for (int i = 0; i < selectedOrders.length; i++) {
  //
  //     addPage(selectedOrders[i]);
  //   }
  // }

  void createExcelSheet() async {
//    setState(() {});
    excel.Workbook workbook = excel.Workbook();
    excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("Consignee_Name");
    sheet.getRangeByIndex(1, 2).setText("City");
    sheet.getRangeByIndex(1, 3).setText("Area");
    sheet.getRangeByIndex(1, 4).setText("Address");
    sheet.getRangeByIndex(1, 5).setText("Phone_1");
    sheet.getRangeByIndex(1, 6).setText("Order");
    sheet.getRangeByIndex(1, 7).setText("Employee_Name");
    sheet.getRangeByIndex(1, 8).setText("product");
    sheet.getRangeByIndex(1, 9).setText("Charging");
    sheet.getRangeByIndex(1, 10).setText("Item_Name");
    sheet.getRangeByIndex(1, 11).setText("Quantity");
    sheet.getRangeByIndex(1, 12).setText("Item_Description");
    sheet.getRangeByIndex(1, 13).setText("COD");
    sheet.getRangeByIndex(1, 14).setText("Weight");
    sheet.getRangeByIndex(1, 15).setText("Size");
    sheet.getRangeByIndex(1, 16).setText("Service_Type");
    sheet.getRangeByIndex(1, 17).setText("notes");

    for (int i = 0; i < OrdersHomeCubit.get(context).todayOrders.length; i++) {
      OrdersHomeCubit.get(context).updateOrder(
          orderName: OrdersHomeCubit.get(context).todayOrders[i].orderName,
          paper: OrdersHomeCubit.get(context).todayOrders[i].paper,
          conservation: OrdersHomeCubit.get(context).todayOrders[i].conservation,
          isSelected: OrdersHomeCubit.get(context).todayOrders[i].isSelected,
          statusOrder: 'جاري الشحن',
          city: OrdersHomeCubit.get(context).todayOrders[i].city,
          editEmail: OrdersHomeCubit.get(context).todayOrders[i].editEmail,
          address: OrdersHomeCubit.get(context).todayOrders[i].address,
          type: OrdersHomeCubit.get(context).todayOrders[i].type,
          barCode: OrdersHomeCubit.get(context).todayOrders[i].barCode,
          employerName: OrdersHomeCubit.get(context).todayOrders[i].employerName,
          employerPhone: OrdersHomeCubit.get(context).todayOrders[i].employerPhone,
          employerEmail: OrdersHomeCubit.get(context).todayOrders[i].employerEmail,
          orderPhone: OrdersHomeCubit.get(context).todayOrders[i].orderPhone,
          serviceType: OrdersHomeCubit.get(context).todayOrders[i].serviceType,
          notes: OrdersHomeCubit.get(context).todayOrders[i].notes,
          date:DateTime.now().toString(),
          number: OrdersHomeCubit.get(context).todayOrders[i].number,
          price: OrdersHomeCubit.get(context).todayOrders[i].price,
          totalPrice: OrdersHomeCubit.get(context).todayOrders[i].totalPrice,
          salOfCharging: OrdersHomeCubit.get(context).todayOrders[i].salOfCharging,
          context: context);
      sheet.getRangeByIndex(i + 2, 1).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].orderName);
      sheet.getRangeByIndex(i + 2, 2).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].conservation);
      sheet.getRangeByIndex(i + 2, 3).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].city);
      sheet.getRangeByIndex(i + 2, 4).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].address);
      sheet.getRangeByIndex(i + 2, 5).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].orderPhone);
      sheet.getRangeByIndex(i + 2, 6).setText(" ");
      sheet.getRangeByIndex(i + 2, 7).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].employerName);
      sheet.getRangeByIndex(i + 2, 8).setText(" ");
      sheet.getRangeByIndex(i + 2, 9).setText(" ");
      sheet.getRangeByIndex(i + 2, 10).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].type);
      sheet.getRangeByIndex(i + 2, 11).setValue(OrdersHomeCubit
          .get(context)
          .todayOrders[i].number);
      sheet.getRangeByIndex(i + 2, 12).setText(" ");
      sheet.getRangeByIndex(i + 2, 13).setNumber(OrdersHomeCubit
          .get(context)
          .todayOrders[i].totalPrice);
      sheet.getRangeByIndex(i + 2, 14).setText(" ");
      sheet.getRangeByIndex(i + 2, 15).setText(" ");
      sheet.getRangeByIndex(i + 2, 16).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].serviceType);
      sheet.getRangeByIndex(i + 2, 17).setText(OrdersHomeCubit
          .get(context)
          .todayOrders[i].notes);
    }
    //save
    final List<int>bytes = workbook.saveAsStream();
    ///File('todayOrders.xlsx').writeAsBytes(bytes);
    await workbook.save();
    workbook.dispose();
    final String path = (await getApplicationCacheDirectory()).path;
    final String fileName = '$path/todayOrders.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true,);
    OpenFile.open(fileName);
  }

}
