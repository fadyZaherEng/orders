// ignore_for_file: avoid_print
//checked
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
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

class SearchByDateScreen extends StatefulWidget {
  SearchByDateScreen({super.key});

  @override
  State<SearchByDateScreen> createState() => _SearchByDateScreenState();
}

class _SearchByDateScreenState extends State<SearchByDateScreen> {
  DateTime firstDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay firstTime = TimeOfDay.now();
  TimeOfDay lastTime = TimeOfDay.now();
  String filterSelected = "Select".tr();
  List<OrderModel> selectedOrders = [];
  pw.Document pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10, vertical: 5),
          child: Column(
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
                      child: Text(filter.tr()),
                      value: filter.tr(),
                    )).toList(),
                onChanged: (val) {
                  if (val != null) {
                    filterSelected = val;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 5,),
              Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            _selectFirstDate(context);
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
                              Text(firstDate.toString().split(" ")[0]),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            _selectEndDate(context);
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
                              Text(endDate.toString().split(" ")[0]),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            _selectFirstTime(context);
                          },
                          child: Column(
                            children: [
                              Text("First Time".tr()),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${firstTime.hour > 12 ? (firstTime
                                      .hour - 12).toString() : firstTime
                                      .hour.toString()}:${firstTime
                                      .minute.toString()}'),
                            ],
                          )),
                      TextButton(
                          onPressed: () {
                            _selectLastTime(context);
                          },
                          child: Column(
                            children: [
                              Text("Last Time".tr()),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '${lastTime.hour > 12 ? (lastTime
                                      .hour - 12).toString() : lastTime
                                      .hour.toString()}:${lastTime
                                      .minute.toString()}'),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(context).searchOrdersByDate(
                          endDate: endDate.toString(),
                          firstTime: firstTime,
                          lastTime: lastTime,
                          startDate: firstDate.toString(),
                          filter: filterSelected,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius:
                          BorderRadiusDirectional.circular(15),
                        ),
                        child: Row(
                          children: [
                            Text("Search".tr()),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(Icons.search, size: 30),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TextButton(
                        onPressed: () {
                          createExcelSheet();
                        },
                        child: Text("Copy".tr())),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Expanded(
                child: ConditionalBuilder(
                  condition:
                  OrdersHomeCubit
                      .get(context)
                      .searchOrdersDate
                      .isNotEmpty,
                  builder: (ctx) =>
                      ListView.separated(
                        itemBuilder: (ctx, idx) {
                          return listItem(
                              OrdersHomeCubit
                                  .get(context)
                                  .searchOrdersDate[idx], idx,
                              ctx);
                        },
                        itemCount:
                        OrdersHomeCubit
                            .get(context)
                            .searchOrdersDate
                            .length,
                        separatorBuilder: (ctx, idx) => mySeparator(context),
                      ),
                  fallback: (ctx) =>
                      Center(child: Text("Not Orders in this time".tr())),
                ),
              ),
              // if(OrdersHomeCubit.get(context).searchOrdersDate.isNotEmpty)
              //   SizedBox(
              //     width: double.infinity,
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: MaterialButton(
              //         color: Theme.of(context).primaryColor,
              //         onPressed: ()async {
              //           await printer();
              //           selectedOrders.clear();
              //           OrdersHomeCubit.get(context).searchOrdersByDate(
              //             endDate: endDate.toString(),
              //             firstTime: firstTime,
              //             lastTime: lastTime,
              //             startDate: firstDate.toString(),
              //             filter: filterSelected,
              //           );
              //           navigateToWithReturn(context, PdfPrintOrdersScreen(pdf));
              //         },
              //         child: Text("Print Or Share".tr(),style: TextStyle(
              //             color: Theme.of(context).scaffoldBackgroundColor
              //         ),),
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
                //   Icons.check_circle,
                //   color: Colors.green[700],
                // )
                //     : const Icon(
                //   Icons.check_circle,
                //   color: Colors.grey,
                // )
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
                          fontSize: 11,
                          color: Theme
                              .of(context)
                              .primaryColor
                      ),
                    ),
                  ),
                ),
              Text(
                  '${"Email: ".tr()}${order.employerEmail}'),
            ],
          ),
        ),
      ),
    );
  }

  void addPage(OrderModel orderModel) {
    pdf.addPage(
      pw.Page(build: (ctx) {
        return pw.Column(
          children: [
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Order Name: ".tr()}${orderModel.orderName}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Order Phone: ".tr()}${orderModel.orderPhone}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Order City: ".tr()}${orderModel.conservation}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Order Area: ".tr()}${orderModel.city}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Order Address: ".tr()} ${orderModel.address}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Item Name: ".tr()}${orderModel.type}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Service Type: ".tr()}${orderModel.serviceType}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text(orderModel.number != 0
                ? '${"Order Number: ".tr()}${orderModel.number.toString()}'
                : ""),
            pw.SizedBox(
              height: 15,
            ),
            //barcode
            pw.Center(
              child: pw.BarcodeWidget(
                data: orderModel.barCode,
                barcode: pw.Barcode.qrCode(
                    errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high),
                width: 200,
                height: 200,
              ),
            ),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text(
                '${"Date: ".tr()}${DateFormat().format(
                    DateTime.parse(orderModel.date))}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Price".tr()}${orderModel.price.toString()}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text('${"Charging".tr()}${orderModel.salOfCharging.toString()}'),
            pw.SizedBox(
              height: 15,
            ),
            pw.Text("${"Total Price: ".tr()}${orderModel.totalPrice}"),
          ],
        );
      }),
    );
  }

  Future<void> printer() async {
    for (int i = 0; i < selectedOrders.length; i++) {
      addPage(selectedOrders[i]);
    }
  }

  Future<void> _selectFirstDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: firstDate,
      fieldLabelText: 'yyyy-MM-dd hh:mm:ss',
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != firstDate) {
      firstDate = picked;
      setState(() {});
      print("data $firstDate");
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('en', 'US'),
      initialDate: endDate,
      fieldLabelText: 'yyyy-MM-dd hh:mm:ss',
      firstDate: DateTime(2023),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != endDate) {
      endDate = picked;
      setState(() {});
      print("data $endDate");
    }
  }

  Future<void> _selectFirstTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: firstTime,
    );
    if (picked != null && picked != firstTime) {
      firstTime = picked;
      setState(() {});

      print("first ${firstTime.hour} ${firstTime.minute}");
    }
  }

  Future<void> _selectLastTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: lastTime,
    );
    if (picked != null && picked != lastTime) {
      lastTime = picked;
      setState(() {});
      print("last ${lastTime.hour} ${lastTime.minute}");
    }
  }

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

    for (int i = 0; i < OrdersHomeCubit.get(context).searchOrdersDate.length; i++) {
      OrdersHomeCubit.get(context).updateOrder(
          orderName: OrdersHomeCubit.get(context).searchOrdersDate[i].orderName,
          paper: OrdersHomeCubit.get(context).searchOrdersDate[i].paper,
          conservation: OrdersHomeCubit.get(context).searchOrdersDate[i].conservation,
          isSelected: OrdersHomeCubit.get(context).searchOrdersDate[i].isSelected,
          statusOrder: 'جاري الشحن',
          city: OrdersHomeCubit.get(context).searchOrdersDate[i].city,
          editEmail: OrdersHomeCubit.get(context).searchOrdersDate[i].editEmail,
          address: OrdersHomeCubit.get(context).searchOrdersDate[i].address,
          type: OrdersHomeCubit.get(context).searchOrdersDate[i].type,
          barCode: OrdersHomeCubit.get(context).searchOrdersDate[i].barCode,
          employerName: OrdersHomeCubit.get(context).searchOrdersDate[i].employerName,
          employerPhone: OrdersHomeCubit.get(context).searchOrdersDate[i].employerPhone,
          employerEmail: OrdersHomeCubit.get(context).searchOrdersDate[i].employerEmail,
          orderPhone: OrdersHomeCubit.get(context).searchOrdersDate[i].orderPhone,
          serviceType: OrdersHomeCubit.get(context).searchOrdersDate[i].serviceType,
          notes: OrdersHomeCubit.get(context).searchOrdersDate[i].notes,
          date: OrdersHomeCubit.get(context).searchOrdersDate[i].date,
          number: OrdersHomeCubit.get(context).searchOrdersDate[i].number,
          price: OrdersHomeCubit.get(context).searchOrdersDate[i].price,
          totalPrice: OrdersHomeCubit.get(context).searchOrdersDate[i].totalPrice,
          salOfCharging: OrdersHomeCubit.get(context).searchOrdersDate[i].salOfCharging,
          context: context);
      sheet.getRangeByIndex(i + 2, 1).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].orderName);
      sheet.getRangeByIndex(i + 2, 2).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].conservation);
      sheet.getRangeByIndex(i + 2, 3).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].city);
      sheet.getRangeByIndex(i + 2, 4).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].address);
      sheet.getRangeByIndex(i + 2, 5).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].orderPhone);
      sheet.getRangeByIndex(i + 2, 6).setText(" ");
      sheet.getRangeByIndex(i + 2, 7).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].employerName);
      sheet.getRangeByIndex(i + 2, 8).setText(" ");
      sheet.getRangeByIndex(i + 2, 9).setText(" ");
      sheet.getRangeByIndex(i + 2, 10).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].type);
      sheet.getRangeByIndex(i + 2, 11).setValue(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].number);
      sheet.getRangeByIndex(i + 2, 12).setText(" ");
      sheet.getRangeByIndex(i + 2, 13).setNumber(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].totalPrice);
      sheet.getRangeByIndex(i + 2, 14).setText(" ");
      sheet.getRangeByIndex(i + 2, 15).setText(" ");
      sheet.getRangeByIndex(i + 2, 16).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].serviceType);
      sheet.getRangeByIndex(i + 2, 17).setText(OrdersHomeCubit
          .get(context)
          .searchOrdersDate[i].notes);
    }
    //save
    final List<int>bytes = workbook.saveAsStream();
    ///File('searchOrdersDate.xlsx').writeAsBytes(bytes);
    await workbook.save();
    workbook.dispose();
    final String path = (await getApplicationCacheDirectory()).path;
    final String fileName = '$path/searchOrdersDate.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true,);
    OpenFile.open(fileName);
  }
}