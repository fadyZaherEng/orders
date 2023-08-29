// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/add_cat/add_cat.dart';
import 'package:orders/modules/admin_screen/get_cat/cat.dart';
import 'package:orders/modules/admin_screen/permission/permission.dart';
import 'package:orders/modules/admin_screen/scanner/scan.dart';
import 'package:orders/modules/admin_screen/search_using_barcode/search.dart';
import 'package:orders/modules/admin_screen/share_order/copy_orders.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
import 'package:orders/shared/styles/Icon_broken.dart';

class AdminShowOrders extends StatefulWidget {
  const AdminShowOrders({super.key});

  @override
  State<AdminShowOrders> createState() => _AdminShowOrdersState();
}

class _AdminShowOrdersState extends State<AdminShowOrders> {
  String lang = SharedHelper.get(key: "lang");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrdersHomeCubit.get(context).getAdminsProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        lang = SharedHelper.get(key: "lang");
        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(OrdersHomeCubit
                      .get(context)
                      .titles[OrdersHomeCubit
                      .get(context)
                      .currentIndex]),
                  if(OrdersHomeCubit
                      .get(context)
                      .currentIndex == 0)
                    Text(OrdersHomeCubit
                        .get(context)
                        .totalOfAllOrders
                        .toString()),
                ],
              ),
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
                    icon: Icon(Icons.reorder, color: Theme
                        .of(context)
                        .primaryColor,),
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
                      if(OrdersHomeCubit.get(context).currentAdmin != null
                          && OrdersHomeCubit.get(context).currentAdmin!.addCat)
                        DropdownMenuItem(
                          value: "cat",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(
                                  context, const AddCategoryScreen());
                            },
                            child: Text(lang == 'arabic'
                                ? arabic["Add Category"]
                                : english["Add Category"]),
                          ),
                        ),
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin!=null&&OrdersHomeCubit
                          .get(context)
                          .currentAdmin!
                          .showCategories)
                        DropdownMenuItem(
                          value: "Show get",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(
                                  context, const ShowCategoriesScreen());
                            },
                            child: Text(lang == 'arabic'
                                ? arabic["Show Categories"]
                                : english["Show Categories"]),
                          ),
                        ),
                      if(OrdersHomeCubit.get(context).currentAdmin != null
                          &&OrdersHomeCubit
                          .get(context)
                          .currentAdmin!
                          .showOrders)
                        DropdownMenuItem(
                          value: "copy",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(
                                  context, DataTableScreen(OrdersHomeCubit
                                  .get(context)
                                  .orders));
                            },
                            child: Text(lang == 'arabic'
                                ? arabic["Share Orders"]
                                : english["Share Orders"]),
                          ),
                        ),
                      DropdownMenuItem(
                        value: "today",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                              context, const SearchByBarcodeScreen(),);
                          },
                          child: Text(lang == 'arabic'
                              ? arabic['Search By Barcode']
                              : english['Search By Barcode']),
                        ),
                      ),
                      if(OrdersHomeCubit.get(context).currentAdmin != null
                          &&OrdersHomeCubit
                          .get(context)
                          .currentAdmin!
                          .email == 'x@gmail.com')
                        DropdownMenuItem(
                          value: "permission",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(context, PermissionScreen());
                            },
                            child: Text(lang == 'arabic'
                                ? arabic["Permission"]
                                : english["Permission"]),
                          ),
                        ),
                      DropdownMenuItem(
                        value: "scan",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, const ScannerScreen());
                          },
                          child: const Text("Scanner"),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "theme",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).modeChange();
                          },
                          child: Text(lang == 'arabic'
                              ? arabic["Change Theme"]
                              : english["Change Theme"]),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "lang",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).langChange();
                          },
                          child: Text(lang == 'arabic'
                              ? arabic["Change lang"]
                              : english["Change lang"]),
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
                          child: Text(lang == 'arabic'
                              ? arabic["Log Out"]
                              : english["Log Out"]),
                        ),
                      ),
                    ],
                    onChanged: (idx) {},
                  ),
                ),
              ),
            ],
          ),
          body: OrdersHomeCubit
              .get(context)
              .screens[OrdersHomeCubit
              .get(context)
              .currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: const Icon(IconBroken.Home),
                  label: lang == 'arabic'
                      ? arabic["Show Orders"]
                      : english["Show Orders"]),
              BottomNavigationBarItem(icon: const Icon(Icons.today),
                  label: lang == 'arabic'
                      ? arabic['Today Orders']
                      : english['Today Orders']),
              BottomNavigationBarItem(icon: const Icon(IconBroken.Search),
                  label: lang == 'arabic'
                      ? arabic['Search By Date']
                      : english['Search By Date']),
            ],
            currentIndex: OrdersHomeCubit
                .get(context)
                .currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (idx) {
              OrdersHomeCubit.get(context).changeNav(idx);
            },
          ),
        );
      },
    );
  }
}
