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

class SearchByDateScreen extends StatelessWidget {
  SearchByDateScreen({super.key});

  DateTime _date = DateTime.now();
  TimeOfDay firstTime = TimeOfDay.now();
  TimeOfDay lastTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const SizedBox(width: 2,),
                              Text('Date'.tr()),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            _selectFirstTime(context);
                          },
                          child:  Text("First Time".tr())),
                      TextButton(
                          onPressed: () {
                            _selectLastTime(context);
                          },
                          child:  Text("Last Time".tr())),
                      TextButton(
                          onPressed: () {
                            OrdersHomeCubit.get(context).searchOrdersByDate(
                                _date.toString(), firstTime, lastTime);
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
              ConditionalBuilder(
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
                fallback: (ctx) =>state is  ViewFileLoadingStates?
                const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    )):Container(),
              )
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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: _date,
      fieldLabelText: 'yyyy-MM-dd hh:mm:ss',
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != _date) {
      _date = picked;
      print("data $_date");
    }
  }

  Future<void> _selectFirstTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: firstTime,
    );
    if (picked != null && picked != firstTime) {
      firstTime = picked;
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
      print("last ${lastTime.hour} ${lastTime.minute}");
    }
  }
}
