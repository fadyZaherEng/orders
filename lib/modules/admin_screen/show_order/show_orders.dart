// ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/modules/admin_screen/add_admins/add_admin.dart';
import 'package:orders/modules/admin_screen/add_cat/add_cat.dart';
import 'package:orders/modules/admin_screen/add_city/city.dart';
import 'package:orders/modules/admin_screen/add_states/states.dart';
import 'package:orders/modules/admin_screen/change_password/pass.dart';
import 'package:orders/modules/admin_screen/gain/gain.dart';
import 'package:orders/modules/admin_screen/get_cat/cat.dart';
import 'package:orders/modules/admin_screen/money/money.dart';
import 'package:orders/modules/admin_screen/permission/permission.dart';
import 'package:orders/modules/admin_screen/search_using_barcode/scan.dart';
import 'package:orders/modules/login/login.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
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
                      SingleChildScrollView(
                        child: Text(
                          OrdersHomeCubit.get(context)
                              .totalOfAllOrders
                              .toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            titleSpacing: 0,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
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
                      if (OrdersHomeCubit.get(context).currentAdmin != null &&
                          OrdersHomeCubit.get(context).currentAdmin!.addCat)
                        DropdownMenuItem(
                          value: "money",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(context, MoneyScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text("Add Money".tr()),
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text("Calculate The Gain".tr()),
                          ),
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text("Add Category".tr()),
                          ),
                        ),
                      ),
                      if (OrdersHomeCubit.get(context).currentAdmin != null &&
                          OrdersHomeCubit.get(context)
                              .currentAdmin!
                              .showCategories)
                        DropdownMenuItem(
                          value: "Show get",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(
                                  context, ShowCategoriesScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text("Show Categories".tr()),
                            ),
                          ),
                        ),
                      if (OrdersHomeCubit.get(context).currentAdmin != null &&
                          OrdersHomeCubit.get(context).currentAdmin!.showOrders)
                        DropdownMenuItem(
                          value: "copy",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              createExcelSheet();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                              context,
                              const ScannerScreen(),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text('Search By Barcode'.tr()),
                          ),
                        ),
                      ),
                      if (OrdersHomeCubit.get(context).currentAdmin != null &&
                          OrdersHomeCubit.get(context).currentAdmin!.email ==
                              'abanobshokry9@gmail.com')
                        DropdownMenuItem(
                          value: "permission",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(context, PermissionScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text("Permission".tr()),
                            ),
                          ),
                        ),
                      if (OrdersHomeCubit.get(context).currentAdmin != null &&
                          OrdersHomeCubit.get(context).currentAdmin!.email ==
                              'abanobshokry9@gamil.com')
                        DropdownMenuItem(
                          value: "add Admin",
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              navigateToWithReturn(context, AddAdminScreen());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text("Add Admin".tr()),
                            ),
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
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text("Change Password".tr()),
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
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text("Log Out".tr()),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (idx) {},
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    navigateToWithReturn(context, AddCityScreen());
                  },
                  icon: const Icon(
                    Icons.location_city,
                    size: 20,
                  )),
              IconButton(
                  onPressed: () {
                    navigateToWithReturn(context, AddStatesScreen());
                  },
                  icon: Text(
                    "States".tr(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 9,
                        fontWeight: FontWeight.normal),
                  )),
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
  void createExcelSheet()async {
    excel.Workbook workbook = excel.Workbook();
    excel.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText("Consignee_Name");
    sheet.getRangeByIndex(1, 2).setText("City");
    sheet.getRangeByIndex(1, 3).setText("Area");
    sheet.getRangeByIndex(1, 4).setText("Address");
    sheet.getRangeByIndex(1, 5).setText("Phone_1");
    sheet.getRangeByIndex(1, 6).setText("Employee_Name");
    sheet.getRangeByIndex(1, 7).setText("Number");
    sheet.getRangeByIndex(1, 8).setText("Once");
    sheet.getRangeByIndex(1, 9).setText("Cell");
    sheet.getRangeByIndex(1, 10).setText("Item_Name");
    sheet.getRangeByIndex(1, 11).setText("Item_Description");
    sheet.getRangeByIndex(1, 12).setText("COD");
    sheet.getRangeByIndex(1, 13).setText("Weight");
    sheet.getRangeByIndex(1, 14).setText("Size");
    sheet.getRangeByIndex(1, 15).setText("Service_Type");
    sheet.getRangeByIndex(1, 16).setText("notes");

    for (int i = 0; i < OrdersHomeCubit.get(context).orders.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(OrdersHomeCubit.get(context).orders[i].orderName);
      sheet.getRangeByIndex(i + 2, 2).setText(OrdersHomeCubit.get(context).orders[i].conservation);
      sheet.getRangeByIndex(i + 2, 3).setText(OrdersHomeCubit.get(context).orders[i].city);
      sheet.getRangeByIndex(i + 2, 4).setText(OrdersHomeCubit.get(context).orders[i].address);
      sheet.getRangeByIndex(i + 2, 5).setText(OrdersHomeCubit.get(context).orders[i].orderPhone);
      sheet.getRangeByIndex(i + 2, 6).setText(OrdersHomeCubit.get(context).orders[i].employerName);
      sheet.getRangeByIndex(i + 2, 7).setValue("");
      sheet.getRangeByIndex(i + 2, 8).setText(" ");
      sheet.getRangeByIndex(i + 2, 9).setText(" ");
      sheet.getRangeByIndex(i + 2, 10).setText(OrdersHomeCubit.get(context).orders[i].type);
      sheet.getRangeByIndex(i + 2, 11).setText(" ");
      sheet.getRangeByIndex(i + 2, 12).setNumber(OrdersHomeCubit.get(context).orders[i].totalPrice);
      sheet.getRangeByIndex(i + 2, 13).setText(" ");
      sheet.getRangeByIndex(i + 2, 14).setText(" ");
      sheet.getRangeByIndex(i + 2, 15).setText(OrdersHomeCubit.get(context).orders[i].serviceType);
      sheet.getRangeByIndex(i + 2, 16).setText(OrdersHomeCubit.get(context).orders[i].notes);
    }
    //save
    final List<int>bytes = workbook.saveAsStream();
    ///File('orders.xlsx').writeAsBytes(bytes);
    await workbook.save();
    workbook.dispose();
    final String path=(await getApplicationCacheDirectory()).path;
    final String fileName='$path/orders.xlsx';
    final File file=File(fileName);
    await file.writeAsBytes(bytes,flush: true);
    OpenFile.open(fileName);
    //Share.share(fileName);
  }
}
