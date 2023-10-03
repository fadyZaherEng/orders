// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/calcus/calcus.dart';
import 'package:orders/shared/components/components.dart';

class ShowPapersDetailsScreen extends StatefulWidget {
  const ShowPapersDetailsScreen({super.key});

  @override
  State<ShowPapersDetailsScreen> createState() =>
      _ShowPapersDetailsScreenState();
}

class _ShowPapersDetailsScreenState extends State<ShowPapersDetailsScreen> {
  DateTime dayDate = DateTime.now();
  String filterSelected = "Select".tr();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  TextButton(
                      onPressed: () async {
                        await _selectDayDate(context);
                        OrdersHomeCubit.get(context)
                            .getPapers(dayDate.toString());
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.date_range),
                              const SizedBox(
                                width: 2,
                              ),
                              Text('Date'.tr()),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(dayDate.toString().split(" ")[0]),
                        ],
                      )),
                  ConditionalBuilder(
                    condition:
                    OrdersHomeCubit.get(context).papersDetails.isNotEmpty,
                    builder: (ctx) => Expanded(
                      child: ListView.separated(
                        itemBuilder: (ctx, idx) {
                          String key = OrdersHomeCubit.get(context)
                              .papersDetails
                              .keys
                              .elementAt(idx);
                          return listItem(
                              OrdersHomeCubit.get(context).papersDetails[key],
                              key,
                              ctx);
                        },
                        itemCount: OrdersHomeCubit.get(context)
                            .papersDetails
                            .keys
                            .length,
                        separatorBuilder: (ctx, idx) => mySeparator(context),
                      ),
                    ),
                    fallback: (ctx) =>
                        Center(child: Text("Not Found Order".tr())),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDayDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: dayDate,
      fieldLabelText: 'yyyy-MM-dd hh:mm:ss',
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != dayDate) {
      dayDate = picked;
      setState(() {});
      print("data $dayDate");
    }
  }

  Widget listItem(List<OrderModel>? orders, String paper, ctx) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              '${'Page Name : '.tr()}$paper',
              maxLines: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            if (orders!.isNotEmpty)
              Text(
                '${'Orders Number : '.tr()}${orders!.length.toString()}',
                maxLines: 100,
              ),
            const SizedBox(
              height: 20,
            ),
            if (orders!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    navigateToWithReturn(context, CalcusScreen(paper, orders));
                  },
                  child: Text(
                    "Calcus".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}