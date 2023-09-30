// ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/layout/home_screen.dart';
import 'package:orders/modules/admin_remove/remove_cat/remove_cat.dart';
import 'package:orders/modules/admin_remove/remove_import/remove_import.dart';
import 'package:orders/modules/admin_remove/remove_money/remove_money.dart';
import 'package:orders/modules/admin_remove/remove_page/remove_page.dart';
import 'package:orders/modules/admin_remove/remove_user/remove_user.dart';
import 'package:orders/modules/admin_screen/add%20papers/papers.dart';
import 'package:orders/modules/admin_screen/add_admins/add_admin.dart';
import 'package:orders/modules/admin_screen/add_cat/add_cat.dart';
import 'package:orders/modules/admin_screen/add_city/city.dart';
import 'package:orders/modules/admin_screen/add_source/source.dart';
import 'package:orders/modules/admin_screen/add_states/states.dart';
import 'package:orders/modules/admin_screen/change_password/pass.dart';
import 'package:orders/modules/admin_screen/edit_status/edit.dart';
import 'package:orders/modules/admin_screen/filter_order/filter.dart';
import 'package:orders/modules/admin_screen/gain/gain.dart';
import 'package:orders/modules/admin_screen/get_cat/cat.dart';
import 'package:orders/modules/admin_screen/money/money.dart';
import 'package:orders/modules/admin_screen/permission/permission.dart';
import 'package:orders/modules/admin_screen/search_using_barcode/scan.dart';
import 'package:orders/modules/admin_screen/showPapers/papers.dart';
import 'package:orders/modules/admin_screen/users/permision.dart';
import 'package:orders/modules/admin_screen/users_block/user.dart';
import 'package:orders/modules/admin_screen/work/work.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/modules/search_phone/search.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

//checked
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
            automaticallyImplyLeading: false,
            title: OrdersHomeCubit.get(context).currentIndex == 0
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          if (OrdersHomeCubit.get(context).currentIndex == 0)
                            Text(
                              "Total Price: ".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor),
                            ),
                          if (OrdersHomeCubit.get(context).currentIndex == 0)
                            Text(
                              OrdersHomeCubit.get(context)
                                  .totalOfAllOrders
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (OrdersHomeCubit.get(context).currentIndex == 0)
                            Text(
                              "Total Number: ".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor),
                            ),
                          if (OrdersHomeCubit.get(context).currentIndex == 0)
                            Text(
                              OrdersHomeCubit.get(context)
                                  .orders
                                  .length
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Theme.of(context).primaryColor),
                            ),
                        ],
                      ),
                    ),
                  )
                : OrdersHomeCubit.get(context).currentIndex == 1
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Price: ".tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                OrdersHomeCubit.get(context)
                                    .todayOrdersPrice
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Total Number: ".tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                OrdersHomeCubit.get(context)
                                    .todayOrdersNumber
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Text(
                      "Total Price: ".tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      OrdersHomeCubit.get(context)
                          .priceSearchOrdersDate
                          .toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Total Number: ".tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Theme.of(context).primaryColor),
                    ),
                    Text(
                      OrdersHomeCubit.get(context)
                          .numSearchOrdersDate
                          .toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            titleSpacing: 0,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: DropdownButton(
                    dropdownColor: Theme.of(context).primaryColor,
                    focusColor: Theme.of(context).scaffoldBackgroundColor,
                    underline: Container(),
                    icon: Icon(
                      Icons.reorder,
                      color: Theme.of(context).primaryColor,
                    ),
                    elevation: 0,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    items: [
                      // if (OrdersHomeCubit.get(context).currentAdmin != null &&
                      //     OrdersHomeCubit.get(context).currentAdmin!.addCat)
                        DropdownMenuItem(
                          value: "money",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(context, MoneyScreen());
                            },
                            child: Text("Add Money".tr()),
                          ),
                        ),
                      DropdownMenuItem(
                        value: "block",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, const UserBlockScreen());
                          },
                          child: Text("Block User".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "source",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, const AddSourceScreen());
                          },
                          child: Text("Add Source".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "get source",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, const ShowSourceScreen());
                          },
                          child: Text("Show Source".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "لل",
                        child: TextButton(
                          onPressed: () {
                            navigateToWithReturn(context, AddCityScreen());
                          },
                          child:  Text(
                            "Add City".tr(),
                            style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "kjh",
                        child: TextButton(
                          onPressed: () {
                            navigateToWithReturn(context, AddStatesScreen());
                          },
                          child: Text(
                            "States".tr(),
                            style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "gain",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, const GainScreen());
                          },
                          child: Text("Calculate The Gain".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "cat",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, const AddCategoryScreen());
                          },
                          child: Text("Add Category".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "admin",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, UserPermissionScreen());
                          },
                          child: Text("User Permission".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "edit",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, EditOrdersScreen());
                          },
                          child: Text("Edit Status".tr()),
                        ),
                      ),
                      // if (OrdersHomeCubit.get(context).currentAdmin != null &&
                      //     OrdersHomeCubit.get(context)
                      //         .currentAdmin!
                      //         .showCategories)
                        DropdownMenuItem(
                          value: "Show get",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(
                                  context, const ShowCategoriesScreen());
                            },
                            child: Text("Show Categories".tr()),
                          ),
                        ),
                      // if (OrdersHomeCubit.get(context).currentAdmin != null &&
                      //     OrdersHomeCubit.get(context).currentAdmin!.showOrders)
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
                        value: "phone",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                              context,
                              SearchOrderPhoneScreen(),
                            );
                          },
                          child: Text("Search Phone".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "filter",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                              context,
                              const FilterOrdersScreen(),
                            );
                          },
                          child: Text('Filter Order'.tr()),
                        ),
                      ),
                      // DropdownMenuItem(
                      //   value: "permission",
                      //   child: InkWell(
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //       navigateToWithReturn(context, PermissionScreen());
                      //     },
                      //     child: Text("Permission".tr()),
                      //   ),
                      // ),
                      DropdownMenuItem(
                        value: "add Page",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, AddPapersScreen());
                          },
                          child: Text("Add Page".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "add order",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context,const HomeScreen());
                          },
                          child: Text("Add Order".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "get Page",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, const ShowPapersDetailsScreen());
                          },
                          child: Text("Show Pages".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "add Admin",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(context, AddAdminScreen());
                          },
                          child: Text("Add Admin".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "settings",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, ChangeAdminPasswordScreen());
                          },
                          child: Text("Change Password".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "removeCat",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, RemoveCategoriesScreen());
                          },
                          child: Text("Remove Category".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "removeIm",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, RemoveImportsScreen());
                          },
                          child: Text("Remove Imports".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "removeMoney",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, RemoveMoneyScreen());
                          },
                          child: Text("Remove Money".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "removeO",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        OrdersHomeCubit.get(context).removeAllOrders();
                                      },
                                      child: Text("Remove All Orders".tr()),
                                    ),
                                  );
                                });
                          },
                          child: Text("Remove All Orders".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "removePage",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, RemovePageScreen());
                          },
                          child: Text("Remove Pages".tr()),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "removeUser",
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigateToWithReturn(
                                context, RemoveUserScreen());
                          },
                          child: Text("Remove Users".tr()),
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
          body: OrdersHomeCubit.get(context)
              .screens[OrdersHomeCubit.get(context).currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: "Show Orders".tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.today), label: 'Today Orders'.tr()),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.search), label: 'Search By Date'.tr()),
            ],
            currentIndex: OrdersHomeCubit.get(context).currentIndex,
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
