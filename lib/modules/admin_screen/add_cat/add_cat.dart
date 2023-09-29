// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';
//checked
class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  var priceController = TextEditingController();
  var catNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();


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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: catNameController,
                        prefixIcon: const Icon(Icons.category),
                        text: "Category Name: ".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            OrdersHomeCubit.get(context).addCategories(
                                date: DateTime.now().toString(),
                                catName: catNameController.text,
                                price: double.parse(priceController.text),
                                context: context);
                            priceController.text="";
                            catNameController.text="";
                          }
                        },
                        child: Text(
                          "Add Category".tr(),
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
            ),
          ),
        );
      },
    );
  }
}
