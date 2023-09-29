// ignore_for_file: avoid_print, must_be_immutable
import 'package:barcode_widget/barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/order_model.dart';
import 'package:orders/modules/admin_screen/print_order/order.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateOrdersScreen extends StatefulWidget {
  OrderModel orderModel;
  String editEmail;

  UpdateOrdersScreen(
      {super.key, required this.orderModel, required this.editEmail});

  @override
  State<UpdateOrdersScreen> createState() => _UpdateOrdersScreenState();
}

class _UpdateOrdersScreenState extends State<UpdateOrdersScreen> {
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
  var orderNumberController = TextEditingController();
  var city = "Select City".tr();
  String stateValue = "Select State".tr();
  List<String> serviceType = ['تسليم وتحصيل', 'جلب مرتجعات', 'استبدال'];

  @override
  void initState() {
    super.initState(); //theme logout lang
    if (SharedHelper.get(key: 'lang') == 'arabic') {
      getArabic(widget.orderModel.date);
    }
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
    orderNameController.text = widget.orderModel.orderName;
    orderPhoneController.text = widget.orderModel.orderPhone;
    orderStateController.text = widget.orderModel.conservation;
    orderCityController.text = widget.orderModel.city;
    orderAddressController.text = widget.orderModel.address;
    orderTypeController.text = widget.orderModel.type;
    orderNumberController.text = widget.orderModel.number != 0 ?
    widget.orderModel.number.toString() : "";
    city=widget.orderModel.city;
    stateValue=widget.orderModel.conservation;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        if (SharedHelper.get(key: 'lang') == 'arabic') {
          getArabic(widget.orderModel.date);
        }
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
                                height: 5,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: orderNameController,
                                  prefixIcon: const Icon(Icons.person),
                                  text: "Order Name: ".tr(),
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return "Please Enter Order Name: ".tr();
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
                                  prefixIcon: const Icon(Icons.phone),
                                  text: "Order Phone: ".tr(),
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return "Please Enter Order Phone: ".tr();
                                    }
                                    return null;
                                  },
                                  type: TextInputType.phone),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton(
                                        dropdownColor: Theme.of(context).primaryColor,
                                        focusColor:
                                        Theme.of(context).scaffoldBackgroundColor,
                                        underline: Container(),
                                        hint: Text(stateValue),
                                        icon: Icon(
                                          Icons.baby_changing_station,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        elevation: 0,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        items: OrdersHomeCubit.get(context)
                                            .states
                                            .map(
                                              (e) => DropdownMenuItem(
                                            value: e.state,
                                            child: InkWell(
                                              onTap: () {
                                               // city = "Select City".tr();
                                                Navigator.pop(context);
                                                stateValue = e.state;
                                                OrdersHomeCubit.get(context)
                                                    .getCites(stateValue);
                                                setState(() {});
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(e.state),
                                              ),
                                            ),
                                          ),
                                        )
                                            .toList(),
                                        onChanged: (val) {
                                          if (val != null) {
                                            stateValue = val;
                                            OrdersHomeCubit.get(context)
                                                .getCites(stateValue);
                                            setState(() {});
                                          }
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButton(
                                        dropdownColor: Theme.of(context).primaryColor,
                                        focusColor:
                                        Theme.of(context).scaffoldBackgroundColor,
                                        underline: Container(),
                                        hint: Text(city),
                                        icon: Icon(
                                          Icons.location_city,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        elevation: 0,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        items: OrdersHomeCubit.get(context)
                                            .cities
                                            .map(
                                              (e) => DropdownMenuItem(
                                            value: e,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                city = e;
                                                setState(() {});
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
                                          if (val != null) {
                                            city = val;
                                            setState(() {});
                                          }
                                        }),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: orderAddressController,
                                  prefixIcon: const Icon(Icons.location_city),
                                  text: "Order Address: ".tr(),
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
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
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return "Please Enter Item Name: ".tr();
                                    }
                                    return null;
                                  },
                                  type: TextInputType.text),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                    dropdownColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).scaffoldBackgroundColor,
                                    underline: Container(),
                                    hint: Text(
                                      widget.orderModel.serviceType,
                                    ),
                                    elevation: 0,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    items: serviceType.map(
                                          (e) => DropdownMenuItem(
                                        value: e,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            widget.orderModel.serviceType= e;
                                            setState(() {});
                                          },
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        widget.orderModel.serviceType= val;
                                        setState(() {});
                                      }
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton(
                                    key: Key(widget.orderModel.barCode),
                                    dropdownColor: Theme.of(context).primaryColor,
                                    focusColor: Theme.of(context).scaffoldBackgroundColor,
                                    underline: Container(),
                                    hint: Text(
                                      widget.orderModel.statusOrder,
                                      key: Key(widget.orderModel.barCode),
                                    ),
                                    elevation: 0,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    items: OrdersHomeCubit.get(context).status
                                        .map(
                                          (e) => DropdownMenuItem(
                                        value: e,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            widget.orderModel.statusOrder= e;
                                            setState(() {});
                                          },
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        widget.orderModel.statusOrder= val;
                                        setState(() {});
                                      }
                                    }),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if(widget.orderModel.number != 0)
                                defaultTextForm(
                                    context: context,
                                    Controller: orderNumberController,
                                    prefixIcon: const Icon(Icons.numbers),
                                    text: "Order Number: ".tr(),
                                    validate: (val) {
                                      if (val
                                          .toString()
                                          .isEmpty) {
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
                                  color: SharedHelper.get(key: 'theme') ==
                                      'Light Theme' ? Colors.black : Colors
                                      .white,
                                  data: widget.orderModel.barCode,
                                  barcode: Barcode.qrCode(
                                      errorCorrectLevel:
                                      BarcodeQRCorrectionLevel.high),
                                  width: 200,
                                  height: 150,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  SharedHelper.get(key: 'lang') == 'arabic' ?
                                  '${"Date: ".tr()}$arabicDate' :
                                  '${"Date: ".tr()}${DateFormat().format(
                                      DateTime.parse(widget.orderModel.date))}'
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: priceController,
                                  prefixIcon: const Icon(Icons.price_check),
                                  text: "Price".tr(),
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return "Please Enter total price".tr();
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                              const SizedBox(
                                height: 5,
                              ),
                              defaultTextForm(
                                  context: context,
                                  Controller: salOfChargingController,
                                  prefixIcon:
                                  const Icon(Icons.charging_station),
                                  text: "Charging".tr(),
                                  validate: (val) {
                                    if (val
                                        .toString()
                                        .isEmpty) {
                                      return "Please Enter Charging".tr();
                                    }
                                    return null;
                                  },
                                  type: TextInputType.number),
                              const SizedBox(
                                height: 5,
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
                      if (OrdersHomeCubit
                          .get(context)
                          .currentAdmin != null && OrdersHomeCubit
                          .get(context)
                          .currentAdmin!
                          .saveOrder)
                        Padding(
                          padding: const EdgeInsets.all(4.0), //tff all
                          child: MaterialButton(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                OrdersHomeCubit.get(context).updateOrder(
                                    orderName: orderNameController.text,
                                    notes: widget.orderModel.notes,
                                    statusOrder: widget.orderModel.statusOrder,
                                    isSelected: widget.orderModel.isSelected,
                                    editEmail: widget.editEmail,
                                    serviceType: widget.orderModel.serviceType,
                                    paper: widget.orderModel.paper,
                                    conservation: orderStateController.text,
                                    city: orderCityController.text,
                                    address: orderAddressController.text,
                                    type: orderTypeController.text,
                                    barCode: widget.orderModel.barCode,
                                    employerName: widget.orderModel
                                        .employerName,
                                    employerPhone:
                                    widget.orderModel.employerPhone,
                                    employerEmail:
                                    widget.orderModel.employerEmail,
                                    orderPhone: orderPhoneController.text,
                                    date: widget.orderModel.date,
                                    number: widget.orderModel.number != 0 ?
                                     int.parse(
                                        orderNumberController.text):0,
                                    price: widget.orderModel.price,
                                    totalPrice: widget.orderModel.totalPrice,
                                    salOfCharging: widget.orderModel
                                        .salOfCharging,
                                    context: context);
                              }
                            },
                            child: Text(
                              "Save".tr(),
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
                      // if (OrdersHomeCubit
                      //     .get(context)
                      //     .currentAdmin == null)
                      //   Padding(
                      //     padding: const EdgeInsets.all(4.0), //tff all
                      //     child: MaterialButton(
                      //       color: Theme
                      //           .of(context)
                      //           .primaryColor,
                      //       onPressed: () {
                      //         if (formKey.currentState!.validate()) {
                      //           OrdersHomeCubit.get(context).updateOrder(
                      //               orderName: orderNameController.text,
                      //               notes: widget.orderModel.notes,
                      //               statusOrder: widget.orderModel.statusOrder,
                      //               isSelected: widget.orderModel.isSelected,
                      //               editEmail: widget.editEmail,
                      //               serviceType: widget.orderModel.serviceType,
                      //               conservation: orderStateController.text,
                      //               city: orderCityController.text,
                      //               address: orderAddressController.text,
                      //               type: orderTypeController.text,
                      //               barCode: widget.orderModel.barCode,
                      //               employerName: widget.orderModel
                      //                   .employerName,
                      //               employerPhone:
                      //               widget.orderModel.employerPhone,
                      //               employerEmail:
                      //               widget.orderModel.employerEmail,
                      //               orderPhone: orderPhoneController.text,
                      //               date: widget.orderModel.date,
                      //               number:orderNumberController.text != "" ? int.parse(orderNumberController.text) : 0,
                      //               price: widget.orderModel.price,
                      //               totalPrice: widget.orderModel.totalPrice,
                      //               salOfCharging: widget.orderModel.salOfCharging,
                      //               context: context);
                      //         }
                      //       },
                      //       child: Text(
                      //         "Save".tr(),
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.normal,
                      //           fontSize: 14,
                      //           color:
                      //           Theme
                      //               .of(context)
                      //               .scaffoldBackgroundColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      if (OrdersHomeCubit
                          .get(context)
                          .currentAdmin != null && OrdersHomeCubit
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
                              OrdersHomeCubit.get(context).removeOrders(
                                  docId: widget.orderModel.barCode,
                                  context: context);
                            },
                            child: Text(
                              "Delete".tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ),
                      // if (OrdersHomeCubit
                      //     .get(context)
                      //     .currentAdmin == null)
                      //   Padding(
                      //     padding: const EdgeInsets.all(4.0),
                      //     child: MaterialButton(
                      //       color: Theme
                      //           .of(context)
                      //           .primaryColor,
                      //       onPressed: () {
                      //         OrdersHomeCubit.get(context).removeOrders(
                      //             docId: widget.orderModel.barCode,
                      //             context: context);
                      //       },
                      //       child: Text(
                      //         "Delete".tr(),
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.normal,
                      //           fontSize: 14,
                      //           color: Theme
                      //               .of(context)
                      //               .scaffoldBackgroundColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                //share or print order
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (SharedHelper.get(key: 'theme') == 'Dark Theme') {
                            OrdersHomeCubit.get(context).modeChange();
                            SharedHelper.save(value: 'Dark Theme', key: 'd');
                          }
                          screenShotController
                              .capture(delay: const Duration(seconds: 1))
                              .then((image) {
                            navigateToWithReturn(
                                context, PrintOrderScreen(image!));
                          }).catchError((onError) {
                            print(onError.toString());
                          });
                        },
                        child: Text(
                          'Print Or Share'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                        ),
                      ),
                      IconButton(onPressed: () {
                        makingPhoneCall(orderPhoneController.text);
                      }, icon: const Icon(Icons.phone)),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  void getArabic(String date) async {
    await initializeDateFormatting('ar_SA', '');
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss', 'ar_SA');
    print(formatter.locale);
    String formatted = formatter.format(DateTime.parse(date));
    arabicDate = formatted;
    setState(() {});
  }

}
