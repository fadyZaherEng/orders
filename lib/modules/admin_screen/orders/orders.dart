// ignore_for_file: must_be_immutable, avoid_print

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
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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
    OrdersHomeCubit.get(context).getOrders(filterSelected);
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
          child: Column(
            children: [
              Row(
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
                        //  setState(() {});
                        OrdersHomeCubit.get(context).getOrders(filterSelected);
                      }
                    },
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                      createExcelSheet();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text("Share Orders".tr()),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        OrdersHomeCubit.get(context).removeCollectionsOrders(
                          orders: OrdersHomeCubit.get(context).orders,
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
                condition: OrdersHomeCubit.get(context).orders.isNotEmpty,
                builder: (ctx) => Expanded(
                  child: ListView.separated(
                    controller: controller,
                    itemBuilder: (ctx, idx) {
                      return listItem(
                          OrdersHomeCubit.get(context).orders[idx], idx, ctx);
                    },
                    itemCount: OrdersHomeCubit.get(context).orders.length,
                    separatorBuilder: (ctx, idx) => mySeparator(context),
                  ),
                ),
                fallback: (ctx) => Center(child: Text("Not Found Order".tr())),
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

  var screenShotController = ScreenshotController();

  List<Uint8List?> widgets = [];

  void createExcelSheet() async {
//    setState(() {});
    excel.Workbook workbook = excel.Workbook();
    excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("Consignee_Name");
    sheet.getRangeByIndex(1, 2).setText("City");
    sheet.getRangeByIndex(1, 3).setText("Area");
    sheet.getRangeByIndex(1, 4).setText("Address");
    sheet.getRangeByIndex(1, 5).setText("Phone_1");
    sheet.getRangeByIndex(1, 6).setText("Order");
    sheet.getRangeByIndex(1, 7).setText("Employee_Name");
    sheet.getRangeByIndex(1, 8).setText("product");
    sheet.getRangeByIndex(1, 9).setText("Charging");
    sheet.getRangeByIndex(1, 10).setText("Item_Name");
    sheet.getRangeByIndex(1, 11).setText("Quantity");
    sheet.getRangeByIndex(1, 12).setText("Item_Description");
    sheet.getRangeByIndex(1, 13).setText("COD");
    sheet.getRangeByIndex(1, 14).setText("Weight");
    sheet.getRangeByIndex(1, 15).setText("Size");
    sheet.getRangeByIndex(1, 16).setText("Service_Type");
    sheet.getRangeByIndex(1, 17).setText("notes");

    for (int i = 0; i < OrdersHomeCubit.get(context).orders.length; i++) {
      OrdersHomeCubit.get(context).updateOrder(
          orderName: OrdersHomeCubit.get(context).orders[i].orderName,
          paper: OrdersHomeCubit.get(context).orders[i].paper,
          conservation: OrdersHomeCubit.get(context).orders[i].conservation,
          isSelected: OrdersHomeCubit.get(context).orders[i].isSelected,
          statusOrder: 'جاري الشحن',
          city: OrdersHomeCubit.get(context).orders[i].city,
          editEmail: OrdersHomeCubit.get(context).orders[i].editEmail,
          address: OrdersHomeCubit.get(context).orders[i].address,
          type: OrdersHomeCubit.get(context).orders[i].type,
          barCode: OrdersHomeCubit.get(context).orders[i].barCode,
          employerName: OrdersHomeCubit.get(context).orders[i].employerName,
          employerPhone: OrdersHomeCubit.get(context).orders[i].employerPhone,
          employerEmail: OrdersHomeCubit.get(context).orders[i].employerEmail,
          orderPhone: OrdersHomeCubit.get(context).orders[i].orderPhone,
          serviceType: OrdersHomeCubit.get(context).orders[i].serviceType,
          notes: OrdersHomeCubit.get(context).orders[i].notes,
          date: OrdersHomeCubit.get(context).orders[i].date,
          number: OrdersHomeCubit.get(context).orders[i].number,
          price: OrdersHomeCubit.get(context).orders[i].price,
          totalPrice: OrdersHomeCubit.get(context).orders[i].totalPrice,
          salOfCharging: OrdersHomeCubit.get(context).orders[i].salOfCharging,
          context: context);
      sheet
          .getRangeByIndex(i + 2, 1)
          .setText(OrdersHomeCubit.get(context).orders[i].orderName);
      sheet
          .getRangeByIndex(i + 2, 2)
          .setText(OrdersHomeCubit.get(context).orders[i].conservation);
      sheet
          .getRangeByIndex(i + 2, 3)
          .setText(OrdersHomeCubit.get(context).orders[i].city);
      sheet
          .getRangeByIndex(i + 2, 4)
          .setText(OrdersHomeCubit.get(context).orders[i].address);
      sheet
          .getRangeByIndex(i + 2, 5)
          .setText(OrdersHomeCubit.get(context).orders[i].orderPhone);
      sheet.getRangeByIndex(i + 2, 6).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 7)
          .setText(OrdersHomeCubit.get(context).orders[i].employerName);
      sheet.getRangeByIndex(i + 2, 8).setText(" ");
      sheet.getRangeByIndex(i + 2, 9).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 10)
          .setText(OrdersHomeCubit.get(context).orders[i].type);
      sheet
          .getRangeByIndex(i + 2, 11)
          .setValue(OrdersHomeCubit.get(context).orders[i].number);
      sheet.getRangeByIndex(i + 2, 12).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 13)
          .setNumber(OrdersHomeCubit.get(context).orders[i].totalPrice);
      sheet.getRangeByIndex(i + 2, 14).setText(" ");
      sheet.getRangeByIndex(i + 2, 15).setText(" ");
      sheet
          .getRangeByIndex(i + 2, 16)
          .setText(OrdersHomeCubit.get(context).orders[i].serviceType);
      sheet
          .getRangeByIndex(i + 2, 17)
          .setText(OrdersHomeCubit.get(context).orders[i].notes);
    }
    //save
    final List<int> bytes = workbook.saveAsStream();

    ///File('orders.xlsx').writeAsBytes(bytes);
    await workbook.save();
    workbook.dispose();
    final String path = (await getApplicationCacheDirectory()).path;
    final String fileName = '$path/orders.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(
      bytes,
      flush: true,
    );
    OpenFile.open(fileName);
  }

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
                '${"Date: ".tr()}${DateFormat().format(DateTime.parse(orderModel.date))}'),
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
