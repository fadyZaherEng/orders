// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/components/components.dart';

//checked
class AddSourceScreen extends StatefulWidget {
  const AddSourceScreen({super.key});

  @override
  State<AddSourceScreen> createState() => _AddSourceScreenState();
}

class _AddSourceScreenState extends State<AddSourceScreen> {
  var sourceNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  String cat = "Select".tr();
  String import = "Select".tr();
  double price = 0;
  double total=0;
  var quantityController = TextEditingController();

  var importKey=GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController.addListener(() {
      if(quantityController.text!=""){
       total= int.parse(quantityController.text) * OrdersHomeCubit.get(context).searchCatPrice;
      }
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Add Source".tr()),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Form(
                  key: importKey,
                  child: Column(
                    children:
                    [
                      defaultTextForm(
                          context: context,
                          Controller: sourceNameController,
                          prefixIcon: const Icon(Icons.category),
                          text: "Source Name: ".tr(),
                          validate: (val) {
                            if (val.toString().isEmpty) {
                              return "Please Enter Source Name".tr();
                            }
                            return null;
                          },
                          type: TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (importKey.currentState!.validate()) {
                              OrdersHomeCubit.get(context).addImport(
                                  sourceName: sourceNameController.text,
                                  context: context);
                              sourceNameController.text = "";
                            }
                          },
                          child: Text(
                            "Add Source".tr(),
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
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children:
                      [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                              dropdownColor: Theme.of(context).primaryColor,
                              focusColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              underline: Container(),
                              hint: Text(import),
                              icon: Icon(
                                Icons.medical_services_sharp,
                                color: Theme.of(context).primaryColor,
                              ),
                              elevation: 0,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              items: OrdersHomeCubit.get(context).imports
                                  .map(
                                    (e) => DropdownMenuItem(
                                  value: e.import,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      import = e.import;
                                      OrdersHomeCubit.get(context).getSource(import);
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(e.import),
                                    ),
                                  ),
                                ),
                              ).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  import = val;
                                  setState(() {});
                                  OrdersHomeCubit.get(context).getSource(import);
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultTextForm(
                            context: context,
                            Controller: quantityController,
                            prefixIcon: const Icon(Icons.category),
                            text: "Quantity: ".tr(),
                            validate: (val) {
                              if (val.toString().isEmpty) {
                                return "Please Enter Quantity".tr();
                              }
                              return null;
                            },
                            type: TextInputType.text),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                              dropdownColor: Theme.of(context).primaryColor,
                              focusColor: Theme.of(context).scaffoldBackgroundColor,
                              underline: Container(),
                              hint: Text(cat),
                              icon: Icon(
                                Icons.category,
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
                                  .categories
                                  .map(
                                    (e) => DropdownMenuItem(
                                  value: e.catName,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                      cat = e.catName;
                                      OrdersHomeCubit.get(context)
                                          .getPriceCategory(cat);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(e.catName),
                                    ),
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  cat = val;
                                  OrdersHomeCubit.get(context)
                                      .getPriceCategory(cat);
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            '${"Price".tr()} : ${OrdersHomeCubit.get(context).searchCatPrice.toString()}'),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                            '${"Total Price".tr()} ${total.toString()}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (formKey.currentState!.validate() &&
                                  cat != "Select".tr()) {
                                OrdersHomeCubit.get(context).addSource(
                                    date: DateTime.now().toString(),
                                    sourceName: import,
                                    price:
                                    OrdersHomeCubit.get(context).searchCatPrice,
                                    num: int.parse(quantityController.text),
                                    total: int.parse(quantityController.text) *
                                        OrdersHomeCubit.get(context).searchCatPrice,
                                    context: context);
                                quantityController.text="";
                                total=0;
                              }
                            },
                            child: Text(
                              "Save".tr(),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
