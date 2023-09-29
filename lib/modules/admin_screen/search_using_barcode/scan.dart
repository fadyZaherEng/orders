// ignore_for_file: avoid_print
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/print_order/order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

//checked
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String result = '';

  var priceController = TextEditingController();
  var salOfChargingController = TextEditingController();
  dynamic totalPrice;
  var screenShotController = ScreenshotController();
  var formKey = GlobalKey<FormState>();
  String arabicDate = "";

  var orderNameController = TextEditingController();
  var orderPhoneController = TextEditingController();
  var orderStateController = TextEditingController();
  var orderCityController = TextEditingController();
  var orderAddressController = TextEditingController();
  var orderTypeController = TextEditingController();
  var orderServiceController = TextEditingController();
  var orderNumberController = TextEditingController();

  @override
  void initState() {
    super.initState(); //theme logout lang
    priceController.addListener(() {
      if (OrdersHomeCubit.get(context).searchOrderBarcode != null) {
        print(priceController.text);
        double p =
            priceController.text != "" ? double.parse(priceController.text) : 0;
        double s = salOfChargingController.text != ""
            ? double.parse(salOfChargingController.text)
            : 0;
        totalPrice = p + s;
        OrdersHomeCubit.get(context).searchOrderBarcode!.price = p;
        OrdersHomeCubit.get(context).searchOrderBarcode!.totalPrice =
            totalPrice;
        setState(() {});
      }
    });
    salOfChargingController.addListener(() {
      if (OrdersHomeCubit.get(context).searchOrderBarcode != null) {
        print(priceController.text);
        double p =
            priceController.text != "" ? double.parse(priceController.text) : 0;
        double s = salOfChargingController.text != ""
            ? double.parse(salOfChargingController.text)
            : 0;
        totalPrice = p + s;
        OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging = s;
        OrdersHomeCubit.get(context).searchOrderBarcode!.totalPrice =
            totalPrice;
        setState(() {});
      }
    });
  }
  String res="";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          if(OrdersHomeCubit.get(context).searchOrderBarcode!=null){
            priceController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.price.toString();
            totalPrice =
                OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging +
                    OrdersHomeCubit.get(context).searchOrderBarcode!.price;
            salOfChargingController.text = OrdersHomeCubit.get(context)
                .searchOrderBarcode!
                .salOfCharging
                .toString();
            orderNameController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.orderName;
            orderPhoneController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.orderPhone;
            orderStateController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.conservation;
            orderCityController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.city;
            orderAddressController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.address;
            orderTypeController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.type;
            orderServiceController.text =
                OrdersHomeCubit.get(context).searchOrderBarcode!.serviceType;
            orderNumberController.text =
            OrdersHomeCubit.get(context).searchOrderBarcode!.number != 0
                ? OrdersHomeCubit.get(context).searchOrderBarcode!.number.toString()
                : "";
          }

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          onPressed: () async {
                            res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SimpleBarcodeScannerPage(),
                              ),
                            );
                            OrdersHomeCubit.get(context)
                                .searchOrdersByBarcode(res);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Scanner".tr(),
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Icon(Icons.scanner, size: 30),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: ConditionalBuilder(
                      condition:
                          OrdersHomeCubit.get(context).searchOrderBarcode !=
                              null,
                      builder: (ctx) => SingleChildScrollView(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller: orderNameController,
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                              text: "Order Name: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Order Name: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller: orderPhoneController,
                                              prefixIcon: IconButton(
                                                  onPressed: () {
                                                    launcher.launch(
                                                        "tel://${orderPhoneController.text}");
                                                  },
                                                  icon:
                                                      const Icon(Icons.phone)),
                                              text: "Order Phone: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Order Phone: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.phone),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller: orderStateController,
                                              prefixIcon: const Icon(
                                                  Icons.location_city),
                                              text: "Order City: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Order City: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller: orderCityController,
                                              prefixIcon: const Icon(
                                                  Icons.location_city),
                                              text: "Order Area: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Order Area: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller:
                                                  orderAddressController,
                                              prefixIcon: const Icon(
                                                  Icons.location_city),
                                              text: "Order Address: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Order Address: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller: orderTypeController,
                                              prefixIcon: const Icon(
                                                  Icons.merge_type_outlined),
                                              text: "Item Name: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Item Name: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller:
                                                  orderServiceController,
                                              prefixIcon: const Icon(
                                                  Icons.room_service),
                                              text: "Service Type: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Service Type: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          if(OrdersHomeCubit.get(context).searchOrderBarcode!.number!=0)
                                          defaultTextForm(
                                              context: context,
                                              Controller: orderNumberController,
                                              prefixIcon:
                                                  const Icon(Icons.numbers),
                                              text: "Order Number: ".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Order Number: "
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.text),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          //barcode
                                          Center(
                                            child: BarcodeWidget(
                                              color: SharedHelper.get(
                                                          key: 'theme') ==
                                                      'Light Theme'
                                                  ? Colors.black
                                                  : Colors.white,
                                              data: OrdersHomeCubit.get(context)
                                                  .searchOrderBarcode!
                                                  .barCode,
                                              barcode: Barcode.qrCode(
                                                  errorCorrectLevel:
                                                      BarcodeQRCorrectionLevel
                                                          .high),
                                              width: 200,
                                              height: 150,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text('${"Date: ".tr()}${DateFormat().format(DateTime.parse(OrdersHomeCubit.get(context).searchOrderBarcode!.date))}'),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller: priceController,
                                              prefixIcon:
                                                  const Icon(Icons.price_check),
                                              text: "Price".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter total price"
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.number),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          defaultTextForm(
                                              context: context,
                                              Controller:
                                                  salOfChargingController,
                                              prefixIcon: const Icon(
                                                  Icons.charging_station),
                                              text: "Charging".tr(),
                                              validate: (val) {
                                                if (val.toString().isEmpty) {
                                                  return "Please Enter Charging"
                                                      .tr();
                                                }
                                                return null;
                                              },
                                              type: TextInputType.number),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              "${"Total Price: ".tr()}$totalPrice"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (OrdersHomeCubit.get(context)
                                      .currentAdmin!
                                      .saveOrder)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      //tff all
                                      child: MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            OrdersHomeCubit.get(context).updateOrder(
                                                orderName:
                                                    orderNameController.text,
                                                notes: OrdersHomeCubit.get(context).searchOrderBarcode!.notes,
                                                paper: OrdersHomeCubit.get(context).searchOrderBarcode!.paper,
                                                 statusOrder: OrdersHomeCubit.get(context).searchOrderBarcode!.statusOrder,
                                                serviceType: orderServiceController.text,
                                                conservation:
                                                    orderStateController.text,
                                                city: orderCityController.text,
                                                address:
                                                orderAddressController.text,
                                                type: orderTypeController.text,
                                                barCode: OrdersHomeCubit.get(context).searchOrderBarcode!.barCode,
                                                employerName:
                                                    OrdersHomeCubit.get(context)
                                                        .searchOrderBarcode!
                                                        .employerName,
                                                isSelected:
                                                OrdersHomeCubit.get(context)
                                                    .searchOrderBarcode!
                                                    .isSelected,
                                                employerPhone:
                                                    OrdersHomeCubit.get(context)
                                                        .searchOrderBarcode!
                                                        .employerPhone,
                                                employerEmail:
                                                    OrdersHomeCubit.get(context)
                                                        .searchOrderBarcode!
                                                        .employerEmail,
                                                editEmail: OrdersHomeCubit.get(context).searchOrderBarcode!.editEmail,
                                                orderPhone:
                                                    orderPhoneController.text,
                                                date: OrdersHomeCubit.get(context)
                                                    .searchOrderBarcode!
                                                    .date,
                                                number: int.parse(orderNumberController.text),
                                                price: OrdersHomeCubit.get(context).searchOrderBarcode!.price,
                                                totalPrice: OrdersHomeCubit.get(context).searchOrderBarcode!.totalPrice,
                                                salOfCharging: OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging,
                                                context: context
                                            );
                                           Future.delayed(Duration(milliseconds: 100))
                                            .then((value) {
                                             OrdersHomeCubit.get(context)
                                                 .searchOrdersByBarcode(res);
                                           });
                                          }
                                        },
                                        child: Text(
                                          "Save".tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
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
                                          OrdersHomeCubit.get(context)
                                              .removeOrders(
                                                  docId: OrdersHomeCubit.get(
                                                          context)
                                                      .searchOrderBarcode!
                                                      .barCode,
                                                  context: context);
                                        },
                                        child: Text(
                                          "Delete".tr(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Theme.of(context)
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
                                  screenShotController
                                      .capture(
                                          delay:
                                              const Duration(milliseconds: 200))
                                      .then((image) {
                                    navigateToWithReturn(
                                        context, PrintOrderScreen(image!));
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
                      fallback: (ctx) => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}
