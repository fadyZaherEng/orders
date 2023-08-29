// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/shared/components/components.dart';
import 'package:orders/shared/lang/arabic.dart';
import 'package:orders/shared/lang/english.dart';
import 'package:orders/shared/network/local/cashe_helper.dart';

class PermissionScreen extends StatelessWidget {
  PermissionScreen({super.key});

  String lang = SharedHelper.get(key: "lang");

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        lang = SharedHelper.get(key: "lang");
        return Scaffold(
          body: SafeArea(
            child: ConditionalBuilder(
                condition: OrdersHomeCubit.get(context).admins.isNotEmpty,
                builder: (ctx) => ListView.separated(
                    itemBuilder: (context, idx) =>
                        listItem(ctx, OrdersHomeCubit.get(context).admins[idx]),
                    separatorBuilder: (context, idx) => mySeparator(context),
                    itemCount: OrdersHomeCubit.get(context).admins.length),
                fallback: (ctx) => CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )),
          ),
        );
      },
    );
  }

  Widget listItem(BuildContext ctx, AdminModel admin) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none
        ),
        color: Colors.grey,
        elevation: 15,
        shadowColor: Theme.of(ctx).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Admin Email: ${admin.email}")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang == 'arabic'
                      ? arabic["Show Orders"]
                      : english["Show Orders"]),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowOrdersPermission(true, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["Appear"]
                          : english["Appear"])),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowOrdersPermission(false, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["disAppear"]
                          : english["disAppear"]))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang == 'arabic'
                      ? arabic["Show Categories"]
                      : english["Show Categories"]),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowCategoriesPermission(true, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["Appear"]
                          : english["Appear"])),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowCategoriesPermission(false, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["disAppear"]
                          : english["disAppear"]))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang == 'arabic'
                      ? arabic["Add Category"]
                      : english["Add Category"]),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminAddCatPermission(true, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["Appear"]
                          : english["Appear"])),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminAddCatPermission(false, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["disAppear"]
                          : english["disAppear"]))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang == 'arabic' ? arabic["Save"] : english["Save"]),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminSaveOrderPermission(true, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["Appear"]
                          : english["Appear"])),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminSaveOrderPermission(false, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["disAppear"]
                          : english["disAppear"]))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang == 'arabic' ? arabic["Delete"] : english["Delete"]),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminRemoveOrderPermission(true, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["Appear"]
                          : english["Appear"])),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminRemoveOrderPermission(false, admin,ctx);
                      },
                      child: Text(lang == 'arabic'
                          ? arabic["disAppear"]
                          : english["disAppear"]))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
