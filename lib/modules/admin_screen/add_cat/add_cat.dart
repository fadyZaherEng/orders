// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

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
  double totalPrice=0;
  double p=0;
  double s=0;

  var formKey=GlobalKey<FormState>();
  String lang=SharedHelper.get(key: "lang");
  @override
  void initState() {
    super.initState();
    priceController.addListener(() {
       p = priceController.text != "" ? double.parse(priceController.text) : 0;
       s = salOfChargingController.text != "" ? double.parse(salOfChargingController.text) : 0;
      totalPrice = p + s;
      setState(() {});
    });
    salOfChargingController.addListener(() {
      print(priceController.text);
      p = priceController.text != "" ? double.parse(priceController.text) : 0;
      s = salOfChargingController.text != "" ? double.parse(salOfChargingController.text) : 0;
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
        lang=SharedHelper.get(key: "lang");
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title:  Text(lang=='arabic'?arabic["Add Category"]:english["Add Category"]),
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
                      text:lang=='arabic'?arabic["Category Name: "]:english["Category Name: "],
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return lang=='arabic'?arabic["Please Enter Category Name"]:english["Please Enter Category Name"];
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
                      text:lang=='arabic'?arabic["Amount"]:english["Amount"],
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return lang=='arabic'?arabic['Please Enter Amount']:english['Please Enter Amount'] ;
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
                      text:lang=='arabic'?arabic["Price"]:english["Price"],
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return lang=='arabic'?arabic["Please Enter total price"]:english["Please Enter total price"] ;
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
                      text:lang=='arabic'?arabic["Charging"]:english["Charging"] ,
                      validate: (val) {
                        if (val.toString().isEmpty) {
                          return lang=='arabic'?arabic["Please Enter Charging"]:english["Please Enter Charging"] ;
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
                      text:lang=='arabic'?arabic["Notes"]:english["Notes"],
                      validate: (val) {
                        return null;
                      },
                      type: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("${lang=='arabic'?arabic["Total Price:"]:english["Total Price:"]} $totalPrice"),
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
                       if(formKey.currentState!.validate()){
                         OrdersHomeCubit.get(context).addCategories(
                             date: DateTime.now().toString(),
                             catName: catNameController.text,
                             salOfCharging: s,
                             notes: notesController.text,
                             totalPrice: totalPrice,
                             price: p,
                             amount: catAmountController.text==""?0:int.parse(catAmountController.text),
                             context: context);
                       }
                      },
                      child: Text(
                        lang=='arabic'?arabic["Save"]:english["Save"],
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
