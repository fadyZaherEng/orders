// ignore_for_file: avoid_print, must_be_immutable

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/print_order/order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
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
  String lang = SharedHelper.get(key: 'lang');

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
        lang = SharedHelper.get(key: 'lang');
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
                              Text('${lang == 'arabic'
                                  ? arabic["Order Name: "]
                                  : english["Order Name: "]}${widget.orderModel
                                  .orderName}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Order Phone: "]
                                  : english["Order Phone: "]}${widget.orderModel
                                  .orderPhone}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Order City: "]
                                  : english["Order City: "]}${widget.orderModel
                                  .conservation}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Order Area: "]
                                  : english["Order Area: "]}${widget.orderModel
                                  .city}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Order Address: "]
                                  : english["Order Address: "]} ${widget.orderModel
                                  .address}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Order Barcode: "]
                                  : english["Order Barcode: "]}${widget.orderModel
                                  .barCode}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Item Name: "]
                                  : english["Item Name: "]}${widget.orderModel
                                  .type}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Employer Name: "]
                                  : english["Employer Name: "]}${widget.orderModel
                                  .employerName}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Employer Email: "]
                                  : english["Employer Email: "]}${widget.orderModel
                                  .employerEmail}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('${lang == 'arabic'
                                  ? arabic["Employer Phone: "]
                                  : english["Employer Phone: "]}${widget.orderModel
                                  .employerPhone}'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                  '${lang == 'arabic'
                                      ? arabic["Order Number: "]
                                      : english["Order Number: "]}${widget.orderModel
                                      .number.toString()}'),
                              const SizedBox(
                                height: 10,
                              ),
                              //barcode
                              Center(
                                child: BarcodeWidget(
                                  data: widget.orderModel.orderId,
                                  barcode: Barcode.qrCode(
                                      errorCorrectLevel: BarcodeQRCorrectionLevel.high),
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: priceController,
                                  prefixIcon: const Icon(Icons.price_check),
                                  text: lang == 'arabic'
                                      ? arabic["Price"]
                                      : english["Price"],
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return lang == 'arabic'
                                          ? arabic["Please Enter total price"]
                                          : english["Please Enter total price"];
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
                                  prefixIcon: const Icon(Icons.charging_station),
                                  text: lang == 'arabic'
                                      ? arabic["Charging"]
                                      : english["Charging"],
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return lang == 'arabic'
                                          ? arabic["Please Enter Charging"]
                                          : english["Please Enter Charging"];
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${lang == 'arabic'
                                  ? arabic["Total Price: "]
                                  : english["Total Price: "]}$totalPrice"),


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
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin!
                          .saveOrder)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                OrdersHomeCubit.get(context)
                                    .updateOrder(
                                    orderId: widget.orderModel.orderId,
                                    orderName: widget.orderModel
                                        .orderName,
                                    conservation: widget.orderModel
                                        .conservation,
                                    city: widget.orderModel.city,
                                    address: widget.orderModel.address,
                                    type: widget.orderModel.type,
                                    barCode: widget.orderModel.barCode,
                                    employerName: widget.orderModel
                                        .employerName,
                                    employerPhone: widget.orderModel
                                        .employerPhone,
                                    employerEmail: widget.orderModel
                                        .employerEmail,
                                    orderPhone: widget.orderModel
                                        .orderPhone,
                                    date: widget.orderModel.date,
                                    number: widget.orderModel.number,
                                    price: widget.orderModel.price,
                                    totalPrice: widget.orderModel
                                        .totalPrice,
                                    salOfCharging: widget.orderModel
                                        .salOfCharging,
                                    context: context);
                                print(widget.orderModel.orderId);
                              }
                            },
                            child: Text(
                              lang == 'arabic'
                                  ? arabic["Save"]
                                  : english["Save"],
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color:
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin!
                          .removeOrder)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MaterialButton(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            onPressed: () {
                              print(widget.orderModel.orderId);
                              OrdersHomeCubit.get(context).removeOrders(
                                  docId: widget.orderModel.orderId,
                                  context: context);
                            },
                            child: Text(
                              lang == 'arabic'
                                  ? arabic["Delete"]
                                  : english["Delete"],
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color:
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
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
                      screenShotController.capture(
                          delay: const Duration(milliseconds: 200))
                          .then((image) {
                        navigateToWithReturn(
                            context, PrintOrderScreen(image!));
                      }).catchError((onError) {
                        print(onError.toString());
                      });
                    },
                    child: Text(SharedHelper.get(key: 'lang') == 'arabic'
                        ? arabic['Print Or Share']
                        : english['Print Or Share'],),
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
