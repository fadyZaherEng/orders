// ignore_for_file: avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';

class SearchByDateScreen extends StatefulWidget {
  SearchByDateScreen({super.key});

  @override
  State<SearchByDateScreen> createState() => _SearchByDateScreenState();
}

class _SearchByDateScreenState extends State<SearchByDateScreen> {
  DateTime firstDate = DateTime.now();
  DateTime endDate = DateTime.now();

  TimeOfDay firstTime = TimeOfDay.now();

  TimeOfDay lastTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 3,vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     Expanded(
                       child: SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                         child: Row(
                           children: 
                           [
                             TextButton(
                                 onPressed: () {
                                   _selectFirstDate(context);
                                 },
                                 child: Column(
                                   children: [
                                     Row(
                                       children: [
                                         const Icon(Icons.date_range),
                                         const SizedBox(width: 2,),
                                         Text('Date'.tr()),
                                       ],
                                     ),
                                     const SizedBox(height: 5,),
                                     Text(firstDate.toString().split(" ")[0]),
                                   ],
                                 )),
                             TextButton(
                                 onPressed: () {
                                   _selectEndDate(context);
                                 },
                                 child: Column(
                                   children: [
                                     Row(
                                       children: [
                                         const Icon(Icons.date_range),
                                         const SizedBox(width: 2,),
                                         Text('Date'.tr()),
                                       ],
                                     ),
                                     const SizedBox(height: 5,),
                                     Text(endDate.toString().split(" ")[0]),
                                   ],
                                 )),
                             TextButton(
                                 onPressed: () {
                                   _selectFirstTime(context);
                                 },
                                 child:  Column(
                                   children: [
                                     Text("First Time".tr()),
                                     const SizedBox(height: 5,),
                                     Text('${firstTime.hour>12?(firstTime.hour-12).toString():firstTime.hour.toString()}:${firstTime.minute.toString()}'),
                                   ],
                                 )),
                             TextButton(
                                 onPressed: () {
                                   _selectLastTime(context);
                                 },
                                 child:  Column(
                                   children: [
                                     Text("Last Time".tr()),
                                     const SizedBox(height: 5,),
                                     Text('${lastTime.hour>12?(lastTime.hour-12).toString():lastTime.hour.toString()}:${lastTime.minute.toString()}'),
                                   ],
                                 )),
                           ],
                         ),
                       ),
                     ),
                      TextButton(
                          onPressed: () {
                            OrdersHomeCubit.get(context).searchOrdersByDate(
                              endDate: endDate.toString(),
                              firstTime: firstTime,
                              lastTime: lastTime,
                              startDate: firstDate.toString(),    
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadiusDirectional.circular(15),
                            ),
                            child: Row(
                              children: [
                                Text("Search".tr()),
                                const SizedBox(width: 5,),
                                const Icon(Icons.search,size:30),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ConditionalBuilder(
                  condition: OrdersHomeCubit.get(context).searchOrdersDate.isNotEmpty,
                  builder: (ctx) =>
                      ListView.separated(
                        itemBuilder: (ctx, idx) {
                          return listItem(OrdersHomeCubit
                              .get(context)
                              .searchOrdersDate[idx], ctx);
                        },
                        itemCount: OrdersHomeCubit
                            .get(context)
                            .searchOrdersDate
                            .length,
                        separatorBuilder: (ctx, idx) => mySeparator(context),
                      ),
                  fallback: (ctx) =>Center(
                      child: Text("Not Orders in this time".tr())),
                ),
              ),
            ],
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

  Future<void> _selectFirstDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: firstDate,
      fieldLabelText: 'yyyy-MM-dd hh:mm:ss',
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != firstDate) {
      firstDate = picked;
      setState(() {

      });
      print("data $firstDate");
    }
  }
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: endDate,
      fieldLabelText: 'yyyy-MM-dd hh:mm:ss',
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != endDate) {
      endDate = picked;
      setState(() {

      });
      print("data $endDate");
    }
  }
  Future<void> _selectFirstTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: firstTime,
    );
    if (picked != null && picked != firstTime) {
      firstTime = picked;
      setState(() {

      });

      print("first ${firstTime.hour} ${firstTime.minute}");
    }
  }
  Future<void> _selectLastTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: lastTime,
    );
    if (picked != null && picked != lastTime) {
      lastTime = picked;
      setState(() {

      });
      print("last ${lastTime.hour} ${lastTime.minute}");
    }
  }
}
