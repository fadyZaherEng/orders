import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/shared/components/components.dart';
//checked
class EmployerTodayOrdersScreen extends StatefulWidget {
  EmployerTodayOrdersScreen({super.key});

  @override
  State<EmployerTodayOrdersScreen> createState() =>
      _EmployerTodayOrdersScreenState();
}

class _EmployerTodayOrdersScreenState extends State<EmployerTodayOrdersScreen> {
  String radioSelected = "";

  @override
  void initState() {
    super.initState();
    OrdersHomeCubit.get(context).getTodayTotalTodayOrdersOfCurrentEmp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 3, vertical: 5),
              child: ConditionalBuilder(
                condition: OrdersHomeCubit.get(context).totalTodayOrdersOfCurrentEmpList.isNotEmpty,
                builder: (ctx) => ListView.separated(
                  itemBuilder: (ctx, idx) {
                    return listItem(
                      OrdersHomeCubit.get(context).totalTodayOrdersOfCurrentEmpList[idx],
                      ctx,
                    );
                  },
                  itemCount: OrdersHomeCubit.get(context)
                      .totalTodayOrdersOfCurrentEmpList
                      .length,
                  separatorBuilder: (ctx, idx) => mySeparator(context),
                ),
                fallback: (ctx) => Center(child: Text("Not Orders ".tr())),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget listItem(OrderModel order, ctx) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children:
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Text('${"Order Name: ".tr()}${order.orderName}')),
                Flexible(
                    child: Text(
                  '${"Total Price: ".tr()}${order.totalPrice.toString()}',
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      order.confirm = true;
                      order.waiting=false;
                      OrdersHomeCubit.get(context).updateOrderConfirm(
                          orderModel: order, context: context);
                    });
                  },
                  child: Text(
                    "Confirm".tr(),
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(
                      () {
                        order.confirm = false;
                        order.waiting=false;
                        OrdersHomeCubit.get(context).updateOrderConfirm(
                            orderModel: order, context: context);
                      },
                    );
                  },
                  child: Text(
                    "Cancel".tr(),
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                setState(() {
                  order.waiting = true;
                  order.confirm=false;
                  OrdersHomeCubit.get(context).updateOrderWaiting(
                      orderModel: order, context: context);
                });
              },
              child: Text(
                "Waiting".tr(),
                style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
