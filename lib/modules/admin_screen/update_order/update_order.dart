// ignore_for_file: avoid_print, must_be_immutable

import 'package:barcode_widget/barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/print_order/order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:screenshot/screenshot.dart';

class UpdateOrdersScreen extends StatefulWidget {
  OrderModel orderModel;

  UpdateOrdersScreen(this.orderModel, {super.key});

  @override
  State<UpdateOrdersScreen> createState() => _UpdateOrdersScreenState();
}

class _UpdateOrdersScreenState extends State<UpdateOrdersScreen> {
  var priceController = TextEditingController();
  var salOfChargingController = TextEditingController();
  dynamic totalPrice;
  var screenShotController = ScreenshotController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); //theme logout lang
    priceController.addListener(() {
      print(priceController.text);
      double p =
          priceController.text != "" ? double.parse(priceController.text) : 0;
      double s = salOfChargingController.text != ""
          ? double.parse(salOfChargingController.text)
          : 0;
      totalPrice = p + s;
      widget.orderModel.price = p;
      widget.orderModel.totalPrice = totalPrice;
      setState(() {});
    });
    salOfChargingController.addListener(() {
      print(priceController.text);
      double p =
          priceController.text != "" ? double.parse(priceController.text) : 0;
      double s = salOfChargingController.text != ""
          ? double.parse(salOfChargingController.text)
          : 0;
      totalPrice = p + s;
      widget.orderModel.salOfCharging = s;
      widget.orderModel.totalPrice = totalPrice;
      setState(() {});
    });
    priceController.text = widget.orderModel.price.toString();
    totalPrice = widget.orderModel.salOfCharging + widget.orderModel.price;
    salOfChargingController.text = widget.orderModel.salOfCharging.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Screenshot(
                  controller: screenShotController,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order Name: ".tr()}${widget.orderModel.orderName}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order Phone: ".tr()}${widget.orderModel.orderPhone}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order City: ".tr()}${widget.orderModel.conservation}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order Area: ".tr()}${widget.orderModel.city}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order Address: ".tr()} ${widget.orderModel.address}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order Barcode: ".tr()}${widget.orderModel.barCode}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Item Name: ".tr()}${widget.orderModel.type}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Employer Name: ".tr()}${widget.orderModel.employerName}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Employer Email: ".tr()}${widget.orderModel.employerEmail}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Employer Phone: ".tr()}${widget.orderModel.employerPhone}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Order Number: ".tr()}${widget.orderModel.number.toString()}'),
                              const SizedBox(
                                height: 10,
                              ),
                              //barcode
                              Center(
                                child: BarcodeWidget(
                                  data: widget.orderModel.barCode,
                                  barcode: Barcode.qrCode(
                                      errorCorrectLevel:
                                          BarcodeQRCorrectionLevel.high),
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${"Date : ".tr()}${DateFormat().format(DateTime.parse(widget.orderModel.date))}'),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: priceController,
                                  prefixIcon: const Icon(Icons.price_check),
                                  text: "Price".tr(),
                                  validate: (val) {
                                    if (val.toString().isEmpty) {
                                      return "Please Enter total price".tr();
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: salOfChargingController,
                                  prefixIcon:
                                      const Icon(Icons.charging_station),
                                  text: "Charging".tr(),
                                  validate: (val) {
                                    if (val.toString().isEmpty) {
                                      return "Please Enter Charging".tr();
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${"Total Price: ".tr()}$totalPrice"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (OrdersHomeCubit.get(context).currentAdmin!.saveOrder)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                OrdersHomeCubit.get(context).updateOrder(
                                    orderName: widget.orderModel.orderName,
                                    conservation:
                                        widget.orderModel.conservation,
                                    city: widget.orderModel.city,
                                    address: widget.orderModel.address,
                                    type: widget.orderModel.type,
                                    barCode: widget.orderModel.barCode,
                                    employerName:
                                        widget.orderModel.employerName,
                                    employerPhone:
                                        widget.orderModel.employerPhone,
                                    employerEmail:
                                        widget.orderModel.employerEmail,
                                    orderPhone: widget.orderModel.orderPhone,
                                    date: widget.orderModel.date,
                                    number: widget.orderModel.number,
                                    price: widget.orderModel.price,
                                    totalPrice: widget.orderModel.totalPrice,
                                    salOfCharging:
                                        widget.orderModel.salOfCharging,
                                    context: context);
                              }
                            },
                            child: Text(
                              "Save".tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      if (OrdersHomeCubit.get(context)
                          .currentAdmin!
                          .removeOrder)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              OrdersHomeCubit.get(context).removeOrders(
                                  docId: widget.orderModel.barCode,
                                  context: context);
                            },
                            child: Text(
                              "Delete".tr(),
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
                //share or print order
                Center(
                  child: TextButton(
                    onPressed: () {
                      screenShotController
                          .capture(delay: const Duration(milliseconds: 200))
                          .then((image) {
                        navigateToWithReturn(context, PrintOrderScreen(image!));
                      }).catchError((onError) {
                        print(onError.toString());
                      });
                    },
                    child: Text(
                      'Print Or Share'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
