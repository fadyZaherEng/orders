import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/user_orders.dart';
import 'package:orders/shared/components/components.dart';

class FilterOrdersScreen extends StatefulWidget {
  const FilterOrdersScreen({super.key});

  @override
  State<FilterOrdersScreen> createState() => _FilterOrdersScreenState();
}

class _FilterOrdersScreenState extends State<FilterOrdersScreen> {
  @override
  void initState() {
    super.initState();
    OrdersHomeCubit.get(context).userOrdersFilter();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 3, vertical: 5),
          child: ConditionalBuilder(
            condition: OrdersHomeCubit.get(context).orders.isNotEmpty,
            builder: (ctx) => Expanded(
              child: ListView.separated(
                itemBuilder: (ctx, idx) {
                  return listItem(OrdersHomeCubit.get(context).userFilterOrders[idx], ctx);
                },
                itemCount: OrdersHomeCubit.get(context).orders.length,
                separatorBuilder: (ctx, idx) => mySeparator(context),
              ),
            ),
            fallback: (ctx) => const Center(child:CircularProgressIndicator()) ),
          );
      },
    );
  }

  Widget listItem(UserOrders userOrders, ctx) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          children: [Column(
            children: [
              Text(userOrders.name,maxLines: 100,),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${"Number Of All Orders: ".tr()}${userOrders.numOfAllOrders.toString()}',
                maxLines: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${"Number Of Today Orders: ".tr()}${userOrders.numOfTodayOrders.toString()}',
                maxLines: 100,
              ),
            ],
          )],
        ),
      ),
    );
  }
}