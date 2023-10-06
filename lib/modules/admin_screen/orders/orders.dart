// ignore_for_file: must_be_immutable, avoid_print

import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';

//checked
class DisplayOrdersScreen extends StatefulWidget {
  const DisplayOrdersScreen({super.key});

  @override
  State<DisplayOrdersScreen> createState() => _DisplayOrdersScreenState();
}

class _DisplayOrdersScreenState extends State<DisplayOrdersScreen> {
  String filterSelected = "Select".tr();
  List<OrderModel> selectedOrders = [];
  pw.Document pdf = pw.Document();
  ScrollController controller = ScrollController();
  int limit = 2;

  @override
  void initState() {
    super.initState();
    //OrdersHomeCubit.get(context).getOrders(filterSelected);
    // controller.addListener(() {
    //   if (controller.position.pixels == controller.position.maxScrollExtent) {
    //     OrdersHomeCubit.get(context).firstLoad(filterSelected, limit);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 3, vertical: 5),
          child:state is OrdergetLoadingStates&& state is! GetFinishedStates||
          state is ViewFileSuccessStates&& state is! GetFinishedStates||
          state is GhhhetFinishedStates && state is! GetFinishedStates
              ? Center(
            child: CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: double.parse(Random().nextInt(1).toString()),
              center: const Text(
                "waiting........",
                style:
                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: const Text(
                "Upload",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.purple,
            ),
          )
              : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton(
                    focusColor: Theme
                        .of(context)
                        .primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    hint: Text(filterSelected),
                    items: OrdersHomeCubit
                        .get(context)
                        .status
                        .map((filter) =>
                        DropdownMenuItem(
                          child: Text(filter),
                          value: filter,
                        ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        filterSelected = val;
                        //  setState(() {});
                        OrdersHomeCubit.get(context)
                            .getOrders(filterSelected);
                      }
                    },
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      OrdersHomeCubit.get(context)
                          .createExcelSheet(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("Share Orders".tr()),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        OrdersHomeCubit.get(context)
                            .removeCollectionsOrders(
                          orders: OrdersHomeCubit
                              .get(context)
                              .orders,
                          context: context,
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
              ConditionalBuilder(
                condition: OrdersHomeCubit
                    .get(context)
                    .orders
                    .isNotEmpty,
                builder: (ctx) =>
                    Expanded(
                      child: ListView.separated(
                        controller: controller,
                        itemBuilder: (ctx, idx) {
                          return listItem(
                              OrdersHomeCubit
                                  .get(context)
                                  .orders[idx],
                              idx,
                              ctx);
                        },
                        itemCount: OrdersHomeCubit
                            .get(context)
                            .orders
                            .length,
                        separatorBuilder: (ctx, idx) => mySeparator(context),
                      ),
                    ),
                fallback: (ctx) =>
                    Center(child: Text("Not Found Order".tr())),
              ),
              // OrdersHomeCubit.get(context).isLoading
              //     ? const Center(child: CircularProgressIndicator())
              //     : const SizedBox()
              // if (OrdersHomeCubit.get(context).orders.isNotEmpty)
              //   SizedBox(
              //     width: double.infinity,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: MaterialButton(
              //         color: Theme.of(context).primaryColor,
              //         onPressed: () async {
              //           await printer();
              //           Future.delayed(const Duration(seconds: 1))
              //           .then((value) {
              //             selectedOrders.clear();
              //             OrdersHomeCubit.get(context).getOrders(filterSelected);
              //             navigateToWithReturn(
              //                 context,
              //                 PdfPrintOrdersScreen(
              //                   widgets: widgets,
              //                 ));
              //           });
              //         },
              //         child: Text(
              //           "Print Or Share".tr(),
              //           style: TextStyle(
              //               color: Theme.of(context).scaffoldBackgroundColor),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }

  Widget listItem(OrderModel order, int idx, ctx) {
    return InkWell(
      onTap: () {
        navigateToWithReturn(
            ctx,
            UpdateOrdersScreen(
              orderModel: order,
              editEmail: OrdersHomeCubit
                  .get(context)
                  .currentAdmin!
                  .email,
            ));
      },
      onLongPress: () {
        order.isSelected = !order.isSelected;
        if (order.isSelected) {
          selectedOrders.add(order);
          setState(() {});
        } else {
          selectedOrders.removeAt(idx);
          setState(() {});
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                    child: Text('${"Order Name: ".tr()}${order.orderName}')),
                Flexible(
                  child: Text(
                    order.serviceType,
                  ),
                ),
                // order.isSelected
                //     ? Icon(
                //         Icons.check_circle,
                //         color: Colors.green[700],
                //       )
                //     : const Icon(
                //         Icons.check_circle,
                //         color: Colors.grey,
                //       )
              ]),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${"Total Price: ".tr()}${order.totalPrice.toString()}',
                maxLines: 100,
              ),
              if (order.editEmail != "")
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${"edit By".tr()} ${order.editEmail} ${"to".tr()} ${order
                          .statusOrder}',
                      maxLines: 100,
                      style: TextStyle(
                          fontSize: 11, color: Theme
                          .of(context)
                          .primaryColor),
                    ),
                  ),
                ),
              Text('${"Email: ".tr()}${order.employerEmail}'),
            ],
          ),
        ),
      ),
    );
  }

  var screenShotController = ScreenshotController();

  List<Uint8List?> widgets = [];

  void addPage(OrderModel orderModel) {
    Screenshot(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Text('${"Order Name: ".tr()}${orderModel.orderName}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Order Phone: ".tr()}${orderModel.orderPhone}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Order City: ".tr()}${orderModel.conservation}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Order Area: ".tr()}${orderModel.city}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Order Address: ".tr()} ${orderModel.address}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Item Name: ".tr()}${orderModel.type}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Service Type: ".tr()}${orderModel.serviceType}'),
            const SizedBox(
              height: 15,
            ),
            Text(orderModel.number != 0
                ? '${"Order Number: ".tr()}${orderModel.number.toString()}'
                : ""),
            const SizedBox(
              height: 15,
            ),
            //barcode
            Center(
              child: BarcodeWidget(
                data: orderModel.barCode,
                barcode: pw.Barcode.qrCode(
                    errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high),
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
                '${"Date: ".tr()}${DateFormat().format(
                    DateTime.parse(orderModel.date))}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Price".tr()}${orderModel.price.toString()}'),
            const SizedBox(
              height: 15,
            ),
            Text('${"Charging".tr()}${orderModel.salOfCharging.toString()}'),
            const SizedBox(
              height: 15,
            ),
            Text("${"Total Price: ".tr()}${orderModel.totalPrice}"),
          ],
        ),
        controller: screenShotController);
    screenShotController
        .capture(delay: const Duration(milliseconds: 1))
        .then((image) {
      widgets.add(
        image,
      );
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  Future<void> printer() async {
    for (int i = 0; i < selectedOrders.length; i++) {
      addPage(selectedOrders[i]);
    }
  }
}
