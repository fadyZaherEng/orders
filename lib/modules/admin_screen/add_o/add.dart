// ignore_for_file: avoid_print, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/search_using_barcode/scan.dart';
import 'package:orders/modules/emp_today_order/order.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/modules/search_phone/search.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

//checked
class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen>  {
  int minutes = 0;
  double p = 0;
  double s = 0;

  @override
  void initState() {
    super.initState();
    priceController.addListener(() {
      p = priceController.text != "" ? double.parse(priceController.text) : 0;
      s = salOfChargingController.text != ""
          ? double.parse(salOfChargingController.text)
          : 0;
      totalPrice = p + s;
      setState(() {});
    });
    salOfChargingController.addListener(() {
      p = priceController.text != "" ? double.parse(priceController.text) : 0;
      s = salOfChargingController.text != ""
          ? double.parse(salOfChargingController.text)
          : 0;
      totalPrice = p + s;
      setState(() {});
    });
  }
  var nameClientController = TextEditingController();
  var notesController = TextEditingController();
  var addressClientController = TextEditingController();
  var quantityController = TextEditingController();
  var catsClientController = TextEditingController();
  var priceController = TextEditingController();
  var phoneClientController = TextEditingController();
  var salOfChargingController = TextEditingController();
  var city = "Select City".tr();
  var paper = "Select Paper".tr();
  String stateValue = "Select State".tr();
  String statusValue = "Select Status".tr();
  String catSelected = "Select".tr();
  int quantityForMultiCats = 0;
  double totalPrice = 0;
  String radioSelected = "";
  var formKey = GlobalKey<FormState>();
  List<String> serviceType = ['تسليم وتحصيل', 'جلب مرتجعات', 'استبدال'];
  var service = "Select Service".tr();

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
                          if (val.toString().isEmpty) {
                            return "Please Enter Client Name".tr();
                          }
                          return null;
                        },
                        type: TextInputType.text),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: phoneClientController,
                      decoration: InputDecoration(
                        errorText: state is OrdersHomeValidtePhoneOrderStates
                            ? state.validate
                            : null,
                        prefixIcon: const Icon(Icons.search),
                        label: Text("Client Phone".tr()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.25)),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText2,
                      validator: (val) {
                        if (val.toString().isEmpty) {
                          return "Please Enter Client Phone".tr();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      onChanged: (phone) {
                        OrdersHomeCubit.get(context)
                            .validateOrdersByPhone(phone);
                      },
                      onFieldSubmitted: (phone) {
                        OrdersHomeCubit.get(context)
                            .validateOrdersByPhone(phone);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                            dropdownColor: Theme.of(context).primaryColor,
                            focusColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            underline: Container(),
                            hint: Text(service),
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
                            items: serviceType
                                .map(
                                  (e) => DropdownMenuItem(
                                value: e,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    service = e;
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
                                service = val;
                                setState(() {});
                              }
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DropdownButton(
                          dropdownColor: Theme.of(context).primaryColor,
                          focusColor: Theme.of(context).scaffoldBackgroundColor,
                          underline: Container(),
                          hint: Text(statusValue),
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
                          items: OrdersHomeCubit.get(context)
                              .status
                              .map(
                                (e) => DropdownMenuItem(
                              value: e,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  statusValue = e;
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
                              statusValue = val;
                              setState(() {});
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Country:Egypt".tr()),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.7,
                        child: DropdownButton(
                            dropdownColor: Theme.of(context).primaryColor,
                            focusColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            underline: Container(),
                            hint: Text(stateValue),
                            //      value: stateValue,
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
                                    city = "Select City".tr();
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if(state is !OrderGetCityLoadingStates)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.7,
                          child: DropdownButton(
                              dropdownColor: Theme.of(context).primaryColor,
                              focusColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              underline: Container(),
                              isDense: false,
                              // alignment: AlignmentDirectional.center,
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
                      ),
                    if(state is OrderGetCityLoadingStates)
                      const Center(child: CircularProgressIndicator(),),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: addressClientController,
                        prefixIcon: const Icon(Icons.location_city),
                        text: "Client Address".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return "Please Enter Client Address".tr();
                          }
                          return null;
                        },
                        type: TextInputType.text),
                    const SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    DropdownButton(
                        dropdownColor: Theme.of(context).primaryColor,
                        focusColor: Theme.of(context).scaffoldBackgroundColor,
                        underline: Container(),
                        hint: Text(paper),
                        icon: const Icon(
                          Icons.newspaper,
                          color: Colors.grey,
                        ),
                        elevation: 0,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                            color:
                            Theme.of(context).scaffoldBackgroundColor),
                        items: OrdersHomeCubit.get(context)
                            .papers
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                paper = e;
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
                            paper = val;
                            setState(() {});
                          }
                        }),
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
                    const SizedBox(
                      height: 10,
                    ),
                    if (radioSelected == "Single Category".tr())
                      Column(
                        children: [
                          DropdownButton(
                            focusColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            hint: Text(catSelected),
                            items: OrdersHomeCubit.get(context)
                                .categories
                                .map((cat) => DropdownMenuItem(
                              child: Text(cat.catName),
                              value: cat.catName,
                            ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                catSelected = val;
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextForm(
                              context: context,
                              Controller: quantityController,
                              prefixIcon:
                              const Icon(Icons.production_quantity_limits),
                              text: "Quantity".tr(),
                              validate: (val) {
                                if (val.toString().isEmpty) {
                                  return "Please Enter Quantity".tr();
                                }
                                return null;
                              },
                              type: TextInputType.number),
                        ],
                      ),
                    if (radioSelected == "Multi Category".tr())
                      Column(
                        children: [
                          TextFormField(
                            controller: catsClientController,
                            maxLines: 1000,
                            minLines: 1,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.category_outlined),
                              label: Text("Categories".tr()),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.25)),
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyText2,
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return "Please Enter Client Category".tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          defaultTextForm(
                              context: context,
                              Controller: quantityController,
                              prefixIcon:
                              const Icon(Icons.production_quantity_limits),
                              text: "Quantity".tr(),
                              validate: (val) {
                                if (val.toString().isEmpty) {
                                  return "Please Enter Quantity".tr();
                                }
                                return null;
                              },
                              type: TextInputType.number),
                        ],
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextForm(
                        context: context,
                        Controller: priceController,
                        prefixIcon: const Icon(Icons.money),
                        text: "Price".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return "Please Enter Price".tr();
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
                        text: "Charging".tr(),
                        validate: (val) {
                          if (val.toString().isEmpty) {
                            return "Please Enter Charging".tr();
                          }
                          return null;
                        },
                        type: TextInputType.number),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('${"Total Price:".tr()} ${totalPrice.toString()}'),
                    const SizedBox(
                      height: 30,
                    ),
                    if(city != "Select City".tr()&&(state is ! OrderAddOrderLoadingStates) ||
                        (state is! OrderGetCityLoadingStates))
                      SizedBox(
                        width: double.infinity,
                        height: 43,
                        child: MaterialButton(
                          color: SharedHelper.get(key: 'theme') == 'Light Theme'
                              ? Colors.deepPurple
                              : Colors.white,
                          onPressed: () {
                            String cat = "";
                            int number = 0;
                            if (radioSelected == "Single Category".tr()) {
                              cat = catSelected;
                              number = int.parse(quantityController.text);
                            }
                            if (radioSelected == "Multi Category".tr()) {
                              cat = catsClientController.text;
                              number = quantityController.text != ""
                                  ? int.parse(quantityController.text)
                                  : 0;
                            }
                            if (formKey.currentState!.validate() &&
                                OrdersHomeCubit.get(context).userProfile !=
                                    null &&
                                paper != "Select Paper".tr()) {
                              OrdersHomeCubit.get(context).addOrders(
                                  orderName: nameClientController.text,
                                  conservation: stateValue,
                                  paper: paper,
                                  city: city,
                                  serviceType: service,
                                  statusOrder: statusValue,
                                  notes: notesController.text,
                                  address: addressClientController.text,
                                  type: cat,
                                  employerName: OrdersHomeCubit.get(context)
                                      .userProfile!
                                      .name,
                                  employerPhone: OrdersHomeCubit.get(context)
                                      .userProfile!
                                      .phone,
                                  employerEmail: OrdersHomeCubit.get(context)
                                      .userProfile!
                                      .email,
                                  orderPhone: phoneClientController.text,
                                  number: number,
                                  price: double.parse(priceController.text),
                                  totalPrice: totalPrice,
                                  salOfCharging:
                                  double.parse(salOfChargingController.text),
                                  context: context);
                              nameClientController.text = "";
                              addressClientController.text = "";
                              notesController.text = "";
                              salOfChargingController.text = "";
                              quantityController.text = "";
                              catsClientController.text = "";
                              priceController.text = "";
                              phoneClientController.text = "";
                            }

                          },
                          child: Text("Add Order".tr(),
                              style: TextStyle(
                                  color: SharedHelper.get(key: 'theme') ==
                                      'Light Theme'
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    if(city == "Select City".tr())
                      const Center(child: CircularProgressIndicator(),),
                    if(state is OrderAddOrderLoadingStates)
                      const Center(child: CircularProgressIndicator(),),
                    if(state is OrderGetCityLoadingStates)
                      const Center(child: CircularProgressIndicator(),),
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
