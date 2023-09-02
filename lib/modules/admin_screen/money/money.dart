// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class MoneyScreen extends StatefulWidget {
  MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  String menuSelected = "Select";

  var typeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var moneyController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    typeController.addListener(() {
      typeController.text=menuSelected;
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
            title: Text("Add Money".tr()),
            titleSpacing: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                        dropdownColor:
                        SharedHelper.get(key: 'theme') == 'Light Theme'
                            ? Colors.deepPurple
                            : Colors.white,
                        underline: Container(),
                        icon: Icon(
                          Icons.money,
                          color: Theme
                              .of(context)
                              .primaryColor,
                        ),
                        elevation: 0,
                        style:SharedHelper.get(key: 'theme') == 'Light Theme'? Theme
                            .of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                            color: Colors.white):Theme
                            .of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                            color: Theme.of(context).primaryColor),
                        hint: Text(menuSelected,),
                        focusColor: Theme.of(context).primaryColor,
                        items: [
                          DropdownMenuItem(
                            value: "Add the Advertising Money".tr(),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  menuSelected="Add the Advertising Money".tr();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text("Add the Advertising Money".tr()),
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Add the Products Money".tr(),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  menuSelected="Add the Products Money".tr();
                                });
                                },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text("Add the Products Money".tr()),
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Add the Salaries Money".tr(),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  menuSelected="Add the Salaries Money".tr();
                                });
                                },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text("Add the Salaries Money".tr()),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            menuSelected = val;
                            setState(() {
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: typeController,
                      maxLines: 1000,
                      minLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.type_specimen),
                        label: Text("Type".tr()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,
                      validator: (val) {
                        if (val
                            .toString()
                            .isEmpty) {
                          return "Please Enter type".tr();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: moneyController,
                      maxLines: 1000,
                      minLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.money),
                        label: Text("Money".tr()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText2,
                      validator: (val) {
                        if (val
                            .toString()
                            .isEmpty) {
                          return "Please Enter Money".tr();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: MaterialButton(
                        color:SharedHelper.get(key: 'theme') == 'Light Theme'?
                        Colors.deepPurple:Colors.white,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            OrdersHomeCubit.get(context).addMoney(
                                type: typeController.text,
                                value: moneyController.text,
                                context: context);
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                        color:SharedHelper.get(key: 'theme') == 'Light Theme'?Colors.white:Colors.black
                      )
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
