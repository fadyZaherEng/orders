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

class TodayOrders extends StatelessWidget {
   const TodayOrders({super.key});
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
                 ListView.separated(
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
             fallback: (ctx) =>
             const Center(
                 child: CircularProgressIndicator(
                   color: Colors.blue,
                 )),
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
}
