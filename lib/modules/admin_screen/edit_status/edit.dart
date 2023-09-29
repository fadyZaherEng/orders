import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/shared/components/components.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

//checked
class EditOrdersScreen extends StatefulWidget {
  const EditOrdersScreen({super.key});

  @override
  State<EditOrdersScreen> createState() => _EditOrdersScreenState();
}

class _EditOrdersScreenState extends State<EditOrdersScreen> {
  List<String> serviceType = ['تسليم وتحصيل', 'جلب مرتجعات', 'استبدال'];
  String filterSelected = "Select".tr();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                DropdownButton(
                    dropdownColor: Theme.of(context).primaryColor,
                    focusColor: Theme.of(context).primaryColor,
                    underline: Container(),
                    hint: Text(
                      filterSelected,
                    ),
                    elevation: 0,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    items: OrdersHomeCubit.get(context)
                        .status
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                            filterSelected = e;
                            OrdersHomeCubit.get(context)
                                .getOrdersToEdit(
                                filterSelected);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(e),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (val) {
                      if (val.toString().isNotEmpty) {
                        filterSelected = val.toString();
                        OrdersHomeCubit.get(context)
                            .getOrdersToEdit(
                            filterSelected);
                        setState(() {});
                      }
                    }),
                const SizedBox(
                  height: 10,
                ),
                ConditionalBuilder(
                  condition: OrdersHomeCubit.get(context).editOrders.isNotEmpty,
                  builder: (ctx) => Expanded(
                    child: ListView.separated(
                      itemBuilder: (ctx, idx) {
                        return listItem(
                          OrdersHomeCubit.get(context).editOrders[idx],
                          idx,
                          ctx,
                        );
                      },
                      itemCount: OrdersHomeCubit.get(context).editOrders.length,
                      separatorBuilder: (ctx, idx) => mySeparator(context),
                    ),
                  ),
                  fallback: (ctx) =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget listItem(OrderModel order, idx, ctx) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: Text('${"Order Name: ".tr()}${order.orderName}')),
                Flexible(
                    child: Text(
                      '${"Total Price: ".tr()}${order.totalPrice.toString()}',
                    )),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            DropdownButton(
                dropdownColor: Theme.of(context).primaryColor,
                focusColor: Theme.of(context).primaryColor,
                underline: Container(),
                hint: Text(
                  OrdersHomeCubit.get(context)
                      .editOrders[idx]
                      .statusOrder,
                ),
                elevation: 0,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).scaffoldBackgroundColor),
                items: OrdersHomeCubit.get(context)
                    .status
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        OrdersHomeCubit.get(context)
                            .editOrders[idx]
                            .statusOrder = e;
                        setState(() {});
                        order.statusOrder=e;

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(e),
                      ),
                    ),
                  ),
                ).toList(),
                onChanged: (val) {
                  print('eeeeeeeeeeeeee');
                  OrdersHomeCubit.get(context)
                      .editOrders[idx]
                      .statusOrder = val;
                  order.statusOrder=val;
                  OrdersHomeCubit.get(context).updateOrderStatus(orderModel: order, context: context);
                  setState(() {});

                }),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                    child: Text(
                      '${"Item Name: ".tr()}${order.type}',
                    )),
                IconButton(
                    onPressed: () {
                      makingPhoneCall(order.orderPhone);
                    },
                    icon: const Icon(Icons.phone)),
              ],
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                setState(() {
                  order.editEmail =
                      OrdersHomeCubit.get(context).currentAdmin!.email;
                  OrdersHomeCubit.get(context)
                      .updateOrderStatus(orderModel: order, context: context);
                });
              },
              child: Text(
                "Update".tr(),
                style:
                TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makingPhoneCall(phone) async {
    var url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showToast(message: 'Could not launch $url', state: ToastState.WARNING);
    }
  }
}
