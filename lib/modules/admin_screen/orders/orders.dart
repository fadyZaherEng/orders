// ignore_for_file: must_be_immutable, avoid_print

import 'dart:math';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/pdf_printer/pdf.dart';
import 'package:orders/modules/admin_screen/update_order/update_order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:printing/printing.dart';

//checked
class DisplayOrdersScreen extends StatefulWidget {
  const DisplayOrdersScreen({super.key});

  @override
  State<DisplayOrdersScreen> createState() => _DisplayOrdersScreenState();
}

class _DisplayOrdersScreenState extends State<DisplayOrdersScreen>
    with WidgetsBindingObserver {
  String filterSelected = "Select".tr();
  List<OrderModel> selectedOrders = [];
  ScrollController controller = ScrollController();
  int limit = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //OrdersHomeCubit.get(context).getOrders(filterSelected);
    // controller.addListener(() {
    //   if (controller.position.pixels == controller.position.maxScrollExtent) {
    //     OrdersHomeCubit.get(context).firstLoad(filterSelected, limit);
    //   }
    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.values ||
        state == AppLifecycleState.hidden) {
      for (int i = 0; i < OrdersHomeCubit.get(context).orders.length; i++) {
        OrdersHomeCubit.get(context).orders[i].isSelected = false;
      }
      Future.delayed(const Duration(seconds: 1)).then((value) {
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 0; i < OrdersHomeCubit.get(context).orders.length; i++) {
      OrdersHomeCubit.get(context).orders[i].isSelected = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 3, vertical: 5),
          child: (state is OrdergetLoadingStates ||
              state is ViewFileSuccessStates) &&
              state is! GetFinishedStates ||
              state is GhhhetFinishedStates && state is! GetFinishedStates
              ? Center(
            child: CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: double.parse(Random().nextInt(1).toString()),
              center: const Text(
                "أنتظر........",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: const Text(
                "Upload",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.purple,
            ),
          )
              : Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton(
                      focusColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      hint: Text(filterSelected),
                      items: OrdersHomeCubit.get(context)
                          .status
                          .map((filter) => DropdownMenuItem(
                        child: Text(filter),
                        value: filter,
                      ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          filterSelected = val;
                          OrdersHomeCubit.get(context)
                              .getOrders(filterSelected);
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
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
                            orders: OrdersHomeCubit.get(context).orders,
                            context: context,
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    IconButton(
                        onPressed: () async {
                          await selectAll();
                          setState(() {});
                        },
                        icon: const Icon(Icons.select_all)),
                    IconButton(
                        onPressed: () async {
                          await clearAll();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear)),
                  ],
                ),
              ),
              ConditionalBuilder(
                condition: OrdersHomeCubit.get(context).orders.isNotEmpty,
                builder: (ctx) => Expanded(
                  child: ListView.separated(
                    controller: controller,
                    itemBuilder: (ctx, idx) {
                      return listItem(
                          OrdersHomeCubit.get(context).orders[idx],
                          idx,
                          ctx);
                    },
                    itemCount: OrdersHomeCubit.get(context).orders.length,
                    separatorBuilder: (ctx, idx) => mySeparator(context),
                  ),
                ),
                fallback: (ctx) =>
                    Center(child: Text("Not Found Order".tr())),
              ),
              OrdersHomeCubit.get(context).isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox(),
              if (OrdersHomeCubit.get(context).orders.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MaterialButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        showToast(
                            message: "أنتظر....",
                            state: ToastState.SUCCESS);
                        await addPage();
                        await Future.delayed(const Duration(seconds: 3))
                            .then((value) {
                          selectedOrders.clear();
                          // OrdersHomeCubit.get(context).getOrders(
                          //     filterSelected);
                          navigateToWithReturn(
                              context,
                              PdfPrintOrdersScreen(
                                pdf,
                              ));
                        });
                        Future.delayed(const Duration(seconds: 5))
                            .then((value) {
                          for (int i = 0;
                          i <
                              OrdersHomeCubit.get(context)
                                  .orders
                                  .length;
                          i++) {
                            OrdersHomeCubit.get(context)
                                .orders[i]
                                .isSelected = false;
                          }
                          setState(() {});
                        });
                      },
                      child: Text(
                        "Print Or Share".tr(),
                        style: TextStyle(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor),
                      ),
                    ),
                  ),
                ),
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
              editEmail: OrdersHomeCubit.get(context).currentAdmin!.email,
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
                order.isSelected
                    ? Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                )
                    : const Icon(
                  Icons.check_circle,
                  color: Colors.grey,
                )
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
                      '${"edit By".tr()} ${order.editEmail} ${"to".tr()} ${order.statusOrder}',
                      maxLines: 100,
                      style: TextStyle(
                          fontSize: 11, color: Theme.of(context).primaryColor),
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

  pw.SizedBox getItem(OrderModel orderModel) {
    return pw.SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.5,
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            pw.Text(
              '${"Order Name: ".tr()}${orderModel.orderName}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Order Phone: ".tr()}${orderModel.orderPhone}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Order City: ".tr()}${orderModel.conservation}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Order Area: ".tr()}${orderModel.city}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Order Address: ".tr()}${orderModel.address}',
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 8,
                  fontWeight: pw.FontWeight.normal),
              maxLines: 3,
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Item Name: ".tr()}${orderModel.type}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Service Type: ".tr()}${orderModel.serviceType}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              orderModel.number != 0
                  ? '${"Order Number: ".tr()}${orderModel.number.toString()}'
                  : "",
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            //barcode
            pw.Center(
              child: pw.BarcodeWidget(
                data: orderModel.barCode,
                barcode: pw.Barcode.qrCode(
                    errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high),
                width: 100,
                height: 100,
              ),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Date: ".tr()}${DateFormat().format(DateTime.parse(orderModel.date))}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Price".tr()}${orderModel.price.toString()}',
              maxLines: 2,
              overflow: pw.TextOverflow.visible,
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              '${"Charging".tr()}${orderModel.salOfCharging.toString()}',
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Text(
              "${"Total Price: ".tr()}${orderModel.totalPrice}",
              style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.normal),
            ),
          ],
        ));
  }

  pw.Document pdf = pw.Document();

  Future<void> addPage() async {
    pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.standard,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.iBMPlexSansArabicSemiBold(),
          ),
          textDirection: pw.TextDirection.rtl,
          mainAxisAlignment: pw.MainAxisAlignment.end,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          build: (ctx) {
            List<pw.Widget> lists = [];
            for (int i = 0; i < selectedOrders.length ;) {
              lists.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.all(2),
                  child: pw.Column(
                    mainAxisSize: pw.MainAxisSize.min,
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            if(selectedOrders.length>i)
                              getItem(selectedOrders[i++]),
                            if(selectedOrders.length>i)
                              getItem(selectedOrders[i++]),
                          ]),
                      pw.SizedBox(height: 2),
                      pw.Container(
                          width: double.infinity,
                          height: 1,
                          color: PdfColors.grey),
                      pw.SizedBox(height: 2),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            if(selectedOrders.length>i)
                              getItem(selectedOrders[i++]),
                            if(selectedOrders.length>i)
                              getItem(selectedOrders[i++]),
                          ]),
                    ],
                  ),
                ),
              );
              //i=i+4;
            }
            return lists;
          }),
    );
  }

  Future<void> selectAll() async {
    setState(() {
      for (int i = 0; i < OrdersHomeCubit.get(context).orders.length; i++) {
        OrdersHomeCubit.get(context).orders[i].isSelected = true;
        selectedOrders.add(OrdersHomeCubit.get(context).orders[i]);
      }
    });
  }

  Future<void> clearAll() async {
    setState(() {
      for (int i = 0; i < OrdersHomeCubit.get(context).orders.length; i++) {
        OrdersHomeCubit.get(context).orders[i].isSelected = false;
      }
      selectedOrders.clear();
    });
  }
}