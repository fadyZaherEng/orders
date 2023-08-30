// ignore_for_file: avoid_print

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/search_using_barcode/scan.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int minutes = 0;

  @override
  void initState() {
    super.initState();
    OrdersHomeCubit.get(context).getUserProfile();
    priceController.addListener(() {
      double p =
      priceController.text != "" ? double.parse(priceController.text) : 0;
      totalPrice = p + salOfCharging;
      setState(() {});
    });

    print(SharedHelper.get(key: "min"));
    Timer.periodic(const Duration(hours: 24), (timer) {
      //update time all 24 in firestore
      //make it 0
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      //get shared difference
      if (SharedHelper.get(key: "min") != null) {
        Duration diff = DateTime.now()
            .difference(DateTime.parse(SharedHelper.get(key: "min")));
        Duration saveDiff = Duration(
            hours: diff.inHours,
            minutes: diff.inMinutes,
            seconds: diff.inSeconds);
        //save diff in shared
        if (SharedHelper.get(key: 'duration') == null) {
          SharedHelper.save(value: saveDiff.toString(), key: 'duration');
        } else {
          // compare with diff then update diff with large
          //DateTime dt=DateTime.parse(SharedHelper.get(key: 'duration'));
          // Duration d=Duration(hours: dt.hour,minutes: dt.minute,seconds: dt.second);
          int res = saveDiff
              .toString()
              .compareTo(SharedHelper.get(key: 'duration').toString());
          if (!res.isNegative) {
            SharedHelper.save(value: saveDiff.toString(), key: 'duration');
          }
        }
        //update shared by large diff
        showToast(
            message: SharedHelper.get(key: 'duration').toString(),
            state: ToastState.SUCCESS);
        print(SharedHelper.get(key: 'duration').toString());
      }
    } else {
      SharedHelper.save(value: DateTime.now().toString(), key: "min");
      print("closed");
      showToast(message: 'Closed', state: ToastState.SUCCESS);
    }
  }

  var cityController = TextEditingController();
  var nameClientController = TextEditingController();
  var addressClientController = TextEditingController();
  var quantityController = TextEditingController();
  var catsClientController = TextEditingController();
  var priceController = TextEditingController();
  var phoneClientController = TextEditingController();
  String stateValue = "";
  String catSelected = "Select";
  int quantityForMultiCats = 0;
  double salOfCharging = 0;
  double totalPrice = 0;
  String radioSelected = "";
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Add Order".tr()),
            ),
            centerTitle: true,
            titleSpacing: 0,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                    dropdownColor: Theme
                        .of(context)
                        .primaryColor,
                    focusColor: Theme
                        .of(context)
                        .scaffoldBackgroundColor,
                    underline: Container(),
                    icon: Icon(
                      Icons.reorder,
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                    elevation: 0,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(
                        color: Theme
                            .of(context)
                            .scaffoldBackgroundColor),
                    items: [
                      DropdownMenuItem(
                        value: "today",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                              context,
                              const ScannerScreen(),
                            );
                          },
                          child: Text('Search By Barcode'.tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "theme",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).modeChange();
                          },
                          child: Text("Change Theme".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "lang",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).langChange(context);
                          },
                          child: Text("Change lang".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "logout",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).logOut();
                            SharedHelper.remove(key: 'uid');
                            navigateToWithoutReturn(context, LogInScreen());
                          },
                          child: Text("Log Out".tr()),
                        ),
                      ),
                    ],
                    onChanged: (idx) {},
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultTextForm(
                        context: context,
                        Controller: nameClientController,
                        prefixIcon: const Icon(Icons.location_city),
                        text: "Client name".tr(),
                        validate: (val) {
                          if (val
                              .toString()
                              .isEmpty) {
                            return "Please Enter Client Name".tr();
                          }
                          return null;
                        },
                        type: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: phoneClientController,
                        prefixIcon: const Icon(Icons.phone),
                        text: "Client Phone".tr(),
                        validate: (val) {
                          if (val
                              .toString()
                              .isEmpty) {
                            return "Please Enter Client Phone".tr();
                          }
                          return null;
                        },
                        type: TextInputType.phone),
                    const SizedBox(
                      height: 10,
                    ),
                    CSCPicker(
                      dropdownDialogRadius: 10.0,
                      searchBarRadius: 10.0,
                      dropdownDecoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor
                      ),
                      onCountryChanged: (value) {},
                      onStateChanged: (value) {
                        if (value != null) {
                          stateValue = value;
                          (stateValue.toLowerCase().contains("cairo") ||
                              stateValue.toLowerCase().contains("giza"))
                              ? salOfCharging = 30
                              : salOfCharging = 50;
                        }
                        setState(() {
                          double p =
                          priceController.text != "" ? double.parse(
                              priceController.text) : 0;
                          totalPrice = p + salOfCharging;
                        });
                      },
                      onCityChanged: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: cityController,
                        prefixIcon: const Icon(Icons.location_city),
                        text: "City".tr(),
                        validate: (val) {
                          if (val
                              .toString()
                              .isEmpty) {
                            return "Please Enter The City".tr();
                          }
                          return null;
                        },
                        type: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: addressClientController,
                        prefixIcon: const Icon(Icons.location_city),
                        text: "Client Address".tr(),
                        validate: (val) {
                          if (val
                              .toString()
                              .isEmpty) {
                            return "Please Enter Client Address".tr();
                          }
                          return null;
                        },
                        type: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text("Multi Category".tr()),
                            value: "Multi Category".tr(),
                            groupValue: radioSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val != null) {
                                  radioSelected = val.toString();
                                  print(radioSelected);
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text("Single Category".tr()),
                            value: "Single Category".tr(),
                            groupValue: radioSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val != null) {
                                  radioSelected = val.toString();
                                  print(radioSelected);
                                }
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10,),
                    if(radioSelected == "Single Category".tr())
                      Column(
                        children: [
                          DropdownButton(
                              focusColor: Theme
                                  .of(context)
                                  .primaryColor,
                              borderRadius: BorderRadius.circular(10),
                              hint: Text(catSelected),
                              items: OrdersHomeCubit
                                  .get(context)
                                  .categories
                                  .map((cat) =>
                                  DropdownMenuItem(child: Text(cat.catName),
                                    value: cat.catName,))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  catSelected = val;
                                }
                              }),
                          const SizedBox(height: 10,),
                          defaultTextForm(context: context,
                              Controller: quantityController,
                              prefixIcon: const Icon(
                                  Icons.production_quantity_limits),
                              text: "Quantity".tr(),
                              validate: (val) {
                                if (val
                                    .toString()
                                    .isEmpty) {
                                  return "Please Enter Quantity".tr();
                                }
                                return null;
                              },
                              type: TextInputType.text),
                        ],
                      ),
                    if(radioSelected == "Multi Category".tr())
                      defaultTextForm(context: context,
                          Controller: catsClientController,
                          prefixIcon: const Icon(Icons.category_outlined),
                          text: "Categories".tr(),
                          validate: (val) {
                            if (val
                                .toString()
                                .isEmpty) {
                              return "Please Enter Client Category".tr();
                            }
                            return null;
                          },
                          type: TextInputType.text),
                    const SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: defaultTextForm(context: context,
                              Controller: priceController,
                              prefixIcon: const Icon(Icons.money),
                              text: "Price".tr(),
                              validate: (val) {
                                if (val
                                    .toString()
                                    .isEmpty) {
                                  return "Please Enter Price".tr();
                                }
                                return null;
                              },
                              type: TextInputType.number),
                        ),
                        Text('${"Charging".tr()} ${salOfCharging.toString()}'),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text('${"Total Price:".tr()} ${totalPrice.toString()}'),
                    const SizedBox(height: 10,),
                    MaterialButton(onPressed: () {
                      String cat="";
                      int number=0;
                      if(radioSelected == "Single Category".tr()){
                        cat=catSelected;
                        number=int.parse(quantityController.text);
                      }
                      if(radioSelected == "Multi Category".tr()){
                        cat=catsClientController.text;
                        number=0;
                      }
                      if(formKey.currentState!.validate()&&OrdersHomeCubit.get(context).userProfile!=null){
                        OrdersHomeCubit.get(context).addOrders(
                            orderName: nameClientController.text,
                            conservation: stateValue,
                            city: cityController.text,
                            address: addressClientController.text,
                            type: cat,
                            employerName: OrdersHomeCubit.get(context).userProfile!.name,
                            employerPhone:  OrdersHomeCubit.get(context).userProfile!.phone,
                            employerEmail:  OrdersHomeCubit.get(context).userProfile!.email,
                            orderPhone: phoneClientController.text,
                            number: number,
                            price: double.parse(priceController.text),
                            totalPrice: totalPrice,
                            salOfCharging: salOfCharging,
                            context: context);
                      }
                    }, child: Text("Add Order".tr()),),
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
