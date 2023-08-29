// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orders/layout/cubit/cubit.dart';
import 'package:orders/layout/cubit/states.dart';
import 'package:orders/models/admin_model.dart';
import 'package:orders/shared/components/components.dart';

class PermissionScreen extends StatelessWidget {
  PermissionScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersHomeCubit, OrdersHomeStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
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
                  Text("Show Orders".tr()),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowOrdersPermission(true, admin,ctx);
                      },
                      child: Text("Appear".tr())),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowOrdersPermission(false, admin,ctx);
                      },
                      child: Text("disAppear".tr()))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Show Categories".tr()),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowCategoriesPermission(true, admin,ctx);
                      },
                      child: Text("Appear".tr())),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminShowCategoriesPermission(false, admin,ctx);
                      },
                      child: Text("disAppear".tr()))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Category".tr()),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminAddCatPermission(true, admin,ctx);
                      },
                      child: Text("Appear".tr())),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminAddCatPermission(false, admin,ctx);
                      },
                      child: Text("disAppear".tr()))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Save".tr()),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminSaveOrderPermission(true, admin,ctx);
                      },
                      child: Text("Appear".tr())),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminSaveOrderPermission(false, admin,ctx);
                      },
                      child: Text("disAppear".tr()))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delete".tr()),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminRemoveOrderPermission(true, admin,ctx);
                      },
                      child: Text("Appear".tr())),
                  TextButton(
                      onPressed: () {
                        OrdersHomeCubit.get(ctx)
                            .adminRemoveOrderPermission(false, admin,ctx);
                      },
                      child: Text("disAppear".tr()))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
