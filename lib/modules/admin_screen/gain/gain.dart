import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/info_costs/costs.dart';
import 'package:orders/shared/components/components.dart';

class GainScreen extends StatelessWidget {
  const GainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Calculate The Gain".tr()),
            titleSpacing: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Money Of The Cost".tr()),
                    leading: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 30,
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: ListBody(
                                    children: [
                                      Text("Advertisments".tr()),
                                      Text("Salaries".tr()),
                                      Text("Products".tr()),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      '${"Cost: ".tr()}${OrdersHomeCubit.get(context).totalPriceCost}'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        navigateToWithReturn(
                            context, const InformationCostsScreen());
                      },
                      child: Text("View Information About Costs".tr())),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Total Price Of Orders".tr()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${"The Sale Money: ".tr()}${OrdersHomeCubit.get(context).totalOfAllOrdersConfirm}',
                    maxLines: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Calculate The Gain".tr()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${"The Gain: ".tr()} '
                    '${(OrdersHomeCubit.get(context).totalOfAllOrdersConfirm - OrdersHomeCubit.get(context).totalPriceCost)}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                    maxLines: 100,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text("معلومات جاري الشحن"),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ExpansionTileGroup(children: [
                      ExpansionTileItem(
                        title: const Text("قيد التشغيل"),
                        expendedBorderColor: Colors.blue,
                        children: [
                          Text(
                            ' اجمالي السعر : ${OrdersHomeCubit.get(context).totalOfConfirmedPrice}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.purple.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            ' اجمالي العدد : ${OrdersHomeCubit.get(context).totalOfConfirmedNumber}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.purple.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
