// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  var priceController = TextEditingController();
  var salOfChargingController = TextEditingController();
  var catNameController = TextEditingController();
  var catAmountController = TextEditingController();
  var notesController = TextEditingController();
  double totalPrice = 0;
  double p = 0;
  double s = 0;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    priceController.addListener(() {
      p = priceController.text != "" ? double.parse(priceController.text) : 0;
      s = salOfChargingController.text != "" ? double.parse(
          salOfChargingController.text) : 0;
      totalPrice = p + s;
      setState(() {});
    });
    salOfChargingController.addListener(() {
      print(priceController.text);
      p = priceController.text != "" ? double.parse(priceController.text) : 0;
      s = salOfChargingController.text != "" ? double.parse(
          salOfChargingController.text) : 0;
      totalPrice = p + s;
      setState(() {});
    });
    totalPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Add Category".tr()),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30,),
                  defaultTextForm(
                      context: context,
                      Controller: catNameController,
                      prefixIcon: const Icon(Icons.category),
                      text: "Category Name: ".tr(),
                      validate: (val) {
                        if (val
                            .toString()
                            .isEmpty) {
                          return "Please Enter Category Name".tr();
                        }
                        return null;
                      },
                      type: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultTextForm(
                      context: context,
                      Controller: catAmountController,
                      prefixIcon: const Icon(Icons.numbers),
                      text: "Amount".tr(),
                      validate: (val) {
                        if (val
                            .toString()
                            .isEmpty) {
                          return "Please Enter Amount".tr();
                        }
                        return null;
                      },
                      type: TextInputType.number),
                  const SizedBox(
                    height: 20,
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
                    height: 20,
                  ),
                  defaultTextForm(
                      context: context,
                      Controller: salOfChargingController,
                      prefixIcon: const Icon(Icons.charging_station),
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
                    height: 20,
                  ),
                  defaultTextForm(
                      context: context,
                      Controller: notesController,
                      prefixIcon: const Icon(Icons.notes),
                      text: "Notes".tr(),
                      validate: (val) {
                        return null;
                      },
                      type: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("${"Total Price:".tr()} $totalPrice"),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          OrdersHomeCubit.get(context).addCategories(
                              date: DateTime.now().toString(),
                              catName: catNameController.text,
                              salOfCharging: s,
                              notes: notesController.text,
                              totalPrice: totalPrice,
                              price: p,
                              amount: catAmountController.text == "" ? 0 : int
                                  .parse(catAmountController.text),
                              context: context);
                        }
                      },
                      child: Text(
                        "Add Category".tr(),
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
          ),
        );
      },
    );
  }
}
