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
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class TodayOrders extends StatefulWidget {
   const TodayOrders({super.key});

  @override
  State<TodayOrders> createState() => _TodayOrdersState();
}

class _TodayOrdersState extends State<TodayOrders> {
  String date="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    OrdersHomeCubit.get(context).getTodayOrders();
  }
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<OrdersHomeCubit,OrdersHomeStates>(
       listener: (ctx,state){},
       builder: (ctx,state){
         return  Padding(
           padding: const EdgeInsets.all(10.0),
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
                             getData();
                             Share.share(date);
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
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
             children: [
               Text('${"Order Name: ".tr()}${order.orderName}'),
               const Spacer(),
               Text('${"Total Price: ".tr()}${order.totalPrice.toString()}'),
             ],
           ),
         ),
       ),
     );
   }
  void getData() {
    date="";
    String res = "";
    OrdersHomeCubit
        .get(context)
        .todayOrders.forEach((element) {
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
    });
  }
}
