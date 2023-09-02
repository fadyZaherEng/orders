import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/money.dart';
import 'package:orders/shared/components/components.dart';

class InformationCostsScreen extends StatelessWidget {
  const InformationCostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit,OrdersHomeStates>(
      listener: (ctx,state){},
      builder: (ctx,state){
        return  Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 3,vertical: 5),
            child: ConditionalBuilder(
              condition: OrdersHomeCubit
                  .get(context)
                  .moneys
                  .isNotEmpty,
              builder: (ctx) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemBuilder: (ctx, idx) {
                        return listItem(OrdersHomeCubit
                            .get(context)
                            .moneys[idx], ctx);
                      },
                      itemCount: OrdersHomeCubit
                          .get(context)
                          .moneys
                          .length,
                      separatorBuilder: (ctx, idx) => mySeparator(context),
                    ),
                  ),
              fallback: (ctx) =>
              const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  )),
            ),
          ),
        );
      },
    );
  }
  Widget listItem(MoneyModel moneyModel, ctx) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text('${"Type".tr()}: ${moneyModel.type}')),
          Flexible(child: Text('${"Money".tr()}: ${moneyModel.value.toString()}',)),
        ],
      ),
    );
  }
}