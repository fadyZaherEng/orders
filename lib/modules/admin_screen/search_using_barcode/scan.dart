// ignore_for_file: avoid_print

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
  String arabicDate="";

  @override
  void initState() {
    super.initState();
   initMethod();
  }
 void initMethod(){
    if (SharedHelper.get(key: 'lang') == 'arabic') {
      if(OrdersHomeCubit.get(context).searchOrderBarcode!=null){
        getArabic(OrdersHomeCubit.get(context).searchOrderBarcode!.date);
      }
    }
    priceController.addListener(() {
      if(OrdersHomeCubit.get(context).searchOrderBarcode!=null){
        print(priceController.text);
        double p = priceController.text != "" ? double.parse(priceController.text) : 0;
        double s = salOfChargingController.text != "" ? double.parse(salOfChargingController.text) : 0;
        totalPrice = p + s;
        OrdersHomeCubit.get(context).searchOrderBarcode!.price = p;
        OrdersHomeCubit.get(context).searchOrderBarcode!.totalPrice = totalPrice;
      }
    });
    salOfChargingController.addListener(() {
      if(OrdersHomeCubit.get(context).searchOrderBarcode!=null){
        print(priceController.text);
        double p = priceController.text != "" ? double.parse(priceController.text) : 0;
        double s = salOfChargingController.text != "" ? double.parse(salOfChargingController.text) : 0;
        totalPrice = p + s;
        OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging = s;
        OrdersHomeCubit.get(context).searchOrderBarcode!.totalPrice = totalPrice;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        if(OrdersHomeCubit.get(context).searchOrderBarcode!=null){
          priceController.text =  OrdersHomeCubit.get(context).searchOrderBarcode!.price.toString();
          salOfChargingController.text =  OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging.toString();
          totalPrice = OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging +  OrdersHomeCubit.get(context).searchOrderBarcode!.price;
        }
        return Scaffold(
          body:SafeArea(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        onPressed: () async {
                          String res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SimpleBarcodeScannerPage(),
                            ),
                          );
                          OrdersHomeCubit.get(context).searchOrdersByBarcode(res);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Scanner".tr(),style:Theme.of(context).textTheme.titleLarge),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(Icons.scanner,size:30),
                            ],
                          ),
                        )),
                  ),
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: OrdersHomeCubit.get(context).searchOrderBarcode != null,
                    builder: (ctx) => SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Screenshot(
                                controller: screenShotController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${"Order Name: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.orderName}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        '${"Order Phone: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.orderPhone}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        '${"Order City: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.conservation}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        '${"Order Area: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.city}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        '${"Order Address: ".tr()} ${OrdersHomeCubit.get(context).searchOrderBarcode!.address}'),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                        '${"Item Name: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.type}'),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text('${"Service Type: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.serviceType}'),
                                     const SizedBox(
                                      height: 5,
                                    ),
                                    Text(OrdersHomeCubit.get(context).searchOrderBarcode!=null&&
                                        OrdersHomeCubit.get(context).searchOrderBarcode!.number!=0?
                                        '${"Order Number: ".tr()}${OrdersHomeCubit.get(context).searchOrderBarcode!.number.toString()}'
                                        :""
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    //barcode
                                    Center(
                                      child: BarcodeWidget(
                                        data: OrdersHomeCubit.get(context).searchOrderBarcode!.barCode,
                                        barcode: Barcode.qrCode(
                                            errorCorrectLevel:
                                            BarcodeQRCorrectionLevel.high),
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                   Text(
                                  '${"Date: ".tr()}${DateTime.parse(OrdersHomeCubit.get(context).searchOrderBarcode!.date)}'),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    defaultTextForm(
                                        context: context,
                                        Controller: priceController,
                                        prefixIcon: const Icon(Icons.price_check),
                                        text: "Price".tr(),
                                        validate: (val) {
                                          if (val.toString().isEmpty) {
                                            return "Please Enter  price".tr();
                                          }
                                          return null;
                                        },
                                        onChanged: (String val){
                                          setState(() {

                                          });
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
                                          if (val.toString().isEmpty) {
                                            return "Please Enter Charging".tr();
                                          }
                                          return null;
                                        },
                                        onChanged: (String value){
                                          setState(() {

                                          });
                                        },
                                        type: TextInputType.number),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("${"Total Price: ".tr()}$totalPrice"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                         setState(() {

                                         });
                                          Future.delayed(const Duration(seconds: 1))
                                             .then((value) {
                                           if (formKey.currentState!.validate()) {
                                             OrdersHomeCubit.get(context).updateOrder(
                                                 orderName: OrdersHomeCubit.get(context).searchOrderBarcode!.orderName,
                                                 conservation: OrdersHomeCubit.get(context).searchOrderBarcode!.conservation,
                                                 city: OrdersHomeCubit.get(context).searchOrderBarcode!.city,
                                                 charging: OrdersHomeCubit.get(context).searchOrderBarcode!.charging,
                                                 address: OrdersHomeCubit.get(context).searchOrderBarcode!.address,
                                                 type: OrdersHomeCubit.get(context).searchOrderBarcode!.type,
                                                 confirm: OrdersHomeCubit.get(context).searchOrderBarcode!.confirm,
                                                 barCode: OrdersHomeCubit.get(context).searchOrderBarcode!.barCode,
                                                 employerName:
                                                 OrdersHomeCubit.get(context).searchOrderBarcode!.employerName,
                                                 employerPhone:
                                                 OrdersHomeCubit.get(context).searchOrderBarcode!.employerPhone,
                                                 employerEmail:
                                                 OrdersHomeCubit.get(context).searchOrderBarcode!.employerEmail,
                                                 orderPhone: OrdersHomeCubit.get(context).searchOrderBarcode!.orderPhone,
                                                 date: OrdersHomeCubit.get(context).searchOrderBarcode!.date,
                                                 number: OrdersHomeCubit.get(context).searchOrderBarcode!.number,
                                                 price: OrdersHomeCubit.get(context).searchOrderBarcode!.price,
                                                 totalPrice: OrdersHomeCubit.get(context).searchOrderBarcode!.totalPrice,
                                                 salOfCharging:
                                                 OrdersHomeCubit.get(context).searchOrderBarcode!.salOfCharging,
                                                 context: context,
                                                 waiting:OrdersHomeCubit.get(context).searchOrderBarcode!.waiting,
                                                 notes: OrdersHomeCubit.get(context).searchOrderBarcode!.notes,
                                                 serviceType:OrdersHomeCubit.get(context).searchOrderBarcode!.serviceType
                                             );
                                           }
                                         });
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
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                        setState(() {
                                          Future.delayed(const Duration(seconds: 1))
                                              .then((value) {
                                            OrdersHomeCubit.get(context).removeOrders(
                                                docId: OrdersHomeCubit.get(context).searchOrderBarcode!.barCode,
                                                context: context);
                                          });
                                        });
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
      }
    );
  }
  void getArabic(String date) async {
    await initializeDateFormatting('ar_SA', '');
    var formatter = DateFormat('yyyy-MM-dd hh:mm:ss', 'ar_SA');
    print(formatter.locale);
    String formatted = formatter.format(DateTime.parse(date));
    arabicDate = formatted;
    setState(() {

    });
  }

}
