// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/add_cat/add_cat.dart';
import 'package:orders/modules/admin_screen/get_cat/cat.dart';
import 'package:orders/modules/admin_screen/permission/permission.dart';
import 'package:orders/modules/admin_screen/search_using_barcode/scan.dart';
import 'package:orders/modules/admin_screen/share_order/copy_orders.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class AdminShowOrders extends StatefulWidget {
  const AdminShowOrders({super.key});

  @override
  State<AdminShowOrders> createState() => _AdminShowOrdersState();
}

class _AdminShowOrdersState extends State<AdminShowOrders> {
  @override
  void initState() {
    super.initState();
    OrdersHomeCubit.get(context).getAdminsProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    if(OrdersHomeCubit
                        .get(context)
                        .currentIndex == 0)
                      Text("Total Price: ".tr()),
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
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin != null
                          && OrdersHomeCubit
                              .get(context)
                              .currentAdmin!
                              .addCat)
                        DropdownMenuItem(
                          value: "cat",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(
                                  context, const AddCategoryScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Text("Add Category".tr()),
                            ),
                          ),
                        ),
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin != null && OrdersHomeCubit
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Text("Show Categories".tr()),
                            ),
                          ),
                        ),
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin != null
                          && OrdersHomeCubit
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Text("Share Orders".tr()),
                            ),
                          ),
                        ),
                      DropdownMenuItem(
                        value: "today",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                              context, const ScannerScreen(),);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                            child: Text('Search By Barcode'.tr()),
                          ),
                        ),
                      ),
                      if(OrdersHomeCubit
                          .get(context)
                          .currentAdmin != null
                          && OrdersHomeCubit
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5),
                              child: Text("Permission".tr()),
                            ),
                          ),
                        ),
                      DropdownMenuItem(
                        value: "theme",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).modeChange();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                            child: Text("Change Theme".tr()),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "lang",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            OrdersHomeCubit.get(context).langChange(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                            child: Text("Change lang".tr()),
                          ),
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,bottom: 5),
                            child: Text("Log Out".tr()),
                          ),
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
              BottomNavigationBarItem(icon: const Icon(Icons.home),
                  label: "Show Orders".tr()),
              BottomNavigationBarItem(icon: const Icon(Icons.today),
                  label: 'Today Orders'.tr()),
              BottomNavigationBarItem(icon: const Icon(Icons.search),
                  label: 'Search By Date'.tr()),
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
