// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';
class TodayOrders extends StatefulWidget {
   const TodayOrders({super.key});
  @override
  State<TodayOrders> createState() => _TodayOrdersState();
}

class _TodayOrdersState extends State<TodayOrders> {
  @override
  void initState() {
    super.initState();
    OrdersHomeCubit.get(context).getTodayOrders();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<OrdersHomeCubit,OrdersHomeStates>(
       listener: (ctx,state){},
       builder: (ctx,state){
         return  Padding(
           padding: const EdgeInsetsDirectional.symmetric(horizontal: 3,vertical: 5),
           child: ConditionalBuilder(
             condition: OrdersHomeCubit
                 .get(context)
                 .todayOrders
                 .isNotEmpty,
             builder: (ctx) =>
                 Column(
                   children: [
                     Expanded(
                       child: ListView.separated(
                         itemBuilder: (ctx, idx) {
                           return listItem(OrdersHomeCubit
                               .get(context)
                               .todayOrders[idx], ctx);
                         },
                         itemCount: OrdersHomeCubit
                             .get(context)
                             .todayOrders
                             .length,
                         separatorBuilder: (ctx, idx) => mySeparator(context),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(0.0),
                       child: TextButton(
                           onPressed: () {
                             createExcelSheet();
                           },
                           child: Text("Copy".tr())),
                     ),
                   ],
                 ),
             fallback: (ctx) =>
              Center(
                 child: Text("Not Orders Today".tr())),
           ),
         );
       },
     );
   }

   Widget listItem(OrderModel order, ctx) {
     return InkWell(
       onTap: () {
         navigateToWithReturn(ctx, UpdateOrdersScreen(order));
       },
       child: Center(
         child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Flexible(child: Text('${"Order Name: ".tr()}${order.orderName}')),
           Flexible(child: Text('${"Total Price: ".tr()}${order.totalPrice.toString()}',)),
         ],
         ),
       ),
     );
   }
   void createExcelSheet()async {
    excel.Workbook workbook = excel.Workbook();
    excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("Consignee_Name");
    sheet.getRangeByIndex(1, 2).setText("City");
    sheet.getRangeByIndex(1, 3).setText("Area");
    sheet.getRangeByIndex(1, 4).setText("Address");
    sheet.getRangeByIndex(1, 5).setText("Phone_1");
    sheet.getRangeByIndex(1, 6).setText("Employee_Name");
    sheet.getRangeByIndex(1, 7).setText("Number");
    sheet.getRangeByIndex(1, 8).setText("Once");
    sheet.getRangeByIndex(1, 9).setText("Cell");
    sheet.getRangeByIndex(1, 10).setText("Item_Name");
    sheet.getRangeByIndex(1, 11).setText("Item_Description");
    sheet.getRangeByIndex(1, 12).setText("COD");
    sheet.getRangeByIndex(1, 13).setText("Weight");
    sheet.getRangeByIndex(1, 14).setText("Size");
    sheet.getRangeByIndex(1, 15).setText("Service_Type");
    sheet.getRangeByIndex(1, 16).setText("notes");

    for (int i = 0; i < OrdersHomeCubit.get(context).todayOrders.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(OrdersHomeCubit.get(context).todayOrders[i].orderName);
      sheet.getRangeByIndex(i + 2, 2).setText(OrdersHomeCubit.get(context).todayOrders[i].conservation);
      sheet.getRangeByIndex(i + 2, 3).setText(OrdersHomeCubit.get(context).todayOrders[i].city);
      sheet.getRangeByIndex(i + 2, 4).setText(OrdersHomeCubit.get(context).todayOrders[i].address);
      sheet.getRangeByIndex(i + 2, 5).setText(OrdersHomeCubit.get(context).todayOrders[i].orderPhone);
      sheet.getRangeByIndex(i + 2, 6).setText(OrdersHomeCubit.get(context).todayOrders[i].employerName);
      sheet.getRangeByIndex(i + 2, 7).setValue(" ");
      sheet.getRangeByIndex(i + 2, 8).setText(" ");
      sheet.getRangeByIndex(i + 2, 9).setText(" ");
      sheet.getRangeByIndex(i + 2, 10).setText(OrdersHomeCubit.get(context).todayOrders[i].type);
      sheet.getRangeByIndex(i + 2, 11).setText(" ");
      sheet.getRangeByIndex(i + 2, 12).setNumber(OrdersHomeCubit.get(context).todayOrders[i].totalPrice);
      sheet.getRangeByIndex(i + 2, 13).setText(" ");
      sheet.getRangeByIndex(i + 2, 14).setText(" ");
      sheet.getRangeByIndex(i + 2, 15).setText(OrdersHomeCubit.get(context).todayOrders[i].serviceType);
      sheet.getRangeByIndex(i + 2, 16).setText(OrdersHomeCubit.get(context).todayOrders[i].notes);
    }
    //save
    final List<int>bytes = workbook.saveAsStream();
    ///File('orders.xlsx').writeAsBytes(bytes);
    await workbook.save();
    workbook.dispose();
    final String path=(await getApplicationCacheDirectory()).path;
    final String fileName='$path/todayOrders.xlsx';
    final File file=File(fileName);
    await file.writeAsBytes(bytes,flush: true);
    OpenFile.open(fileName);
     //Share.share(fileName);
  }
}
