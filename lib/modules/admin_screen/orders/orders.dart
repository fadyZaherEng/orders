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

class DisplayOrdersScreen extends StatefulWidget {

   DisplayOrdersScreen({super.key});

  @override
  State<DisplayOrdersScreen> createState() => _DisplayOrdersScreenState();
}

class _DisplayOrdersScreenState extends State<DisplayOrdersScreen> {
  String filterSelected="Select".tr();

  List<String>filters=[
    "Cancel",
    "Confirm",
    "Waiting"
  ];

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding:
              const EdgeInsetsDirectional.symmetric(horizontal: 3, vertical: 5),
          child: Column(
            children: [
              DropdownButton(
                focusColor: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                hint: Text(filterSelected),
                items:filters.map((filter) => DropdownMenuItem(
                  child: Text(filter.tr()),
                  value: filter.tr(),
                )).toList(),
                onChanged: (val) {
                  if (val != null) {
                    print(val);
                    filterSelected = val;
                    setState(() {

                    });
                    OrdersHomeCubit.get(context).getOrders(filterSelected);
                  }
                },
              ),
              ConditionalBuilder(
                condition: OrdersHomeCubit.get(context).orders.isNotEmpty,
                builder: (ctx) => Expanded(
                  child: ListView.separated(
                    itemBuilder: (ctx, idx) {
                      return listItem(OrdersHomeCubit.get(context).orders[idx], ctx);
                    },
                    itemCount: OrdersHomeCubit.get(context).orders.length,
                    separatorBuilder: (ctx, idx) => mySeparator(context),
                  ),
                ),
                fallback: (ctx) =>  Center(child:Text("Pleaser Entre Your Choice".tr()) ),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text('${"Order Name: ".tr()}${order.orderName}')),
                  Flexible(
                    child: Text(
                      order.confirm == true
                          ? "Confirm".tr()
                          : order.waiting == true
                              ? "Waiting".tr()
                              : "Cancel".tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${"Total Price: ".tr()}${order.totalPrice.toString()}',
                maxLines: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
